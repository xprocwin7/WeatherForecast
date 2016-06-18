//
//  XPMainViewController.m
//  WeatherForecast
//
//  Created by dragon on 16/6/17.
//  Copyright © 2016年 win. All rights reserved.
//

#import "XPMainViewController.h"
#import "XPHeaderView.h"
#import "RESideMenu.h"
#import "XPDataManager.h"
#import "XPLocationManager.h"
#import "XPNetworkManager.h"
#import "TSMessage.h"
#import "XPDaily.h"
#import "XPHourly.h"
#import "UIImageView+WebCache.h"
#import "XPHeader.h"
#import "MJRefresh.h"

@interface XPMainViewController ()<UITableViewDataSource, UITableViewDelegate>
//tableView
@property (nonatomic, strong) UITableView *tableView;
//保存用户的位置
@property (nonatomic, strong) CLLocation *userLocation;
//每小时的数据
@property (nonatomic, strong) NSArray *hourlyArray;
//每天的数据
@property (nonatomic, strong) NSArray *dailyArray;

//地理编码
@property (nonatomic, strong) CLGeocoder *geocoder;
//头部视图
@property (nonatomic, strong) XPHeaderView *headerView;


@end

@implementation XPMainViewController

- (CLGeocoder *)geocoder {
    if (!_geocoder) {
        _geocoder = [CLGeocoder new];
    }
    return _geocoder;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //添加假数据，为了调试每天和每小时数据
    //    [self justTestDailyHourlyData];
    
    //监听通知
    [self listenNotification];
    
    //创建tableView
    [self createTableView];
    //创建头部视图
    [self createHeaderView];
    ////创建下拉刷新控件
    [self createRefreshControl];
    
    //获取用户的位置并发送请求
    [self getLocationAndSendRequest];
}

- (void)listenNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(listenChangeCity:) name:@"DidCityChange" object:nil];
}
- (void)listenChangeCity:(NSNotification *)notification {
    //获取传过来的参数
    NSString *cityName = notification.userInfo[@"CityName"];
    //汉字：上海->shanghai
    //笔记中的方式二
    NSLog(@"城市名字:%@",cityName);
    
    //地理编码获取城市拼音
    [self.geocoder geocodeAddressString:cityName completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        CLPlacemark *placemark = [placemarks lastObject];
        //将服务器返回地标中location值赋值self.userLocation(!!!!!)
        self.userLocation = placemark.location;
        NSString *cityStr = placemark.addressDictionary[@"City"];
        //更新城市label
        self.headerView.cityLabel.text = cityStr;
        
        NSLog(@"城市拼音:%@;000--%f", cityStr, self.userLocation.coordinate.latitude);
    }];
    
    //发送请求
    [self sendRequestToServer];
}


- (void)justTestDailyHourlyData {
    //1.获取json文件路径
    NSString *jsonPath = [[NSBundle mainBundle] pathForResource:@"weather" ofType:@"json"];
    //2.NSData数据接收
    NSData *data = [[NSData alloc] initWithContentsOfFile:jsonPath];
    //3.JSON转成OC对象
    id responseObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    self.dailyArray = [XPDataManager getAllDailyData:responseObject];
    self.hourlyArray = [XPDataManager getAllHourlyData:responseObject];
    
}

#pragma mark - 界面相关方法

- (void)parseAndUpdateHeaderView:(id)responseObject {
    //解析jsonDic(模型层/子线程)
    XPHeader *header = [XPHeader getHeaderData:responseObject];
    
    //query: Lat 39.123 and Lon 116.456
    if (self.userLocation) {
        [self.geocoder reverseGeocodeLocation:self.userLocation completionHandler:^(NSArray *placemarks, NSError *error) {
            if (!error) {
                //反地理编码成功
                CLPlacemark *placemark = [placemarks firstObject];
                //城市名称
                self.headerView.cityLabel.text = placemark.addressDictionary[@"City"];
            }
        }];
    }
    
    //更新头部视图控件(4个UILabel)
    self.headerView.temperatureLabel.text = header.weatherTemp;
    
    //最高、最低温度
    self.headerView.hiloLabel.text = [NSString stringWithFormat:@"%@° / %@°",header.minTemp, header.maxTemp];
    
    //天气图标(开始下载图片)
    //    [self.headerView.iconView sd_setImageWithURL:[NSURL URLWithString:header.iconUrlStr] placeholderImage:[UIImage imageNamed:@"placeholder"]];

    self.headerView.iconView.image = [UIImage imageNamed:header.iconUrlStr];
    
    //天气描述信息
    self.headerView.conditionsLabel.text = header.weatherDesc;
    
}

- (void)createRefreshControl {
    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadNewData方法）
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(sendRequestToServer)];
    // 隐藏时间
    header.lastUpdatedTimeLabel.hidden = YES;
    
    // 马上进入刷新状态
    [header beginRefreshing];
    // 设置header
    self.tableView.mj_header = header;
}

- (void)createHeaderView {
    self.headerView = [[XPHeaderView alloc] initWithFrame:SCREEN_BOUNDS];
    [self.headerView.menuButton addTarget:self action:@selector(clickMenuButton) forControlEvents:UIControlEventTouchUpInside];
    self.tableView.tableHeaderView = self.headerView;
}

- (void)createTableView {
    self.tableView = [UITableView new];
    self.tableView.frame = SCREEN_BOUNDS;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.backgroundColor = [UIColor clearColor];
    //设置tableView paging
    self.tableView.pagingEnabled = YES;
    
    //需求：不想随着tableView的滚动而滚动
    //添加
    [self.view addSubview:self.tableView];
}

#pragma mark - 请求相关方法
- (void)getLocationAndSendRequest {
    [XPLocationManager getUserLocation:^(double lat, double lon) {
        CLLocation *location = [[CLLocation alloc] initWithLatitude:lat longitude:lon];
        //赋值
        self.userLocation = location;
        
        [self sendRequestToServer];
    }];
}

- (void)sendRequestToServer {
    //设置TSMessage默认控制器
    [TSMessage setDefaultViewController:self];
    
    //URL
    NSString *urlStr = [NSString stringWithFormat:@"http://api.worldweatheronline.com/free/v2/weather.ashx?q=%f,%f&num_of_days=5&format=json&tp=4&key=cf11c561a51b35e62ccb5c160f07d", self.userLocation.coordinate.latitude, self.userLocation.coordinate.longitude];
    //NetworkManger
    [XPNetworkManager sendGetRequestWithUrl:urlStr parameters:nil success:^(id responseObject) {
        //        NSLog(@"服务器返回的json数据:%@", responseObject);
        
        //更新头部视图
        [self parseAndUpdateHeaderView:responseObject];
        
        //调用TRDataManager中的getAllDailyData
        self.dailyArray = [XPDataManager getAllDailyData:responseObject];
        self.hourlyArray = [XPDataManager getAllHourlyData:responseObject];
        
        //tableView重新加载数据
        [self.tableView reloadData];
        
        //// 拿到当前的下拉刷新控件，结束刷新状态
        [self.tableView.mj_header endRefreshing];
        
    } failure:^(NSError *error) {
        NSLog(@"服务器请求失败:%@", error.userInfo);
        //显示通知给用户
        [TSMessage showNotificationWithTitle:@"提示" subtitle:@"请稍后再试" type:TSMessageNotificationTypeWarning];
        
        //// 拿到当前的下拉刷新控件，结束刷新状态
        [self.tableView.mj_header endRefreshing];
    }];
}


#pragma mark - 按钮触发方法
- (void)clickMenuButton {
    //显示左边的控制器
    [self.sideMenuViewController presentLeftMenuViewController];
}

#pragma mark - UITableView相关方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return section == 0 ? self.hourlyArray.count + 1 : self.dailyArray.count + 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
    }
    
    //设置cell属性
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.textColor = [UIColor whiteColor];
    //设置cell不可点中
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            [self configFirstCell:cell withText:@"Hourly Forecast Info."];
        } else {
            XPHourly *hourly = self.hourlyArray[indexPath.row - 1];
            cell.textLabel.text = hourly.time;
            cell.detailTextLabel.text = hourly.tempC;
            //下载图片(耗时:子线程下载；回到主线程更新cell.imageView.image; 防止重复下载/图片缓存原理/过期政策) -> SDWebImage
            //            [cell.imageView sd_setImageWithURL:[NSURL URLWithString:hourly.iconUrl] placeholderImage:[UIImage imageNamed:@"placeholder"]];
            
            cell.imageView.image = [UIImage imageNamed:hourly.iconUrl];
        }
    } else {
        if (indexPath.row == 0) {
            [self configFirstCell:cell withText:@"Daily Forecast Info."];
        } else {
            XPDaily *daily = self.dailyArray[indexPath.row - 1];
            cell.textLabel.text = daily.date;
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ / %@", daily.mintempC, daily.maxtempC];
            //            //下载图片
            //            [cell.imageView sd_setImageWithURL:[NSURL URLWithString:daily.iconUrl] placeholderImage:[UIImage imageNamed:@"placeholder"]];

            cell.imageView.image = [UIImage imageNamed:daily.iconUrl];
        }
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    //获取每个section的行数
    NSInteger rowCount = [self tableView:tableView numberOfRowsInSection:indexPath.section];
    return SCREEN_HEIGHT / rowCount;
}

- (void)configFirstCell:(UITableViewCell *)cell withText:(NSString *)text {
    cell.textLabel.text = text;
    cell.detailTextLabel.text = nil;
    cell.imageView.image = nil;
    
}

@end

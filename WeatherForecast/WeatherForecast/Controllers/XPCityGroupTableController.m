//
//  XPCityGroupTableController.m
//  WeatherForecast
//
//  Created by dragon on 16/6/17.
//  Copyright © 2016年 win. All rights reserved.
//

#import "XPCityGroupTableController.h"
#import "XPDataManager.h"
#import "XPCityGroup.h"

@interface XPCityGroupTableController ()
@property (nonatomic, strong) NSArray *cityGroupArray;
@end

@implementation XPCityGroupTableController

- (NSArray *)cityGroupArray {
    if (!_cityGroupArray) {
        _cityGroupArray = [XPDataManager getAllCityGroups];
    }
    return _cityGroupArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"城市列表";
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleDone target:self action:@selector(clickBackItem)];
    self.navigationItem.leftBarButtonItem = backItem;
}
- (void)clickBackItem {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.cityGroupArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    XPCityGroup *cityGroup = self.cityGroupArray[section];
    return cityGroup.cities.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    // Configure the cell...
    XPCityGroup *cityGroup = self.cityGroupArray[indexPath.section];
    cell.textLabel.text = cityGroup.cities[indexPath.row];
    
    return cell;
}
//返回section的头部文本
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    XPCityGroup *cityGroup = self.cityGroupArray[section];
    return cityGroup.title;
}

//返回tableViewIndex数组
- (nullable NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    //方式一
    //    NSMutableArray *titleMutablArray = [NSMutableArray array];
    //    for (TRCityGroup *cityGroup in self.cityGroupArray) {
    //        [titleMutablArray addObject:cityGroup.title];
    //    }
    //    return [titleMutablArray copy];
    //方式二
    return [self.cityGroupArray valueForKeyPath:@"title"];
    
}

//选中那一行
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //获取模型对象
    XPCityGroup *cityGroup = self.cityGroupArray[indexPath.section];
    //发送通知，包含参数(选择的城市名字)
    [[NSNotificationCenter defaultCenter] postNotificationName:@"DidCityChange" object:self userInfo:@{@"CityName":cityGroup.cities[indexPath.row]}];
    //收回控制器
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end

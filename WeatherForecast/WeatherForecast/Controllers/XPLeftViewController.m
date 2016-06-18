//
//  XPLeftViewController.m
//  WeatherForecast
//
//  Created by dragon on 16/6/17.
//  Copyright © 2016年 win. All rights reserved.
//

#import "XPLeftViewController.h"
#import "XPCityGroupTableController.h"

@interface XPLeftViewController ()<UITableViewDataSource, UITableViewDelegate>

@end

CGFloat cellHeight = 50;

@implementation XPLeftViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //创建tableView
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, (SCREEN_HEIGHT -cellHeight*2)/2, SCREEN_WIDTH, cellHeight*2)];
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.backgroundColor = [UIColor clearColor];
    //seperator线的设置
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tableView];
}
#pragma mark - UITableView DataSource/Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.backgroundColor = [UIColor clearColor];
        //cell的文本颜色
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        //        cell.selectedBackgroundView = [UIView new];
    }
    NSArray *titles = @[@"切换城市", @"其它"];
    NSArray *images = @[@"IconSettings", @"IconProfile"];
    cell.textLabel.text = titles[indexPath.row];
    cell.imageView.image = [UIImage imageNamed:images[indexPath.row]];
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return cellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        //创建城市视图控制器对象(navController)
        XPCityGroupTableController *cityGroupViewController = [XPCityGroupTableController new];
        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:cityGroupViewController];
        //显示
        [self presentViewController:navController animated:YES completion:nil];
    }
    
}


@end

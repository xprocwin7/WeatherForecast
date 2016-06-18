//
//  XPLocationManager.m
//  WeatherForecast
//
//  Created by dragon on 16/6/17.
//  Copyright © 2016年 win. All rights reserved.
//

#import "XPLocationManager.h"
#import <UIKit/UIKit.h>

@interface XPLocationManager()<CLLocationManagerDelegate>
@property (nonatomic, strong) CLLocationManager *manager;
@property (nonatomic, copy) void (^saveLocation)(double lat, double lon);

@end

@implementation XPLocationManager
//懒加载的方式初始化
//单例: 一个类的唯一一个实例对象
+ (id)sharedLoationManager {
    static XPLocationManager *locationManager = nil;
    if (!locationManager) {
        locationManager = [[XPLocationManager alloc] init];
    }
    return locationManager;
}

//重写init方法初始化manager对象/征求用户同意
- (instancetype)init {
    if (self = [super init]) {
        self.manager = [CLLocationManager new];
        
        //判断iOS版本
        if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
            //Info.plist添加key
            [self.manager requestWhenInUseAuthorization];
        }
        self.manager.delegate = self;
    }
    return self;
}


+ (void)getUserLocation:(void (^)(double, double))locationBlock {
    XPLocationManager *locationManager = [XPLocationManager sharedLoationManager];
    [locationManager getUserLocations:locationBlock];
}

- (void)getUserLocations:(void (^)(double, double))locationBlock {
    //用户没有同意/没有开启定位功能
    if (![CLLocationManager locationServicesEnabled]) {
        //告诉用户消息无法定位
        return;
    }
    //!!!将saveLocationBlock赋值给locationBlock
    //copy函数指针/函数体
    _saveLocation = [locationBlock copy];
    
    //设定精度(调用频率)
    self.manager.distanceFilter = 500;
    //同意/开启 -> 开始定位
    [self.manager startUpdatingLocation];
    
}
#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    //防止调用多次
    //经纬度
    CLLocation *location = [locations lastObject];
    
    //block传参数(调用block)
    _saveLocation(location.coordinate.latitude, location.coordinate.longitude);
    
}


@end

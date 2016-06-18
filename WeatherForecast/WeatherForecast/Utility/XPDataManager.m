//
//  XPDataManager.m
//  WeatherForecast
//
//  Created by dragon on 16/6/17.
//  Copyright © 2016年 win. All rights reserved.
//

#import "XPDataManager.h"
#import "XPCityGroup.h"
#import "XPDaily.h"
#import "XPHourly.h"

@implementation XPDataManager

//单例：一个类只有一个对象(NSArray)
static XPDataManager *_dataManager = nil;
+ (XPDataManager *)sharedDataManger {
    if (!_dataManager) {
        _dataManager = [XPDataManager new];
    }
    return _dataManager;
}
static NSArray *_cityGroupArray = nil;
+ (NSArray *)getAllCityGroups {
    if (!_cityGroupArray) {
        _cityGroupArray = [[self alloc] getCityGroups];
    }
    return _cityGroupArray;
}
- (NSArray *)getCityGroups {
    //读取plist文件
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"cityGroups.plist" ofType:nil];
    NSArray *cityGroupArray = [NSArray arrayWithContentsOfFile:plistPath];
    //所有字典对象转成模型对象
    NSMutableArray *mutableArray = [NSMutableArray array];
    for (NSDictionary *dic in cityGroupArray) {
        //声明一个空的TRCityGroup对象
        XPCityGroup *cityGroup = [XPCityGroup new];
        //KVC绑定模型对象属性和字典key的关系
        [cityGroup setValuesForKeysWithDictionary:dic];
        [mutableArray addObject:cityGroup];
    }
    
    return [mutableArray copy];
}


+ (NSArray *)getAllDailyData:(id)responseObject {
    //获取到weather对应的value
    NSArray *weatherArray = responseObject[@"data"][@"weather"];
    //循环解析(weatherArray[Dic...] -> [TRDaily...])
    NSMutableArray *mutableArray = [NSMutableArray array];
    for (NSDictionary *dic in weatherArray) {
        //TRDaily.h
        XPDaily *daily = [XPDaily parseDailyJson:dic];
        [mutableArray addObject:daily];
    }
    
    return [mutableArray copy];
}

+ (NSArray *)getAllHourlyData:(id)responseObject {
    NSArray *hourlyArray = responseObject[@"data"][@"weather"][0][@"hourly"];
    NSMutableArray *mutableArray = [NSMutableArray array];
    for (NSDictionary *dic in hourlyArray) {
        XPHourly *hourly = [XPHourly parseHourlyJson:dic];
        [mutableArray addObject:hourly];
    }
    
    return [mutableArray copy];
}

//天气图标url前缀
static NSString * const iconURLString = @"http://cdn.worldweatheronline.net/images/wsymbols01_png_64/wsymbol_";
// 图片名 - iconCode的映射
+ (NSDictionary *)imageMap {
    
    return @{
             [NSString stringWithFormat:@"%@0001_sunny.png",iconURLString]:@"weather-clear.png",
             [NSString stringWithFormat:@"%@0003_white_cloud.png",iconURLString]:@"weather-few.png",
             [NSString stringWithFormat:@"%@0004_black_low_cloud.png",iconURLString]:@"weather-scattered.png",
             [NSString stringWithFormat:@"%@0004_black_low_cloud.png",iconURLString]:@"weather-broken",
             [NSString stringWithFormat:@"%@0009_light_rain_showers.png",iconURLString]:@"weather-shower",
             [NSString stringWithFormat:@"%@0025_light_rain_showers_night.png",iconURLString]:@"weather-rain",
             @"11d":@"weather-tstorm",
             @"13d":@"weather-snow",
             [NSString stringWithFormat:@"%@0006_mist.png",iconURLString]
             :@"weather-mist",
             [NSString stringWithFormat:@"%@0008_clear_sky_night.png",iconURLString]:@"weather-moon",
             @"02n":@"weather-few-night",
             @"03n":@"weather-few-night",
             [NSString stringWithFormat:@"%@0002_sunny_intervals.png",iconURLString]:@"weather-broken",
             @"09n":@"weather-shoer",
             [NSString stringWithFormat:@"%@0025_light_rain_showers_night.png",iconURLString]:@"weather-rain-night",
             @"11n":@"weather-tstorm",
             @"13n":@"weather-snow",
             @"50n":@"weather-mist"
             };
}

@end

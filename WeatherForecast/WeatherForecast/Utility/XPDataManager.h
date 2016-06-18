//
//  XPDataManager.h
//  WeatherForecast
//
//  Created by dragon on 16/6/17.
//  Copyright © 2016年 win. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XPDataManager : NSObject

//返回所有的城市组数组(TRCityGroup)
+ (NSArray *)getAllCityGroups;

//给定每天字典数据，返回所有每天数组(TRDaily)
+ (NSArray *)getAllDailyData:(id)responseObject;

//给定每小时字典数据，返回所有每小时数组(TRHourly)
+ (NSArray *)getAllHourlyData:(id)responseObject;

//返回一个已经对应好得字典
+ (NSDictionary *)imageMap;
@end

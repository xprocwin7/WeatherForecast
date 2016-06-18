//
//  XPHeader.h
//  WeatherForecast
//
//  Created by dragon on 16/6/17.
//  Copyright © 2016年 win. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XPHeader : NSObject

//城市名字
@property (nonatomic, strong) NSString *cityName;
//天气图标url对应string
@property (nonatomic, strong) NSString *iconUrlStr;
//当前天气的描述
@property (nonatomic, strong) NSString *weatherDesc;
//当前天气的温度
@property (nonatomic, strong) NSString *weatherTemp;
//最高温度
@property (nonatomic, strong) NSString *maxTemp;
//最低温度
@property (nonatomic, strong) NSString *minTemp;

+ (XPHeader *)getHeaderData:(id)responseObject;

@end

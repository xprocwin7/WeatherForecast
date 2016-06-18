//
//  XPDaily.h
//  WeatherForecast
//
//  Created by dragon on 16/6/17.
//  Copyright © 2016年 win. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XPDaily : NSObject

//日期
@property (nonatomic, strong) NSString *date;
//最高温度
@property (nonatomic, strong) NSString *maxtempC;
//最低温度
@property (nonatomic, strong) NSString *mintempC;
//图片url
@property (nonatomic, strong) NSString *iconUrl;


//给定每天字典，返回TRDaily
+ (XPDaily *)parseDailyJson:(NSDictionary *)dic;


@end

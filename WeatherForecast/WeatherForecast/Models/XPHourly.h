//
//  XPHourly.h
//  WeatherForecast
//
//  Created by dragon on 16/6/17.
//  Copyright © 2016年 win. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XPHourly : NSObject

@property (nonatomic, strong) NSString *time;
@property (nonatomic, strong) NSString *tempC;
@property (nonatomic, strong) NSString *iconUrl;

+ (XPHourly *)parseHourlyJson:(NSDictionary *)dic;
@end

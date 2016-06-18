//
//  XPHourly.m
//  WeatherForecast
//
//  Created by dragon on 16/6/17.
//  Copyright © 2016年 win. All rights reserved.
//

#import "XPHourly.h"
#import "XPDataManager.h"

@implementation XPHourly

+ (XPHourly *)parseHourlyJson:(NSDictionary *)dic {
    return [[self alloc] parseHourlyJson:dic];
}

- (XPHourly *)parseHourlyJson:(NSDictionary *)dic {
    //    self.iconUrl = dic[@"weatherIconUrl"][0][@"value"];

    NSString *url = dic[@"weatherIconUrl"][0][@"value"];
    self.iconUrl = [XPDataManager imageMap][url];
    
    
    int time = [dic[@"time"] intValue] / 100;
    self.time = [NSString stringWithFormat:@"%d:00", time];
    self.tempC = [NSString stringWithFormat:@"%@˚", dic[@"tempC"]];
    
    return self;
}

@end

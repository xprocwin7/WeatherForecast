//
//  XPHeader.m
//  WeatherForecast
//
//  Created by dragon on 16/6/17.
//  Copyright © 2016年 win. All rights reserved.
//

#import "XPHeader.h"
#import "XPDataManager.h"

@implementation XPHeader

+ (XPHeader *)getHeaderData:(id)responseObject {
    return [[self alloc] getHeaderData:responseObject];
    
}

- (XPHeader *)getHeaderData:(id)responseObject {
    
    NSString *currentTemp = responseObject[@"data"][@"current_condition"][0][@"temp_C"];
    self.weatherTemp = [NSString stringWithFormat:@"%@˚", currentTemp];
    self.weatherDesc = responseObject[@"data"][@"current_condition"][0][@"weatherDesc"][0][@"value"];
    
    //    self.iconUrlStr = responseObject[@"data"][@"current_condition"][0][@"weatherIconUrl"][0][@"value"];

    NSString *url = responseObject[@"data"][@"current_condition"][0][@"weatherIconUrl"][0][@"value"];
    self.iconUrlStr = [XPDataManager imageMap][url];
    
    self.maxTemp  = responseObject[@"data"][@"weather"][0][@"maxtempC"];
    self.minTemp  = responseObject[@"data"][@"weather"][0][@"mintempC"];
    self.cityName = responseObject[@"data"][@"request"][0][@"query"];
    
    return self;
}
@end

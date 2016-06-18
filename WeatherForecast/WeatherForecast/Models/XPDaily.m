//
//  XPDaily.m
//  WeatherForecast
//
//  Created by dragon on 16/6/17.
//  Copyright © 2016年 win. All rights reserved.
//

#import "XPDaily.h"
#import "XPDataManager.h"

@implementation XPDaily

+ (XPDaily *)parseDailyJson:(NSDictionary *)dic {
    return [[self alloc] parseDailylJson:dic];
}
//第三方库(解析/赋值/嵌套.. YYModel/MJExtention)
- (XPDaily *)parseDailylJson:(NSDictionary *)dic {
    self.date = dic[@"date"];
    self.maxtempC = [NSString stringWithFormat:@"%@˚", dic[@"maxtempC"]];
    self.mintempC = [NSString stringWithFormat:@"%@˚", dic[@"mintempC"]];
    
    //    self.iconUrl = dic[@"hourly"][0][@"weatherIconUrl"][0][@"value"];
    
    NSString *url = dic[@"hourly"][0][@"weatherIconUrl"][0][@"value"];
    self.iconUrl = [XPDataManager imageMap][url];
    
    return self;
}

@end

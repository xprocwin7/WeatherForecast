//
//  XPCityGroup.h
//  WeatherForecast
//
//  Created by dragon on 16/6/17.
//  Copyright © 2016年 win. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XPCityGroup : NSObject

//模型类中的属性名称要和字典的key一模一样
@property (nonatomic, strong) NSArray *cities;
@property (nonatomic, strong) NSString *title;

@end

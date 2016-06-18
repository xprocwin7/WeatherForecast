//
//  XPLocationManager.h
//  WeatherForecast
//
//  Created by dragon on 16/6/17.
//  Copyright © 2016年 win. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

typedef void(^saveLocationBlock)(double lat, double lon);

@interface XPLocationManager : NSObject

+ (void)getUserLocation:(void(^)(double lat, double lon))locationBlock;

@end

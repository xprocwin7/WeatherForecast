//
//  UILabel+XPLabel.h
//  WeatherForecast
//
//  Created by dragon on 16/6/17.
//  Copyright © 2016年 win. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (XPLabel)
//给定CGRect, 返回一个已经创建好的UILabel
+ (UILabel *)labelWithFrame:(CGRect)frame;
@end

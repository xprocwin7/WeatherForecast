//
//  UILabel+XPLabel.m
//  WeatherForecast
//
//  Created by dragon on 16/6/17.
//  Copyright © 2016年 win. All rights reserved.
//

#import "UILabel+XPLabel.h"

@implementation UILabel (XPLabel)

+ (UILabel *)labelWithFrame:(CGRect)frame {
    
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentLeft;
    label.font = [UIFont fontWithName:@"HelveticaNeue" size:30];
    
    return label;
}
@end

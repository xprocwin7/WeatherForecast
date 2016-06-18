//
//  XPHeaderView.h
//  WeatherForecast
//
//  Created by dragon on 16/6/17.
//  Copyright © 2016年 win. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XPHeaderView : UIView

//button
@property (nonatomic, strong) UIButton *menuButton;
//城市label
@property (nonatomic, strong) UILabel *cityLabel;
//图片view
@property (nonatomic, strong) UIImageView *iconView;
//当前天气条件的label
@property (nonatomic, strong) UILabel *conditionsLabel;
//当前天气温度
@property (nonatomic, strong) UILabel *temperatureLabel;
//最高和最低温度
@property (nonatomic, strong) UILabel *hiloLabel;

@end

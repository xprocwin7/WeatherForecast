//
//  XPHeaderView.m
//  WeatherForecast
//
//  Created by dragon on 16/6/17.
//  Copyright © 2016年 win. All rights reserved.
//

#import "XPHeaderView.h"
#import "UILabel+XPLabel.h"

//左右边界
static CGFloat inset = 20;
//label高
static CGFloat labelHeight = 40;
//温度的label高
static CGFloat tempLabelHeight = 110;

@implementation XPHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        //button的frame
        CGRect buttonFrame = CGRectMake(0, inset,labelHeight, labelHeight);
        self.menuButton = [[UIButton alloc] initWithFrame:buttonFrame];
        [self.menuButton setImage:[UIImage imageNamed:@"IconHome"] forState:UIControlStateNormal];
        //添加
        [self addSubview:self.menuButton];
        
        //城市Label
        CGRect cityLabelRect = CGRectMake(labelHeight, inset, SCREEN_WIDTH, labelHeight);
        self.cityLabel = [UILabel labelWithFrame:cityLabelRect];
        self.cityLabel.text = @"Loading...";
        self.cityLabel.textAlignment = NSTextAlignmentCenter;
        //加载到视图上
        [self addSubview:self.cityLabel];
        
        //最低最高Label
        CGRect hiloLabelRect = CGRectMake(inset, SCREEN_HEIGHT-labelHeight, SCREEN_WIDTH-2*inset, labelHeight);
        self.hiloLabel = [UILabel labelWithFrame:hiloLabelRect];
        self.hiloLabel.text = @"0˚ / 10˚";
        //        self.hiloLabel.backgroundColor = [UIColor redColor];
        [self addSubview:self.hiloLabel];
        
        //当前温度
        CGRect tempLabelRect = CGRectMake(inset, SCREEN_HEIGHT-labelHeight-tempLabelHeight, frame.size.width-2*inset, tempLabelHeight);
        self.temperatureLabel = [UILabel labelWithFrame:tempLabelRect];
        self.temperatureLabel.text = @"10˚";
        self.temperatureLabel.font = [UIFont fontWithName:@"HelveticaNeue-BoldItalic" size:80];
        [self addSubview:self.temperatureLabel];
        
        //天气iconView
        CGRect iconViewRect = CGRectMake(inset, tempLabelRect.origin.y-labelHeight, labelHeight, labelHeight);
        self.iconView = [[UIImageView alloc] initWithFrame:iconViewRect];
        self.iconView.image = [UIImage imageNamed:@"placeholder.png"];
        [self addSubview:self.iconView];
        
        //天气描述
        CGRect conditionRect = CGRectMake(inset+labelHeight, iconViewRect.origin.y, SCREEN_WIDTH-2*inset-labelHeight, labelHeight);
        self.conditionsLabel = [UILabel labelWithFrame:conditionRect];
        self.conditionsLabel.text = @"Sunny";
        //        self.conditionsLabel.backgroundColor = [UIColor blueColor];
        [self addSubview:self.conditionsLabel];
    }
    
    return self;
}
@end

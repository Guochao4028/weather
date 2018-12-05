//
//  WeatherListCollectionViewCell.m
//  AYLWeather
//
//  Created by AYLiOS on 2018/12/3.
//  Copyright © 2018年 AYLiOS. All rights reserved.
//

#import "WeatherListCollectionViewCell.h"
#import "WeatherTableView.h"


#import "WeekWeatherListCell.h"

#import "TotalWeatherModel.h"
#import "HeWeatherModel.h"
#import "DailyForecastModel.h"

#import "BaseEmitterLayer.h"
#import "RainEmitterLayer.h"
#import "SnowEmitterLayer.h"
#import "CloudEmitterLayer.h"

@interface WeatherListCollectionViewCell ()

@end


@implementation WeatherListCollectionViewCell

- (void)awakeFromNib{
    [super awakeFromNib];
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self initUI];
    }
    return self;
}

#pragma mark - private

-(void)initUI{
 
    
    CGFloat statusHeight = [[UIApplication sharedApplication] statusBarFrame].size.height;
    
    self.weatherTableView = [[WeatherTableView alloc]initWithFrame:CGRectMake(0, statusHeight, ScreenWidth, ScreenHeight - statusHeight - 60)];
    [self.weatherTableView setBackgroundColor:[UIColor clearColor]];
    [self addSubview:self.weatherTableView];
}

#pragma mark - setter
-(void)setTotalWeatherModel:(TotalWeatherModel *)totalWeatherModel{
    _totalWeatherModel = totalWeatherModel;
 
    self.weatherTableView.model = totalWeatherModel;
    [self.weatherTableView reloadData];
}

@end

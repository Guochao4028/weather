//
//  WeatherTodayView.h
//  AYLWeather
//
//  Created by AYLiOS on 2018/12/4.
//  Copyright © 2018年 AYLiOS. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TotalWeatherModel;

@interface WeatherTodayView : UIView

@property (nonatomic, strong) NSString *cityName;

@property (nonatomic, strong) TotalWeatherModel *model;

- (void)viewWithRealTimeModel:(TotalWeatherModel *)model andWeatherDetailsInfo:(NSArray *)horlyForecastArray;

@end

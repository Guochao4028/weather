//
//  TotalWeatherModel.h
//  AYLWeather
//
//  Created by AYLiOS on 2018/12/3.
//  Copyright © 2018年 AYLiOS. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DailyForecastModel, HeWeatherModel;

@interface TotalWeatherModel : NSObject

@property(nonatomic, strong)DailyForecastModel *instantForecastModel;

@property(nonatomic, strong)HeWeatherModel *weatherModel;

@property(nonatomic, strong)NSArray *horlyForecastArray;

@end

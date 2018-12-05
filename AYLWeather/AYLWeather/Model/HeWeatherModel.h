//
//  HeWeatherModel.h
//  AYLWeather
//
//  Created by AYLiOS on 2018/11/29.
//  Copyright © 2018年 AYLiOS. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DailyForecastModel;
@interface HeWeatherModel : NSObject

//该地区／城市所属行政区域
@property(nonatomic, copy)NSString *adminArea;
//该地区／城市的上级城市
@property(nonatomic, copy)NSString *parentCity;
//地区／城市名称
@property(nonatomic, copy)NSString *location;
//每天天气预报
@property(nonatomic, strong)NSArray <DailyForecastModel *>*dailyForecast;

@end

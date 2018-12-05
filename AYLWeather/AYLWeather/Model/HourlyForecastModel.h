//
//  HourlyForecastModel.h
//  AYLWeather
//
//  Created by AYLiOS on 2018/11/30.
//  Copyright © 2018年 AYLiOS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HourlyForecastModel : NSObject

//预报时间，格式yyyy-MM-dd HH:mm
@property(nonatomic, strong)NSString *time;
//温度
@property(nonatomic, strong)NSString *tmp;
//天气状况代码
@property(nonatomic, strong)NSString *cond_code;
//天气状况代码
@property(nonatomic, strong)NSString *cond_txt;

@end

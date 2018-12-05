//
//  HeWeatherModel.m
//  AYLWeather
//
//  Created by AYLiOS on 2018/11/29.
//  Copyright © 2018年 AYLiOS. All rights reserved.
//

#import "HeWeatherModel.h"
#import "DailyForecastModel.h"

@implementation HeWeatherModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
             @"personId":@"id",
             @"adminArea":@"basic.admin_area",
             @"parentCity":@"basic.parent_city",
             @"location":@"basic.location",
             };
}

// 声明自定义类参数类型
+ (NSDictionary *)modelContainerPropertyGenericClass {
    // value使用[YYEatModel class]或YYEatModel.class或@"YYEatModel"没有区别
    return @{
             @"now" : [DailyForecastModel class]
             };
}

@end

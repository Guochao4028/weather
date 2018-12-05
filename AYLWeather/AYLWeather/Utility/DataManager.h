//
//  DataManager.h
//  AYLWeather
//
//  Created by AYLiOS on 2018/11/28.
//  Copyright © 2018年 AYLiOS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataManager : NSObject

+(DataManager *) shareInstance;
/*****************3-10天天气预报*******************/
-(void) getWeatherForecastParameter:(NSDictionary *)parameters callback:(NSObjectCallBack) call;
/*******************实况天气预报*******************/
-(void) getNowForecastParameter:(NSDictionary *)parameters callback:(NSObjectCallBack) call;

/*******************逐小时预报*******************/
-(void) getHourlyForecastParameter:(NSDictionary *)parameters callback:(NSArrayCallBack) call;

@end

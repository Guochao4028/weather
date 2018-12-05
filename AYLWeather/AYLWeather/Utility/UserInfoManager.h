//
//  UserInfoManager.h
//  AYLWeather
//
//  Created by AYLiOS on 2018/11/28.
//  Copyright © 2018年 AYLiOS. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CLLocation, DailyForecastModel;

@interface UserInfoManager : NSObject{
    CLLocation *_userLocation;
}
//位置
@property (nonatomic, strong) CLLocation *userLocation;
//实时天气
@property (nonatomic, strong) DailyForecastModel *forecastModel;

@property (nonatomic, strong) NSArray *cityListArray;

+(UserInfoManager *) shareInstance;
-(NSString *)getLocation;

@end

//
//  DataManager.m
//  AYLWeather
//
//  Created by AYLiOS on 2018/11/28.
//  Copyright © 2018年 AYLiOS. All rights reserved.
//

#import "DataManager.h"
#import "AFNetworking.h"
#import "HeWeatherModel.h"
#import "NSObject+YYModel.h"
#import "DailyForecastModel.h"
#import "HourlyForecastModel.h"

#import "TotalWeatherModel.h"

@implementation DataManager
static DataManager *_instance;

-(void) getWeatherForecastParameter:(NSDictionary *)parameters callback:(NSObjectCallBack) call{
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.requestSerializer.cachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithDictionary:parameters];
    [param setValue:HEFENGAPPKEY forKey:@"key"];
    [manager GET:DAYS_WEATHER_FORECAST parameters:param headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        
        NSArray *dailyForecast = [NSArray yy_modelArrayWithClass:[DailyForecastModel class] json:[responseObject[@"HeWeather6"] lastObject][@"daily_forecast"]];
        
        HeWeatherModel *model = [HeWeatherModel yy_modelWithDictionary:[responseObject[@"HeWeather6"]lastObject]];
        model.dailyForecast = dailyForecast;
        
        call(model);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        call(nil);
    }];
}


-(void) getNowForecastParameter:(NSDictionary *)parameters callback:(NSObjectCallBack) call{
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.requestSerializer.cachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithDictionary:parameters];
    [param setValue:HEFENGAPPKEY forKey:@"key"];
//    [manager GET:NOW_WEATHER_FORECAST parameters:param headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//
//        DailyForecastModel *model = [DailyForecastModel yy_modelWithDictionary:[responseObject[@"HeWeather6"]lastObject][@"now"]];
//
//
//
//
//        call(model);
//
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        call(nil);
//    }];
    
    
    
    
    
    
    [manager GET:NOW_WEATHER_FORECAST parameters:param headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        DailyForecastModel *dailyForecastModel = [DailyForecastModel yy_modelWithDictionary:[responseObject[@"HeWeather6"]lastObject][@"now"]];
        [[DataManager shareInstance]getWeatherForecastParameter:param callback:^(NSObject *obj) {
           
            HeWeatherModel *heWeatherModel = (HeWeatherModel *)obj;
            
            [[DataManager shareInstance]getHourlyForecastParameter:param callback:^(NSArray *result) {
                NSArray *hourlyForecastArray = result;
                TotalWeatherModel *model = [[TotalWeatherModel alloc]init];
                model.instantForecastModel = dailyForecastModel;
                model.weatherModel = heWeatherModel;
                model.horlyForecastArray = hourlyForecastArray;
                call(model);
            }];
        }];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        call(nil);
    }];
}

-(void) getHourlyForecastParameter:(NSDictionary *)parameters callback:(NSArrayCallBack) call{
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.requestSerializer.cachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithDictionary:parameters];
    [param setValue:HEFENGAPPKEY forKey:@"key"];
    [manager GET:HOURLY_WEATHER_FORECAST parameters:param headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSArray *hourlyForecastArray = [NSArray yy_modelArrayWithClass:[HourlyForecastModel class] json:[responseObject[@"HeWeather6"] lastObject][@"hourly"]];
        call(hourlyForecastArray);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        call(nil);
    }];
}

+(DataManager*)shareInstance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if(_instance == nil)
            _instance = [[DataManager alloc] init];
    });
    return _instance;
}

@end

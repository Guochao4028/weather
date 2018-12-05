//
//  WeatherCityView.h
//  AYLWeather
//
//  Created by AYLiOS on 2018/12/3.
//  Copyright © 2018年 AYLiOS. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol  WeatherCityViewDelegate;

@interface WeatherCityView : UIView

@property(nonatomic, weak)id<WeatherCityViewDelegate>delegate;

@end

@protocol WeatherCityViewDelegate <NSObject>

@optional
-(void)cityView:(WeatherCityView *)view getCityName:(NSString *)cityName;
@end

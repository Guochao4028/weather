//
//  WeatherTableView.h
//  AYLWeather
//
//  Created by AYLiOS on 2018/12/3.
//  Copyright © 2018年 AYLiOS. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TotalWeatherModel;

@interface WeatherTableView : UITableView
@property(nonatomic, strong)TotalWeatherModel *model;
@property(nonatomic, strong)UIPageControl *pageC;
@end

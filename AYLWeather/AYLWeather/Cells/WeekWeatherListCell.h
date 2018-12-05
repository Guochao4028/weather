//
//  WeekWeatherListCell.h
//  AYLWeather
//
//  Created by AYLiOS on 2018/11/30.
//  Copyright © 2018年 AYLiOS. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DailyForecastModel;
@interface WeekWeatherListCell : UITableViewCell

@property(nonatomic, strong)DailyForecastModel *model;

@end

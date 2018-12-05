//
//  WeatherMiddleListCell.h
//  AYLWeather
//
//  Created by AYLiOS on 2018/11/30.
//  Copyright © 2018年 AYLiOS. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HourlyForecastModel;
@interface WeatherMiddleListCell : UICollectionViewCell

@property(nonatomic, strong)HourlyForecastModel *model;

@end

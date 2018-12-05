//
//  WeatherListCollectionViewCell.h
//  AYLWeather
//
//  Created by AYLiOS on 2018/12/3.
//  Copyright © 2018年 AYLiOS. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WeatherTableView, TotalWeatherModel;

@interface WeatherListCollectionViewCell : UICollectionViewCell

@property(nonatomic, strong)UIPageControl *pageC;
@property(nonatomic, strong)WeatherTableView *weatherTableView;
@property(nonatomic, strong)TotalWeatherModel *totalWeatherModel;

@end

//
//  AYLCityViewController.h
//  AYLWeather
//
//  Created by AYLiOS on 2018/12/3.
//  Copyright © 2018年 AYLiOS. All rights reserved.
// 选择城市页面

#import "AYLBasicViewController.h"
@protocol AYLCityViewControllerDelegate;

@interface AYLCityViewController : AYLBasicViewController

@property(nonatomic, weak)id<AYLCityViewControllerDelegate>delegate;

@end

@protocol AYLCityViewControllerDelegate <NSObject>

@optional
-(void)cityViewController:(AYLCityViewController *)vc getCityName:(NSString *)cityName;
@end

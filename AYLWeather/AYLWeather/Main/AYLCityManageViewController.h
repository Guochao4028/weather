//
//  AYLCityManageViewController.h
//  AYLWeather
//
//  Created by AYLiOS on 2018/12/5.
//  Copyright © 2018年 AYLiOS. All rights reserved.
//

#import "AYLBasicViewController.h"
@protocol AYLCityManageViewControllerDelegate;

@interface AYLCityManageViewController : AYLBasicViewController

@property(nonatomic, weak)id<AYLCityManageViewControllerDelegate>delegate;

@end

@protocol AYLCityManageViewControllerDelegate <NSObject>

@optional
-(void)cityManageViewControllerReloadData;
@end

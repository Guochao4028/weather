//
//  WeatherCollectionView.h
//  AYLWeather
//
//  Created by AYLiOS on 2018/12/3.
//  Copyright © 2018年 AYLiOS. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WeatherCollectionView;

@protocol WeatherCollectionViewDelegate <NSObject>

@optional
-(void)weatherCollectinView:(WeatherCollectionView *)view getCurrentPage:(NSInteger)currentPage;
@end

@interface WeatherCollectionView : UICollectionView

@property(nonatomic, strong)NSMutableArray *dataSourceArray;
@property(nonatomic, strong)UIPageControl *pageC;
@property(nonatomic, strong)id<WeatherCollectionViewDelegate>p_Delegate;

@end

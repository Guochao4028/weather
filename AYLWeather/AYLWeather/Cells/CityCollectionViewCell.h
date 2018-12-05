//
//  CityCollectionViewCell.h
//  AYLWeather
//
//  Created by AYLiOS on 2018/12/3.
//  Copyright © 2018年 AYLiOS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CityCollectionViewCell : UICollectionViewCell

@property(nonatomic,copy)NSString *cityName;
@property(nonatomic,retain)UILabel *label;

@end

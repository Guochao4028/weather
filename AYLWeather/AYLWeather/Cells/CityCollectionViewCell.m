//
//  CityCollectionViewCell.m
//  AYLWeather
//
//  Created by AYLiOS on 2018/12/3.
//  Copyright © 2018年 AYLiOS. All rights reserved.
//

#import "CityCollectionViewCell.h"

@implementation CityCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.label = [[UILabel alloc]initWithFrame:self.bounds];
        self.label.textAlignment = NSTextAlignmentCenter;
        self.label.backgroundColor = BGCOLOR;
        self.label.layer.cornerRadius = 10;
        self.label.layer.masksToBounds = YES;
        [self addSubview:self.label];
    }
    return self;
}


- (void)setCityName:(NSString *)cityName{
    _cityName = cityName;
    
    //a用来标记是否查找到
    int tem = 0;
    
    for (NSString *str in HISTORYDATA) {
        if ([str isEqualToString:_cityName]) {
            tem = 1;
            break;
        }
    }
    
    if (tem) {
        _label.textColor = [UIColor whiteColor];
        
        _label.backgroundColor=[UIColor blackColor];
    }
    _label.text = _cityName;
    
    
}
@end

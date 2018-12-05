//
//  BaseEmitterLayer.m
//  AYLWeather
//
//  Created by AYLiOS on 2018/11/29.
//  Copyright © 2018年 AYLiOS. All rights reserved.
//

#import "BaseEmitterLayer.h"


@implementation BaseEmitterLayer

+ (instancetype)instanceWithFrame:(CGRect)rect type:(NSInteger)type{
    
    BaseEmitterLayer *_emitterLayer = [BaseEmitterLayer layer];
    
    return _emitterLayer;
}

@end

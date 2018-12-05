//
//  BaseEmitterLayer.h
//  AYLWeather
//
//  Created by AYLiOS on 2018/11/29.
//  Copyright © 2018年 AYLiOS. All rights reserved.
//


@class CAEAGLLayer;
@interface BaseEmitterLayer : CAEmitterLayer
+ (instancetype)instanceWithFrame:(CGRect)rect type:(NSInteger)type;
@end

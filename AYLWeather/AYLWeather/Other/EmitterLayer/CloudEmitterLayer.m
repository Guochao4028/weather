//
//  CloudEmitterLayer.m
//  AYLWeather
//
//  Created by AYLiOS on 2018/11/29.
//  Copyright © 2018年 AYLiOS. All rights reserved.
//

#import "CloudEmitterLayer.h"
#import <QuartzCore/QuartzCore.h>

@interface CloudEmitterLayer()
@property (nonatomic, strong)CAEmitterCell *emitterCell;
@property (nonatomic, strong)CAEmitterCell *cloudyEmitterCell;
@property (nonatomic, assign)NSInteger cloudType;

@end

@implementation CloudEmitterLayer

+ (instancetype)instanceWithFrame:(CGRect)rect type:(NSInteger)type{
    CloudEmitterLayer *_emitterLayer = [CloudEmitterLayer layer];
    _emitterLayer.cloudType = type;
    //    _emitterLayer.position = CGPointMake(rect.origin.x + rect.size.width/2, rect.origin.y);
    _emitterLayer.position = CGPointMake(-100, 50);
    _emitterLayer.emitterSize = CGSizeMake(2, 100);
    _emitterLayer.emitterMode = kCAEmitterLayerUnordered; //发射模式：顶点、轮廓、 表面、 容积(the default)
    _emitterLayer.emitterShape = kCAEmitterLayerRectangle; //发射源的形状：点(the default)、直线、矩形、立方体、圆形形、3D球
    if (type == CLOUD_CLOUDY_DAY_TYPE) {
        _emitterLayer.emitterCells = @[ _emitterLayer.cloudyEmitterCell]; //装粒子的数组
    }else{
        _emitterLayer.emitterCells = @[_emitterLayer.emitterCell]; //装粒子的数组
    }
    
    _emitterLayer.renderMode = kCAEmitterLayerOldestFirst; //渲染模式, 默认kCAEmitterLayerUnordered
    _emitterLayer.emitterPosition = CGPointMake(0, _emitterLayer.frame.size.height/2); //发射源的中心位置，默认(0,0,0)//决定了粒子发射形状的中心点
    _emitterLayer.emitterZPosition = 0;
    
    return _emitterLayer;
}


#pragma mark - get/set

- (CAEmitterCell *)emitterCell{
    if (!_emitterCell) {
        _emitterCell = [CAEmitterCell emitterCell];
        _emitterCell.contents = (id)[UIImage imageNamed:@"cloud"].CGImage;
        _emitterCell.birthRate = 0.1;
        _emitterCell.lifetime = 50;
        _emitterCell.velocity = 15;
        _emitterCell.velocityRange = 5;
        
        _emitterCell.scale = 0.5;
        _emitterCell.scaleRange = 0.5;
        _emitterCell.scaleSpeed = 0.05;
        
        _emitterCell.alphaRange = 0.5;
        _emitterCell.alphaSpeed = 0.05;
    }
    return _emitterCell;
}

//cloudy
- (CAEmitterCell *)cloudyEmitterCell
{
    if (!_cloudyEmitterCell) {
        _cloudyEmitterCell = [CAEmitterCell emitterCell];
        _cloudyEmitterCell.contents = (id)[UIImage imageNamed:@"cloud_n"].CGImage;
        _cloudyEmitterCell.birthRate = 0.1;
        _cloudyEmitterCell.lifetime = 50;
        _cloudyEmitterCell.velocity = 15;
        _cloudyEmitterCell.velocityRange = 5;
        
        _cloudyEmitterCell.scale = 0.5;
        _cloudyEmitterCell.scaleRange = 0.5;
        _cloudyEmitterCell.scaleSpeed = 0.05;
        
        _cloudyEmitterCell.alphaRange = 0.5;
        _cloudyEmitterCell.alphaSpeed = 0.05;
    }
    return _cloudyEmitterCell;
}



@end

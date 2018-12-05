//
//  UIAlertController+AYLCustom.h
//  AYLWeather
//
//  Created by AYLiOS on 2018/12/4.
//  Copyright © 2018年 AYLiOS. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^AlertControlerBlock)(void);

@interface UIAlertController (AYLCustom)
+ (void)showAlertViewWithMessage:(NSString *)message target:(id)target handler:(AlertControlerBlock)handler;
@end

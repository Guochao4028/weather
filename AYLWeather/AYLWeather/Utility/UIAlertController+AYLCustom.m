//
//  UIAlertController+AYLCustom.m
//  AYLWeather
//
//  Created by AYLiOS on 2018/12/4.
//  Copyright © 2018年 AYLiOS. All rights reserved.
//

#import "UIAlertController+AYLCustom.h"

@implementation UIAlertController (AYLCustom)

+ (void)showAlertViewWithMessage:(NSString *)message target:(id)target handler:(AlertControlerBlock)handler
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        if (handler) {
            handler();
        }
    }]];
    
    [target presentViewController:alertController animated:YES completion:nil];
}

@end

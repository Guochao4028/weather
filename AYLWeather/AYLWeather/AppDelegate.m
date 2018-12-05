//
//  AppDelegate.m
//  AYLWeather
//
//  Created by AYLiOS on 2018/11/28.
//  Copyright © 2018年 AYLiOS. All rights reserved.
//

#import "AppDelegate.h"

#import "AYLWeatherViewController.h"

#import "AYLBasicViewController.h"

@interface AppDelegate ()<CLLocationManagerDelegate>

@property(nonatomic, strong)CLLocationManager *locManager;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    self.window.backgroundColor = [UIColor whiteColor];
    
    AYLBasicViewController *rootViewController = [[AYLWeatherViewController alloc] init];
    
    UINavigationController *nar = [[UINavigationController alloc]initWithRootViewController:rootViewController];
    
    self.window.rootViewController = nar;
    
    [self.window makeKeyAndVisible];
    
    
    [self initLocManager];
    
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


#pragma mark - private
//初始位置
-(void)initLocManager{
    self.locManager = [[CLLocationManager alloc]init];
    [self.locManager setDelegate:self];
    //1.判断当前系统定位服务是否开启
    if (![CLLocationManager locationServicesEnabled]) {
        NSLog(@"系统定位服务未开启");
        return;
    }
    //2.判断当前应用是否获取定位授权
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined) {
        //更改授权状态
        [_locManager requestWhenInUseAuthorization];
    }
    else if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied){
        NSLog(@"禁止修改授权状态");
    }
    self.locManager.desiredAccuracy = kCLLocationAccuracyKilometer;
    self.locManager.distanceFilter = 100;
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(37, 112);
    //初始化区域范围
    CLCircularRegion *region = [[CLCircularRegion alloc] initWithCenter:coordinate radius:1000 identifier:@"hehe"];
    [_locManager startMonitoringForRegion:region];
    //开启定位
    [_locManager startUpdatingLocation];
}

//当用户定位信息发生改变时调用
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    //1.从数组中获取到CLLocation对象 （数组中可能会存在多个对象，取出第一个最精确的对象）
    CLLocation *loc = locations[0];
    //取出经纬度
    //CLLocationCoordinate2D coordinate = loc.coordinate;
    [[UserInfoManager shareInstance]setUserLocation:loc];
}


-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    [[UserInfoManager shareInstance]setUserLocation:nil];
}

@end

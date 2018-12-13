//
//  UserInfoManager.m
//  AYLWeather
//
//  Created by AYLiOS on 2018/11/28.
//  Copyright © 2018年 AYLiOS. All rights reserved.
//

#import "UserInfoManager.h"

@interface UserInfoManager()

//编码管理者
@property(nonatomic, strong)CLGeocoder *geoCoder;

@end


@implementation UserInfoManager
static UserInfoManager *_instance;
- (CLLocation *) userLocation{
    return _userLocation;
}

- (void)setUserLocation:(CLLocation *)userLocation{
    [self willChangeValueForKey:@"userLocation"];
    _userLocation = userLocation;
    [self didChangeValueForKey:@"userLocation"];
}


+ (BOOL) automaticallyNotifiesObserversForKey:(NSString *)key {
    if ([key isEqualToString:@"userLocation"]) {
        return NO;
    }
    return [super automaticallyNotifiesObserversForKey:key];
}

-(NSString *)getLocation{
    
    CLLocationCoordinate2D coordinate = self.userLocation.coordinate;
    NSString *str = [NSString stringWithFormat:@"%f,%f",coordinate.longitude, coordinate.latitude];
    
    [_geoCoder reverseGeocodeLocation:self.userLocation completionHandler:^(NSArray *placemarks, NSError *error){
            //获取到反编码对象
            CLPlacemark *pm = [placemarks firstObject];
            /*
             pm.country  国家
             pm.locality 城市
             pm.subLocality 子城市
             pm.thoroughfare 街道
             pm.subThoroughfare 子街道
             */
            NSString *address = [NSString stringWithFormat:@"%@ %@ %@ %@ %@",pm.country,pm.locality,pm.subLocality,pm.thoroughfare,pm.subThoroughfare];
            NSLog(@"addrss is:%@",address);
            NSLog(@"pm.name :%@",pm.name);
    }];
    
    
    
    return str;
}


+(UserInfoManager*)shareInstance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if(_instance == nil)
            _instance = [[UserInfoManager alloc] init];
    });
    return _instance;
}


#pragma mark - setter/ getter
-(CLGeocoder *)geoCoder{
    if (_geoCoder == nil) {
        _geoCoder = [[CLGeocoder alloc]init];
    }
    return _geoCoder;
}

@end

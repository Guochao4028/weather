//
//  DefinedEnums.h
//  AYLWeather
//
//  Created by AYLiOS on 2018/11/29.
//  Copyright © 2018年 AYLiOS. All rights reserved.
//

#ifndef DefinedEnums_h
#define DefinedEnums_h

typedef NS_ENUM(NSInteger, CLOUD_TYPE) {
    CLOUD_LITTER_DAY_TYPE,         //白天少云 102
    CLOUD_MUCH_NIGHT_TYPE,         //夜间多云
    CLOUD_LITTER_NIGHT_TYPE,       //夜间少云
    CLOUD_MUCH_DAY_TYPE,           //白天多云 103
    CLOUD_SUN_DAY_TYPE,           //晴 100
    CLOUD_CLOUDY_DAY_TYPE     //阴天
    
};


typedef NS_ENUM(NSInteger, SNOW_TYPE){
    SNOW_Little_TYPE,   //小雪 400
    SNOW_Middle_TYPE,   //中雪 401
    SNOW_HEAVY_TYPE,    //大雪 402
    SNOW_SLEET_TYPE     //雨夹雪 404
};

typedef NS_ENUM(NSInteger, RAIN_TYPE) {
    RAIN_THUNDERSHOWER_TYPE,   //雷阵雨 302
    RAIN_SHOWER_TYPE,          //阵雨 300
    RAIN_LITTER_TYPE,          //小雨 305
    RAIN_MIDDLE_TYPE,          //中雨 306
    RAIN_HEAVY_TYPE,           //大雨 307
};


#endif /* DefinedEnums_h */

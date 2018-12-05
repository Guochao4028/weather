//
//  DailyForecastModel.h
//  AYLWeather
//
//  Created by AYLiOS on 2018/11/29.
//  Copyright © 2018年 AYLiOS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DailyForecastModel : NSObject
//预报日期
@property(nonatomic, strong)NSString *date;
//日出时间
@property(nonatomic, strong)NSString *sr;
//日落时间
@property(nonatomic, strong)NSString *ss;
//最高温度
@property(nonatomic, strong)NSString *tmp_max;
//最低温度
@property(nonatomic, strong)NSString *tmp_min;
//白天天气状况代码
@property(nonatomic, strong)NSString *cond_code_d;
//晚间天气状况代码
@property(nonatomic, strong)NSString *cond_code_n;
//白天天气状况描述
@property(nonatomic, strong)NSString *cond_txt_d;
//晚间天气状况描述
@property(nonatomic, strong)NSString *cond_txt_n;
//风向
@property(nonatomic, strong)NSString *wind_dir;
//风力
@property(nonatomic, strong)NSString *wind_sc;
//相对湿度
@property(nonatomic, strong)NSString *hum;
//降水量
@property(nonatomic, strong)NSString *pcpn;
//降水概率
@property(nonatomic, strong)NSString *pop;
//紫外线强度指数
@property(nonatomic, strong)NSString *uv_index;
//温度，默认单位：摄氏度
@property(nonatomic, strong)NSString *tmp;
//体感温度，默认单位：摄氏度
@property(nonatomic, strong)NSString *fl;
//实况天气状况代码
@property(nonatomic, strong)NSString *cond_code;
//实况天气状况描述
@property(nonatomic, strong)NSString *cond_txt;
//云量
@property(nonatomic, strong)NSString *cloud;


@end

//
//  WeatherMiddleListCell.m
//  AYLWeather
//
//  Created by AYLiOS on 2018/11/30.
//  Copyright © 2018年 AYLiOS. All rights reserved.
//

#import "WeatherMiddleListCell.h"

#import "HourlyForecastModel.h"

@interface WeatherMiddleListCell ()



@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (weak, nonatomic) IBOutlet UILabel *tempLabel;
@property (weak, nonatomic) IBOutlet UIImageView *iconView;


@end
@implementation WeatherMiddleListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


-(void)setModel:(HourlyForecastModel *)model{
    _model = model;
    
    NSString *dateString=model.time;
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSDate *date=[dateFormatter dateFromString:dateString];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateFormatter *dateFmt = [[NSDateFormatter alloc] init];
    BOOL isToday = [[NSCalendar currentCalendar] isDateInToday:date];
    if (isToday) {
        if ([date compare:[self getCustomDateWithHour:0]] == NSOrderedDescending && [date compare:[self getCustomDateWithHour:9]] == NSOrderedAscending){
            dateFmt.dateFormat = @"早上 h 时 ";
        }else if ([date compare:[self getCustomDateWithHour:9]] == NSOrderedDescending && [date compare:[self getCustomDateWithHour:11]] == NSOrderedAscending){
            dateFmt.dateFormat = @"上午 h 时 ";
        }else if ([date compare:[self getCustomDateWithHour:11]] == NSOrderedDescending && [date compare:[self getCustomDateWithHour:13]] == NSOrderedAscending){
            dateFmt.dateFormat = @"中午 h 时 ";
        }else if ([date compare:[self getCustomDateWithHour:13]] == NSOrderedDescending && [date compare:[self getCustomDateWithHour:18]] == NSOrderedAscending){
            dateFmt.dateFormat = @"下午 h 时 ";
        }else{
            dateFmt.dateFormat = @"晚上 h 时 ";
        }
    }else{
        dateFmt.dateFormat = @"明天 h 时 ";
    }
    
    
   

    
    NSString *str = [dateFmt stringFromDate:date];
    
    [self.timeLabel setText:str];
    [self.iconView setImage:[UIImage imageNamed:model.cond_code]];
    [self.tempLabel setText:model.tmp];
    
}

- (NSDate *)getCustomDateWithHour:(NSInteger)hour
{
    //获取当前时间
    NSDate *currentDate = [NSDate date];
    NSCalendar *currentCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *currentComps = [[NSDateComponents alloc] init];
    
    NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    
    currentComps = [currentCalendar components:unitFlags fromDate:currentDate];
    
    //设置当天的某个点
    NSDateComponents *resultComps = [[NSDateComponents alloc] init];
    [resultComps setYear:[currentComps year]];
    [resultComps setMonth:[currentComps month]];
    [resultComps setDay:[currentComps day]];
    [resultComps setHour:hour];
    
    NSCalendar *resultCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    return [resultCalendar dateFromComponents:resultComps];
}

@end

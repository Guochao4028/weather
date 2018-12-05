//
//  WeekWeatherListCell.m
//  AYLWeather
//
//  Created by AYLiOS on 2018/11/30.
//  Copyright © 2018年 AYLiOS. All rights reserved.
//

#import "WeekWeatherListCell.h"

#import "DailyForecastModel.h"

@interface WeekWeatherListCell ()

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *tempLabel;
@property (weak, nonatomic) IBOutlet UILabel *tempMinLabel;

@end
@implementation WeekWeatherListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


#pragma mark - setter

-(void)setModel:(DailyForecastModel *)model{
    _model = model;
    NSString *dateString=model.date;
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *date=[dateFormatter dateFromString:dateString];
    
    NSArray *weekdays = [NSArray arrayWithObjects:@"周日", @"周一", @"周二", @"周三", @"周四", @"周五", @"周六", nil];
     NSCalendar *calendar = [NSCalendar currentCalendar];
     NSTimeZone *timeZone = [[NSTimeZone alloc] initWithName:@"Asia/Shanghai"];
    [calendar setTimeZone: timeZone];
     NSDateComponents *theComponents = [calendar components:NSCalendarUnitWeekday fromDate:date];
    
    [self.timeLabel setText:[weekdays objectAtIndex:(theComponents.weekday - 1)]];

    [self.iconView setImage:[UIImage imageNamed:model.cond_code_d]];
    [self.tempLabel setText:model.tmp_max];
    [self.tempMinLabel setText:model.tmp_min];
}

@end

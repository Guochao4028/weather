//
//  WeatherTodayView.m
//  AYLWeather
//
//  Created by AYLiOS on 2018/12/4.
//  Copyright © 2018年 AYLiOS. All rights reserved.
//

#import "WeatherTodayView.h"
#import "DailyForecastModel.h"
#import "TotalWeatherModel.h"
#import "HourlyForecastModel.h"
#import "HeWeatherModel.h"
#import "HourlyForecastModel.h"
#import "UIView+AYLFrameLayout.h"


@interface WeatherTodayView ()
//城市名
@property (nonatomic, strong) UILabel *nameLabel;
//温度
@property (nonatomic, strong) UILabel *tempLabel;
//天气
@property (nonatomic, strong) UILabel *weatherLabel;
//
@property (nonatomic, assign) NSInteger currentIndex;
// 天气图标
@property (nonatomic, strong) UIImageView *weatherIcon;
// 发布时间
@property (nonatomic, strong) UILabel *publishTimeLabel;

@property (nonatomic, assign) BOOL isNight;

@end


@implementation WeatherTodayView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        _nameLabel = [self createLabelWithFrame:CGRectMake(0, 10, ScreenWidth, 40) text:@"未知" font:FONT(20) textColor:COLOR_WHITECOLOR];
        
        _nameLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_nameLabel];
        
        _tempLabel = [self createLabelWithFrame:CGRectMake(0, _nameLabel.maxY + 10, ScreenWidth, 80) text:@"N/A" font:FONT(80) textColor:COLOR_WHITECOLOR];
        _tempLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_tempLabel];
        
        _weatherIcon = [[UIImageView alloc]initWithFrame:CGRectMake( ScreenWidth / 2 - 60, _tempLabel.maxY + 10, 50, 50)];
        _weatherIcon.image = [UIImage imageNamed:@"undefined"];
        [self addSubview:_weatherIcon];
        
        _weatherLabel = [self createLabelWithFrame:CGRectMake(_weatherIcon.maxX + 10 , _weatherIcon.center.y, ScreenHeight / 2 - 20, 20) text:@"没有网络数据" font:FONT(15) textColor:COLOR_WHITECOLOR];
        _weatherLabel.center  = CGPointMake(_weatherLabel.center.x, _weatherIcon.center.y);
        [self addSubview:_weatherLabel];
        
        // 发布时间
        _publishTimeLabel = [self createLabelWithFrame:CGRectMake(20, 20, 200, 15) text:@"" font:FONT(13) textColor:COLOR_WHITECOLOR];
        
        _publishTimeLabel.center = CGPointMake(_tempLabel.centerX, _weatherIcon.maxY + 10);
        _publishTimeLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_publishTimeLabel];
        
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}




#pragma mark - private
//确定白天还是晚上
- (void)viewWithRealTimeModel:(TotalWeatherModel *)model andWeatherDetailsInfo:(NSArray *)horlyForecastArray
{
    if (model) {
        
        DailyForecastModel *instantForecastModel = model.instantForecastModel;
        HeWeatherModel *weatherModel = model.weatherModel;
        DailyForecastModel *todayModel = [weatherModel.dailyForecast firstObject];
        // 确定白天还是晚上
        NSString *nowDateStr = [self subTimeWithDate:instantForecastModel.date];
        CGFloat nowTime = [self dateStringToDateFloat:nowDateStr];
        CGFloat sunRiseTime = [self dateStringToDateFloat:instantForecastModel.sr];
        CGFloat sunDownTime = [self dateStringToDateFloat:instantForecastModel.ss];
        if (nowTime >= sunRiseTime && nowTime < sunDownTime) {
            _isNight = NO;
        }else
        {
            _isNight = YES;
        }
        
        _publishTimeLabel.text = [NSString stringWithFormat:@"发布时间：%@",todayModel.date];
        
        _tempLabel.text = [NSString stringWithFormat:@"%@°",instantForecastModel.tmp];
        
        NSString *imageName = [NSString stringWithFormat:@"%@",instantForecastModel.cond_code];
        _weatherIcon.image = [UIImage imageNamed:imageName];
    }
    else
    {
        _publishTimeLabel.text = @"";
        _tempLabel.text = @"N/A";
        _weatherIcon.image = [UIImage imageNamed:@"undefined"];
    }
    [self setNeedsDisplay];
}

- (UILabel *)createLabelWithFrame:(CGRect)frame text:(NSString *)text font:(UIFont *)font textColor:(UIColor *)color
{
    UILabel *label = [self createLabelWithFrame:frame text:text font:font];
    label.textColor = color;
    return label;
}

- (UILabel *)createLabelWithFrame:(CGRect)frame text:(NSString *)text font:(UIFont *)font
{
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.text = text;
    label.font = font;
    return label;
}


//截取时间
- (NSString *)subTimeWithDate:(NSString *)date
{
    NSRange range = [date rangeOfString:@" "];
    return [date substringWithRange:NSMakeRange(range.location + 1, 5)];
}
// 转换时间
- (CGFloat)dateStringToDateFloat:(NSString *)dateStr
{
    CGFloat hour = [[dateStr substringToIndex:2] floatValue];
    CGFloat min = [[dateStr substringFromIndex:3] floatValue];
    
    return hour * 60 + min;
}

#pragma mark - 绘图
- (void)drawRect:(CGRect)rect
{
    NSArray *horlyForecastArray = self.model.horlyForecastArray;
    // 温度坐标线的y值
    CGFloat tempY = _weatherLabel.maxY + 130;
    
    // 获取当前上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // 直线宽
    CGContextSetLineWidth(context, 1.0f);
    
    // 直线颜色
    [COLOR_WHITECOLOR set];
    
    // 直线两端样式
    CGContextSetLineCap(context, kCGLineCapButt);
    
    // 直线连接点样式
    //    CGContextSetLineJoin(context, kCGLineJoinMiter);
    
    const CGPoint points1[] = {CGPointMake(30, tempY), CGPointMake(ScreenWidth - 30, tempY)};
    
    CGContextStrokeLineSegments(context, points1, sizeof(points1) / sizeof(points1[0]));
    
    CGFloat lineWidth = ScreenWidth - 60;
    CGFloat margin = (lineWidth - 20) / 6.0;
    
    // 线的所有起点
    CGPoint startingPoints[] = {
        CGPointMake(40, tempY),CGPointMake(40 + margin, tempY ),CGPointMake(40 + margin * 2, tempY),CGPointMake(40 + margin * 3, tempY),CGPointMake(40 + margin * 4, tempY),CGPointMake(40 + margin * 5, tempY),CGPointMake(40 + margin * 6, tempY)
    };
    
    // 所有的平均温度
    NSMutableArray *tempArray = [NSMutableArray arrayWithCapacity:7];
    if (horlyForecastArray.count == 0) {
        for (int i = 0; i < 7; i++) {
            [tempArray addObject:[NSNumber numberWithInt:0]];
        }
    }
    else
    {
        for (int i = 0; i < 7; i++) {
            HourlyForecastModel *model = horlyForecastArray[i];
            [tempArray addObject:[NSNumber numberWithInt:(int)[self averageThreeHoursTempByModel:model]]];
        }
    }
    
    // 显得所有终点
    CGPoint endingPoints[] = {
        CGPointMake(40 , tempY - [tempArray[0] intValue] * 2),
        CGPointMake(40 + margin, tempY - [tempArray[1] intValue] * 2),
        CGPointMake(40 + margin * 2, tempY - [tempArray[2] intValue] * 2),
        CGPointMake(40 + margin * 3, tempY - [tempArray[3] intValue] * 2 ),
        CGPointMake(40 + margin * 4, tempY - [tempArray[4] intValue] * 2),
        CGPointMake(40 + margin * 5, tempY - [tempArray[5] intValue] * 2),
        CGPointMake(40 + margin * 6, tempY - [tempArray[6] intValue] * 2)
    };
    const CGPoint points2[] = {
        startingPoints[0],endingPoints[0],
        startingPoints[1],endingPoints[1],
        startingPoints[2],endingPoints[2],
        startingPoints[3],endingPoints[3],
        startingPoints[4],endingPoints[4],
        startingPoints[5],endingPoints[5],
        startingPoints[6],endingPoints[6],
    };
    // 绘制温度点
    CGContextSetLineWidth(context, 1.5f);
    
    // 绘制温度和天气
    for(int i = 0 ;i < tempArray.count ; i++)
    {
        HourlyForecastModel *model = nil;
        if(horlyForecastArray.count > 0)
        {
            model = horlyForecastArray[i];
        }
        
        CGRect rect = CGRectMake(endingPoints[i].x - 2.5, endingPoints[i].y - 2.5, 5, 5);
        CGContextFillEllipseInRect(context, rect);
        
        NSString *temp = [NSString  stringWithFormat:@"%d",(int)(tempY / 2 - endingPoints[i].y / 2)];
        NSString *time = model == nil ? @"00:00" : [self subTimeWithDate:model.time];
        NSString *weather = model == nil ? @"N/A" : model.tmp;
        
        // 计算文字的尺寸
        CGSize tempSize = [temp boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : FONT(10)} context:nil].size;
        CGSize timeSize = [time boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : FONT(10)} context:nil].size;
        CGSize weatherSize = [weather boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : FONT(10)} context:nil].size;
        
        CGContextSetTextDrawingMode(context, kCGTextFill);
        
        if ([tempArray[i] intValue] >= 0) {
            [time drawAtPoint:CGPointMake(startingPoints[i].x - timeSize.width / 2, startingPoints[i].y + 5) withAttributes:
             @{ NSFontAttributeName : [UIFont systemFontOfSize:10],
                NSForegroundColorAttributeName : COLOR_WHITECOLOR
                }];
            
            [weather drawAtPoint:CGPointMake(startingPoints[i].x - weatherSize.width / 2, startingPoints[i].y + timeSize.height + 5) withAttributes:
             @{NSFontAttributeName : [UIFont systemFontOfSize:10],
               NSForegroundColorAttributeName : COLOR_WHITECOLOR
               }];
            
            [[NSString stringWithFormat:@"%@°",temp] drawAtPoint:CGPointMake(endingPoints[i].x - tempSize.width / 2, endingPoints[i].y - tempSize.height - 5) withAttributes:
             @{NSFontAttributeName : [UIFont systemFontOfSize:10],
               NSForegroundColorAttributeName : COLOR_WHITECOLOR
               }];
        }
        else
        {
            [time drawAtPoint:CGPointMake(startingPoints[i].x - timeSize.width / 2, startingPoints[i].y - timeSize.height - 5) withAttributes:
             @{ NSFontAttributeName : [UIFont systemFontOfSize:10],
                NSForegroundColorAttributeName : COLOR_WHITECOLOR
                }];
            
            [weather drawAtPoint:CGPointMake(startingPoints[i].x - weatherSize.width / 2, startingPoints[i].y - timeSize.height - 5 - weatherSize.height) withAttributes:
             @{NSFontAttributeName : [UIFont systemFontOfSize:10],
               NSForegroundColorAttributeName : COLOR_WHITECOLOR
               }];
            
            [[NSString stringWithFormat:@"%@°",temp] drawAtPoint:CGPointMake(endingPoints[i].x - tempSize.width / 2, endingPoints[i].y + 5) withAttributes:
             @{NSFontAttributeName : [UIFont systemFontOfSize:10],
               NSForegroundColorAttributeName : COLOR_WHITECOLOR
               }];
        }
        
        
    }
    
    UIBezierPath *path = [[UIBezierPath alloc] init];
    path.lineWidth = 2;
    // 设置起点
    [path moveToPoint:endingPoints[0]];
    
    // 设置路径点
    for (int i = 1; i < 7; i++) {
        [path addLineToPoint:endingPoints[i]];
    }
    [path stroke];
    
    // 绘制坐标轴到坐标的虚线条
    const CGFloat lengths[] = {2, 2};
    CGContextSetLineDash(context, 0, lengths, 2);
    CGContextStrokeLineSegments(context, points2, sizeof(points2) / sizeof(points2[0]));
}

#pragma mark 3小时内的平均温度
- (CGFloat)averageThreeHoursTempByModel:(HourlyForecastModel *)model
{
    if (model) {
        CGFloat temp = 0.5 * ([model.tmp floatValue]);
        return temp;
    }
    return 0.0;
}

#pragma mark - getter / setter
- (void)setModel:(TotalWeatherModel *)model
{
    _model = model;
    
    DailyForecastModel *instantForecastModel = model.instantForecastModel;
    HeWeatherModel *weatherModel = model.weatherModel;
    DailyForecastModel *todayModel = [weatherModel.dailyForecast firstObject];
    
    if (model) {
        _weatherLabel.text = [NSString stringWithFormat:@"%@ %@°~%@°",instantForecastModel.cond_txt,todayModel.tmp_max,todayModel.tmp_min];
        
        _nameLabel.text = weatherModel.location;
    }else
    {
        _weatherLabel.text = @"没有网络数据";
    }
}

- (void)setCityName:(NSString *)cityName
{
    _cityName = cityName;
    _nameLabel.text =cityName;
}


@end

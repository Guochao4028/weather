//
//  WeatherTableView.m
//  AYLWeather
//
//  Created by AYLiOS on 2018/12/3.
//  Copyright © 2018年 AYLiOS. All rights reserved.
//

#import "WeatherTableView.h"

#import "WeekWeatherListCell.h"
#import "TodayWeatherCell.h"

#import "TotalWeatherModel.h"
#import "HeWeatherModel.h"
#import "DailyForecastModel.h"
#import "WeatherMiddleView.h"



#import "WeatherTodayView.h"

@interface WeatherTableView()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic, strong)TodayWeatherCell *todayWeatherCell;
@property(nonatomic, strong)WeatherMiddleView *midView;
@property(nonatomic, strong)UIImageView         *bgImageView;



@property(nonatomic, strong)WeatherTodayView    *todayView;

@end

@implementation WeatherTableView

//init
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame style:UITableViewStylePlain]) {
        //设置数据源和代理
        self.delegate = self;
        self.dataSource = self;
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
        [self registerNib:[UINib nibWithNibName:NSStringFromClass([TodayWeatherCell class]) bundle:nil] forCellReuseIdentifier:@"TodayWeatherCell"];
        [self registerNib:[UINib nibWithNibName:NSStringFromClass([WeekWeatherListCell class]) bundle:nil] forCellReuseIdentifier:@"WeekWeatherListCell"];
        
        
        WeatherMiddleView *midView = [[WeatherMiddleView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 120)];
        midView.backgroundColor = [UIColor clearColor];
        self.midView = midView;
    }
    
    //头视图
    [self addHeaderView];
    
    self.backgroundColor = [UIColor clearColor];
    
    
    return self;
}

#pragma mark - private
//头视图
- (void)addHeaderView{
    
//    self.heardView  = [[WeatherHeardView alloc]initWithFrame:CGRectMake(0, NavHeight, ScreenWidth, 60)];
//    [self addSubview:self.heardView];
//
//    self.tempView = [[WeatherTempView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.heardView.frame), ScreenWidth, 114)];
//    [self addSubview:self.tempView];
//
//    self.midView = [[WeatherMiddleView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 120)];
//    self.midView.backgroundColor = [UIColor clearColor];
//    self.midView.backImageVIew.image = [self imageWithView:self.bgImageView frame:CGRectMake(0, 125 + NAVIBAR_Space, ScreenWidth, 122.5)];
//    self.midView.backImageVIew.hidden = YES;
//    [self.tableHeaderView addSubview:self.midView];
    
    self.tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 367)];
    
    self.todayView = [[WeatherTodayView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 350)];
    [self.tableHeaderView addSubview: self.todayView];
    
}


#pragma mark - UITableViewDataSource & UITableViewDelegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        
        WeekWeatherListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WeekWeatherListCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
        
        [cell setModel:[self.model.weatherModel.dailyForecast objectAtIndex:indexPath.row]];
        
        
        return cell;
    }else{
        TodayWeatherCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TodayWeatherCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
        [cell setModel:[self.model.weatherModel.dailyForecast objectAtIndex:indexPath.row]];
        self.todayWeatherCell = cell;
        return cell;
    }
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    if (section == 0) {
//        return self.model.weatherModel.dailyForecast.count > 0 ? 1:0;
//    }else{
        return self.model.weatherModel.dailyForecast.count;
//    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
//    if (indexPath.section == 0) {
//        return 140;
//    }else{
        return 36;
//    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 120;
    }else{
        return 0;
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    self.midView.weatherList  = self.model.horlyForecastArray;
    return self.midView;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
}


#pragma mark - setter

-(void)setModel:(TotalWeatherModel *)model{
    _model = model;
    
    _todayView.model = model;
    [self.todayView viewWithRealTimeModel:model andWeatherDetailsInfo:model.horlyForecastArray];
    
}

@end

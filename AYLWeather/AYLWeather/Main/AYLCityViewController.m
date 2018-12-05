//
//  AYLCityViewController.m
//  AYLWeather
//
//  Created by AYLiOS on 2018/12/3.
//  Copyright © 2018年 AYLiOS. All rights reserved.
//

#import "AYLCityViewController.h"
#import "WeatherCityView.h"

@interface AYLCityViewController ()<WeatherCityViewDelegate>

@property(nonatomic, strong)WeatherCityView *cityView;

@end

@implementation AYLCityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - private

-(void)initUI{
    self.cityView = [[WeatherCityView alloc]initWithFrame:self.view.bounds];
    [self.cityView setDelegate:self];
    [self.view addSubview:self.cityView];
    
    self.title = @"选择城市";
    
    
    UIImageView *arrow = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"arrow"]];
    arrow.frame = CGRectMake(0, 0, 30, 40);
    arrow.contentMode = UIViewContentModeLeft;
    [arrow setUserInteractionEnabled:YES];
    UITapGestureRecognizer *tapGest = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(back)];
    [arrow addGestureRecognizer:tapGest];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:arrow];
    self.navigationItem.leftBarButtonItem = item;
    
}

-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - WeatherCityViewDelegate

-(void)cityView:(WeatherCityView *)view getCityName:(NSString *)cityName{
    
    [self.navigationController popViewControllerAnimated:YES];
    
    if ([self.delegate respondsToSelector:@selector(cityViewController:getCityName:)] == YES) {
        [self.delegate cityViewController:self getCityName:cityName];
    }
}

@end

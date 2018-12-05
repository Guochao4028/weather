//
//  AYLWeatherViewController.m
//  AYLWeather
//
//  Created by AYLiOS on 2018/11/28.
//  Copyright © 2018年 AYLiOS. All rights reserved.
//

#import "AYLWeatherViewController.h"
#import "UIView+AYLFrameLayout.h"
#import "BaseEmitterLayer.h"
#import "RainEmitterLayer.h"
#import "SnowEmitterLayer.h"
#import "CloudEmitterLayer.h"
#import "HeWeatherModel.h"
#import "DailyForecastModel.h"


#import "WeatherMiddleView.h"
#import "WeekWeatherListCell.h"
#import "TodayWeatherCell.h"
#import "WeatherCityView.h"
#import "AYLCityViewController.h"
#import "WeatherCollectionView.h"
#import "TotalWeatherModel.h"
#import "AYLCityManageViewController.h"

@interface AYLWeatherViewController ()< WeatherCityViewDelegate, WeatherCollectionViewDelegate, AYLCityManageViewControllerDelegate>

@property(nonatomic, strong)UserInfoManager *infoManager;
@property(nonatomic, strong)HeWeatherModel *weatherModel;
@property(nonatomic, strong)DailyForecastModel *instantForecastModel;
@property(nonatomic, assign)CGFloat navOffY;
@property(nonatomic, strong)NSArray *hourlyForecastArray;
@property(nonatomic, assign)NSInteger isFirst;
@property(nonatomic, strong)WeatherCityView *cityView;


@property(nonatomic, strong)WeatherCollectionView *collectionView;
@property(nonatomic, strong)NSMutableArray *dataListArray;


@property(nonatomic, strong)UIView *footterView;
@property(nonatomic, strong)UILabel *line;
@property(nonatomic, strong)UIButton *addButton;
@property(nonatomic, strong)UIImageView *buttonIconImageView;
//分页控制器
@property(nonatomic, strong)UIPageControl *pageC;
@property(nonatomic, strong)UIImageView *bgImage;



@end

@implementation AYLWeatherViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initUI];
    
    [self initData];
    
    [self.infoManager addObserver:self forKeyPath:@"userLocation" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    
    CLLocationCoordinate2D coordinate = self.infoManager.userLocation.coordinate;
    if ((coordinate.longitude != 0) &&(coordinate.latitude != 0)) {
        [self updateData];
    }
}

-(void)viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    
    if ([[NSUserDefaults standardUserDefaults]objectForKey:ISFIRST] == nil) {
        self.isFirst = 1;
        self.cityView = [[WeatherCityView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
        [self.cityView setDelegate:self];
        [self.view addSubview:self.cityView];
        [[NSUserDefaults standardUserDefaults]setObject:@"1" forKey:ISFIRST];
    }
    
    [super viewWillAppear:animated];
}

-(void)viewDidDisappear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [super viewDidDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc{
    [self.infoManager removeObserver:self forKeyPath:@"userLocation"];
}

#pragma mark - private
//初始化数据
-(void)initData{
    self.infoManager = [UserInfoManager shareInstance];
    
    self.infoManager.cityListArray = HISTORYDATA;
    self.dataListArray = [NSMutableArray array];
    for (NSString *city in HISTORYDATA) {
        [self loadCurrentDay:city];
    }
}
//初始化ui
-(void)initUI{
    
    self.bgImage = [[UIImageView alloc]initWithFrame:self.view.bounds];
    [self.bgImage setImage:[UIImage imageNamed:@"bg_normal"]];
    [self.view addSubview:self.bgImage];
    
    self.collectionView = [[WeatherCollectionView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight -60)];
    [self.collectionView setP_Delegate:self];
    [self.collectionView setDataSourceArray:self.dataListArray];
    [self.view addSubview:self.collectionView];
    
    self.footterView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.collectionView.frame), ScreenWidth, 60)];
    [self.view addSubview:self.footterView];
    
    self.line = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 0.5)];
    [self.line setBackgroundColor:[UIColor whiteColor]];
    [self.footterView addSubview:self.line];
    
    self.buttonIconImageView  = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"location_hardware"]];
    [self.buttonIconImageView setFrame:CGRectMake((ScreenWidth - 40 ), 18, 30, 30)];
    [self.footterView addSubview:self.buttonIconImageView];
    
    self.addButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.addButton setFrame:CGRectMake((ScreenWidth - 60 ), 0, 60, 60)];
    [self.addButton addTarget:self action:@selector(changeCity) forControlEvents:UIControlEventTouchUpInside];
    [self.footterView addSubview:self.addButton];
    
    
    self.pageC = [[UIPageControl alloc] initWithFrame:CGRectMake((ScreenWidth - 70)/2, 20, 70, 10)];
    
    [self.footterView addSubview:self.pageC];
    
    self.collectionView.pageC = _pageC;
    
}
//更新UI
-(void)updateUI{
    
    self.pageC.numberOfPages = self.dataListArray.count;
    //刷新页面
    [self.collectionView setDataSourceArray:self.dataListArray];
    [self.collectionView reloadData];
    
    [self updateEmitterLayer:0];
}
//更新数据
-(void)updateData{
    for (NSString *city in HISTORYDATA) {
        NSLog(@"city : %@",city);
        [self loadCurrentDay:city];
    }
}

-(void)loadCurrentDay:(NSString *)cityName{
    //清空天气数组
    [self.dataListArray removeAllObjects];
    [self updateUI];
    //拼接参数
    NSDictionary *dic = @{@"location":cityName};
    
    //网络请求
    [[DataManager shareInstance]getNowForecastParameter:dic callback:^(NSObject *object) {
        
        //存储天气数据
        TotalWeatherModel *model = (TotalWeatherModel *)object;
        [self.dataListArray addObject: model];
        [self updateUI];
    }];
}

//更新背景动画
-(void)updateEmitterLayer:(NSInteger)currentPage{
    
    for (int i = 0; i < [self.view.layer sublayers].count; i++) {
        if ([[self.view.layer sublayers][i] isKindOfClass:[BaseEmitterLayer class]] == YES) {
            
            BaseEmitterLayer *leayer = (BaseEmitterLayer *)[self.view.layer sublayers][i];
            [leayer setValue:[NSNumber numberWithFloat:0]
                       forKeyPath:@"linear"];
            [leayer removeFromSuperlayer];
        }
    }
    
  
    
    if (self.dataListArray.count > 0) {
        TotalWeatherModel *model = [self.dataListArray objectAtIndex:currentPage];
        DailyForecastModel *instantForecastModel = model.instantForecastModel;
        //具体天气 动画
        BaseEmitterLayer *emitterLayer;
        switch ([instantForecastModel.cond_code integerValue]) {
            case 100:{}
            case 101:{}
            case 102:{
                emitterLayer = [CloudEmitterLayer instanceWithFrame:self.view.bounds type:CLOUD_LITTER_DAY_TYPE];
                break;
            }
            case 103:{
                emitterLayer = [CloudEmitterLayer instanceWithFrame:self.view.bounds type:CLOUD_MUCH_DAY_TYPE];
                break;
            }
            case 104:{
                emitterLayer = [CloudEmitterLayer instanceWithFrame:self.view.bounds type:CLOUD_CLOUDY_DAY_TYPE];
                break;
            }
            case 300:{}
            case 301:{}
            case 302:{}
            case 303:{}
            case 304:{
                emitterLayer = [RainEmitterLayer instanceWithFrame:self.view.bounds type:RAIN_THUNDERSHOWER_TYPE];
                break;
            }
            case 309:{}
            case 399:{}
            case 305:{
                emitterLayer = [RainEmitterLayer instanceWithFrame:self.view.bounds type:RAIN_LITTER_TYPE];
                break;
            }
            case 314:{}
            case 306:{
                emitterLayer = [RainEmitterLayer instanceWithFrame:self.view.bounds type:RAIN_MIDDLE_TYPE];
                break;
            }
            case 310:{}
            case 311:{}
            case 312:{}
            case 308:{}
            case 313:{}
            case 316:{}
            case 317:{}
            case 318:{}
            case 307:{
                emitterLayer = [RainEmitterLayer instanceWithFrame:self.view.bounds type:RAIN_HEAVY_TYPE];
                break;
            }
                
            case 400:{}
            case 407:{}
            case 499:{
                emitterLayer = [SnowEmitterLayer instanceWithFrame:self.view.bounds type:SNOW_Little_TYPE];
                break;
            }
            case 401:{
                emitterLayer = [SnowEmitterLayer instanceWithFrame:self.view.bounds type:SNOW_Middle_TYPE];
                break;
            }
            case 403:{}
            case 410:{}
            case 402:{
                emitterLayer = [SnowEmitterLayer instanceWithFrame:self.view.bounds type:SNOW_Middle_TYPE];
                break;
            }
                
            case 405:{}
            case 406:{}
            case 404:{
                emitterLayer = [SnowEmitterLayer instanceWithFrame:self.view.bounds type:SNOW_SLEET_TYPE];
                break;
            }
                
                
            default:
                break;
        }
        [self.view.layer addSublayer:emitterLayer];
    }
}

#pragma mark - WeatherCityViewDelegate
-(void)cityView:(WeatherCityView *)view getCityName:(NSString *)cityName
{
    if (self.isFirst != 0) {
        [self.cityView removeFromSuperview];
        [[NSUserDefaults standardUserDefaults] setObject:@[cityName] forKey:HISTORYDATAIDENTIFIER];
        [self.infoManager setCityListArray:@[cityName]];
        [self updateData];
    }
}

#pragma mark - kvo
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    if (self.cityView != nil) {
        [self.cityView removeFromSuperview];
    }
    
    //获取变更后的经纬度
    CLLocationCoordinate2D coordinate = self.infoManager.userLocation.coordinate;
    if ((coordinate.longitude != 0) &&(coordinate.latitude != 0)) {
         NSString *str = [NSString stringWithFormat:@"%f,%f",coordinate.longitude, coordinate.latitude];
        if ([self.infoManager cityListArray].count > 0) {
            NSMutableArray *cityArray = [NSMutableArray arrayWithArray:[self.infoManager cityListArray]];
            [cityArray addObject:str];
            [[NSUserDefaults standardUserDefaults] setObject:cityArray forKey:HISTORYDATAIDENTIFIER];
            [self.infoManager setCityListArray:cityArray];
        }else{
            [self.infoManager setCityListArray:@[str]];
            [[NSUserDefaults standardUserDefaults] setObject:@[str] forKey:HISTORYDATAIDENTIFIER];
        }
        
        
        NSSet *set = [NSSet setWithArray:HISTORYDATA];
        [[NSUserDefaults standardUserDefaults] setObject:[set allObjects] forKey:HISTORYDATAIDENTIFIER];
        [[NSUserDefaults standardUserDefaults]synchronize];
        [self updateData];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_LOCATION object:self.infoManager];
    }
}

#pragma mark - action
- (void)changeCity {
    AYLCityManageViewController *cityVC = [[AYLCityManageViewController alloc]init];
    [cityVC setDelegate:self];
    [self.navigationController pushViewController:cityVC animated:YES];
}

#pragma mark - AYLCityManageViewControllerDelegate

-(void)cityManageViewControllerReloadData{
    
    NSLog(@"cityManageViewControllerReloadData");
    
    [self updateData];
}

#pragma mark - WeatherCollectionViewDelegate
-(void)weatherCollectinView:(WeatherCollectionView *)view getCurrentPage:(NSInteger)currentPage{
    //更新背景动画
    [self updateEmitterLayer:currentPage];
}


@end

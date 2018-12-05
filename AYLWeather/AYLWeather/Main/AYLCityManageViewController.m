//
//  AYLCityManageViewController.m
//  AYLWeather
//
//  Created by AYLiOS on 2018/12/5.
//  Copyright © 2018年 AYLiOS. All rights reserved.
//

#import "AYLCityManageViewController.h"
#import "WeatherCityManagerCell.h"
#import "UIAlertController+AYLCustom.h"
#import "AYLCityViewController.h"

@interface AYLCityManageViewController ()<UITableViewDataSource,UITableViewDelegate,CLLocationManagerDelegate, AYLCityViewControllerDelegate>

@property (nonatomic, strong) UITableView    *tableView;
//定位
@property (nonatomic, strong) CLLocationManager *locationManager;
//地理编码
@property (nonatomic, strong) CLGeocoder        *geoceder;
//定位到的当前城市名
@property (nonatomic, strong) UILabel           *currentCityName;
//定位开关
@property (nonatomic, strong) UISwitch          *locationSwitch;

@property (nonatomic, strong)NSMutableArray *dataArray;

@end

@implementation AYLCityManageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"城市管理";
    [self createUI];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updataLoction:) name:NOTIFICATION_LOCATION object:nil];
    
    NSMutableArray *historyDataArray = [NSMutableArray arrayWithArray:HISTORYDATA];
    NSString *str = [[UserInfoManager shareInstance] getLocation];
    [historyDataArray removeObject:str];
    self.dataArray = historyDataArray;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [_tableView reloadData];
}

-(void)dealloc

{
    //移除观察者，Observer不能为nil
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - private
- (void)createUI
{
    [self createAddBtn];
    [self createTableView];
}

- (void)createTableView
{
    _tableView = [[UITableView alloc] initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStylePlain];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"TableViewCell"];
    
    [self.view addSubview:_tableView];
    
    [self createTableHeaderView];
}

- (void)createTableHeaderView{
    UIButton *headerButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 50)];
    
    [headerButton addTarget:self action:@selector(headerViewBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    // 添加定位的图片
    UIImageView *locationIcon = [[UIImageView alloc] initWithFrame:CGRectMake(20, 15, 15, 20)];
    locationIcon.image = [UIImage imageNamed:@"locationIcon"];
    [headerButton addSubview:locationIcon];
    
    //显示当前城市名
    _currentCityName = [[UILabel alloc] initWithFrame:CGRectMake(45, 15, 200, 20)];
    if ([[UserInfoManager shareInstance]userLocation] != nil) {
        _currentCityName.text = [[UserInfoManager shareInstance]getLocation];
    }else
    {
        _currentCityName.text = @"自动定位";
    }
    _currentCityName.font = FONT(18);
    [headerButton addSubview:_currentCityName];
    
    // 定位开关
    _locationSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(ScreenWidth - 60, 10, 50, 20)];
    _locationSwitch.on = [[UserInfoManager shareInstance]userLocation] != nil;
    [_locationSwitch addTarget:self action:@selector(changeLocationSwith:) forControlEvents:UIControlEventValueChanged];
    [headerButton addSubview:_locationSwitch];
    
    // 添加底线
    
    UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(10, 49, ScreenWidth - 10, 1)];
    [line setBackgroundColor:[UIColor lightGrayColor]];
    [headerButton addSubview:line];
    _tableView.tableHeaderView = headerButton;
}

-(void)headerViewBtnClick{
    //    if (_appDelegate.currentCityModel) {
    //        if ([_delegate respondsToSelector:@selector(cityManagerVCPopToLocationCity)]) {
    //            [_delegate cityManagerVCPopToLocationCity];
    //        }
    //        [self.navigationController popViewControllerAnimated:YES];
    //    }else
    //    {
    //        [XCView showAlertViewWithMessage:@"请打开定位" target:self];
    //    }
}

//改变定位开关
- (void)changeLocationSwith:(UISwitch *)sender
{
    if (sender.isOn) {
        if ([CLLocationManager locationServicesEnabled]) {
            [self.locationManager startUpdatingLocation];
        }else{
            // 如果定位服务不可用，提醒用户，检查设置和网络
            [UIAlertController showAlertViewWithMessage:@"请确定网络连接是否可用或在设置中应用的定位权限是否打开" target:self handler:^{
                sender.on = NO;
            }];
            [self.locationManager stopUpdatingLocation];
            self.locationManager = nil;
        }
    }else
    {
        _currentCityName.text = @"自动定位";
        [self.locationManager stopUpdatingLocation];
        _locationManager = nil;
    }
}

//创建添加按扭
- (void)createAddBtn{
    UIBarButtonItem *addItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(pushCitysViewController)];
    self.navigationItem.rightBarButtonItems = @[addItem];
    
    
    UIImageView *arrow = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"arrow"]];
    arrow.frame = CGRectMake(0, 0, 30, 40);
    arrow.contentMode = UIViewContentModeLeft;
    [arrow setUserInteractionEnabled:YES];
    UITapGestureRecognizer *tapGest = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(back)];
    [arrow addGestureRecognizer:tapGest];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:arrow];
    self.navigationItem.leftBarButtonItem = item;
}


#pragma mark - action
// 点击添加，跳转到城市选择控制器
- (void)pushCitysViewController
{
    AYLCityViewController *cityVC = [[AYLCityViewController alloc]init];
    [cityVC setDelegate:self];
    [self.navigationController pushViewController:cityVC animated:YES];
}

-(void)back{
    if ([self.delegate respondsToSelector:@selector(cityManageViewControllerReloadData)] == YES) {
        [self.delegate cityManageViewControllerReloadData];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITableViewDataSource & UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TableViewCell"];
    [cell.textLabel setText:self.dataArray[indexPath.row]];
    [cell.imageView setImage:[UIImage imageNamed:@"cityIcon"]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}


- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

//删除
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cityName = self.dataArray[indexPath.row];
    
    //删除城市信息之前，先删除对应的天气信息
    NSMutableArray *historyDataArray = [NSMutableArray arrayWithArray:HISTORYDATA];
    [historyDataArray removeObject:cityName];
    
    NSSet *set = [NSSet setWithArray:historyDataArray];
    [[NSUserDefaults standardUserDefaults] setObject:[set allObjects] forKey:HISTORYDATAIDENTIFIER];
    [[NSUserDefaults standardUserDefaults]synchronize];
    UserInfoManager *infoManager = [UserInfoManager shareInstance];
    [infoManager setCityListArray:historyDataArray];
    NSString *str = [[UserInfoManager shareInstance] getLocation];
    [historyDataArray removeObject:str];
    self.dataArray = historyDataArray;
    [tableView reloadData];
}





#pragma mark - AYLCityViewControllerDelegate
-(void)cityViewController:(AYLCityViewController *)vc getCityName:(NSString *)cityName{
    UserInfoManager *infoManager = [UserInfoManager shareInstance];
    if ([infoManager cityListArray].count > 0) {
        NSMutableArray *cityArray = [NSMutableArray arrayWithArray:[infoManager cityListArray]];
        [cityArray addObject:cityName];
        [[NSUserDefaults standardUserDefaults] setObject:cityArray forKey:HISTORYDATAIDENTIFIER];
        [infoManager setCityListArray:cityArray];
    }else{
        [infoManager setCityListArray:@[cityName]];
        [[NSUserDefaults standardUserDefaults] setObject:@[cityName] forKey:HISTORYDATAIDENTIFIER];
    }
    //过滤重复数据
    NSSet *set = [NSSet setWithArray:HISTORYDATA];
    [[NSUserDefaults standardUserDefaults] setObject:[set allObjects] forKey:HISTORYDATAIDENTIFIER];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    NSMutableArray *historyDataArray = [NSMutableArray arrayWithArray:HISTORYDATA];
    
    [infoManager setCityListArray:historyDataArray];
    
    NSString *str = [[UserInfoManager shareInstance] getLocation];
    [historyDataArray removeObject:str];
    self.dataArray = historyDataArray;
    
    [self.tableView reloadData];
}


#pragma mark - Notification
-(void)updataLoction:(NSNotification *)noti{
    
    if ([[UserInfoManager shareInstance]userLocation] != nil) {
        _currentCityName.text = [[UserInfoManager shareInstance]getLocation];
    }
    NSMutableArray *historyDataArray = [NSMutableArray arrayWithArray:HISTORYDATA];
    NSString *str = [[UserInfoManager shareInstance] getLocation];
    [historyDataArray removeObject:str];
    self.dataArray = historyDataArray;
    
    [self.tableView reloadData];
}

#pragma mark - getter / setter

- (CLGeocoder *)geoceder{
    if (_geoceder == nil) {
        _geoceder = [[CLGeocoder alloc]init];
    }
    return _geoceder;
}

- (CLLocationManager *)locationManager
{
    if (_locationManager == nil) {
        _locationManager = [[CLLocationManager alloc]init];
        _locationManager.delegate = self;
        _locationManager.distanceFilter = 10000;
        
        // iOS8需要添加如下代码
        if ([UIDevice currentDevice].systemVersion.floatValue >= 8.0) {
            [_locationManager requestAlwaysAuthorization]; // 请求一直定位
            [_locationManager requestWhenInUseAuthorization]; // 请求在使用中定位
        }
        
    }
    return _locationManager;
}


@end

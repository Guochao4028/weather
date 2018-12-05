//
//  WeatherCityView.m
//  AYLWeather
//
//  Created by AYLiOS on 2018/12/3.
//  Copyright © 2018年 AYLiOS. All rights reserved.
//

#import "WeatherCityView.h"

#import "CityCollectionViewCell.h"

static NSString *identifier = @"cell";
static NSString *header = @"header";
static NSString *footer = @"footer";

@interface WeatherCityView ()<UICollectionViewDelegateFlowLayout,UICollectionViewDataSource,UITextFieldDelegate>

@property(nonatomic, strong)UICollectionView *collectionView;
//城市数组
@property(nonatomic, strong)NSArray *cityArray;
//筛选前的数组
@property(nonatomic, strong)NSMutableArray *oldCityArray;
//检索text
@property(nonatomic, strong)UITextField *textField;
@end


@implementation WeatherCityView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self != nil) {
        self.backgroundColor = [UIColor clearColor];
        [self initUI];
    }
    return self;
}

-(void)initUI{
    //接收_textFieldText值改变的通知
    [self receiveTextValueChange];
    //添加城市的collectionview
    [self addCollectionView];
}

#pragma mark - private
//接收_textFieldText值改变的通知
- (void)receiveTextValueChange{
    if (!_textField) {
        _textField = [[UITextField alloc]initWithFrame:CGRectMake(20, 10, CGRectGetWidth(self.bounds) - 40, 30)];
        _textField.backgroundColor = BGCOLOR;
        _textField.placeholder = @"请输入城市名";
        _textField.layer.cornerRadius = 10;
        _textField.layer.masksToBounds = YES;
        _textField.textAlignment = NSTextAlignmentCenter;
        _textField.returnKeyType = UIReturnKeySearch;
        _textField.delegate = self;
    }
}


//添加城市的collectionview
- (void)addCollectionView{
    //1.创建布局类
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    //设置滑动方向
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    //设置单元格大小
    layout.itemSize = CGSizeMake((ScreenWidth-60)/3, 50);
    //设置单元格之间的间隙
    layout.minimumLineSpacing = 20;
    layout.minimumInteritemSpacing = 10;
    //设置头部视图和尾部视图大小
    layout.headerReferenceSize = CGSizeMake(ScreenWidth, 40);
    //初始化
    self.collectionView = [[UICollectionView alloc]initWithFrame:self.bounds collectionViewLayout:layout];
    //设置代理和数据源
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    //添加到view
    [self addSubview:self.collectionView];
    //注册单元格和头部视图
    //注册单元格
    [self.collectionView registerClass:[CityCollectionViewCell class] forCellWithReuseIdentifier:identifier];
    
    
    //6.注册头部和尾部视图
    /*
     registerClass: 头部视图或尾部视图类型 UICollectionReusableView
     forSupplementaryViewOfKind：头部视图与尾部视图的区分
     withReuseIdentifier：标识符  不可以与单元格标识符混用
     */
    [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:header];
    
    [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:footer];
    
    //数据源
    [self loadData];
    
}

//数据源
- (void)loadData{
    self.oldCityArray = [NSMutableArray array];
    //文件路径
    NSString *path = [[NSBundle mainBundle]pathForResource:@"city" ofType:@"plist"];
    //外层字典
    NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:path];
    //数组
    NSArray *result = [dic objectForKey:@"result"];
    for (NSDictionary *cityDic in result) {
        int a = 1;
        //查看数组中是否有当前城市
        for (NSString *name in self.oldCityArray) {
            if ([name isEqualToString:[cityDic objectForKey:@"city"]]) {
                a = 0;
                break;
            }
        }
        //如果没有则添加
        if (a) {
            [self.oldCityArray addObject:[cityDic objectForKey:@"city"]];
        }
    }
    
    self.cityArray = [NSArray arrayWithArray:self.oldCityArray];
}

#pragma mark -  UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    //获取textfield
    NSString *str = [NSString stringWithFormat:@"%@",textField.text];
    //创建谓词条件
    NSPredicate *pred = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"self like[C]'*%@*'",str]];
    //通过谓词条件过滤
    self.cityArray = [self.oldCityArray filteredArrayUsingPredicate:pred];
    
    NSLog(@"_new = %@",self.cityArray);
    
    [_collectionView reloadData];
    return YES;
}

#pragma mark - UICollectionViewDataSource


//返回单元格数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.cityArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    CityCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    
    cell.cityName = self.cityArray[indexPath.row];
    //    cell.backgroundColor = [UIColor redColor];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    //a用来标记是否查找到
    int a = 1;
    
    for (NSString *str in HISTORYDATA) {
        if ([str isEqualToString:self.cityArray[indexPath.row]]) {
            a = 0;
            break;
        }
    }
    if (a) {
        NSString *name = self.cityArray[indexPath.row];
        if ([self.delegate respondsToSelector:@selector(cityView:getCityName:)] != 0) {
            [self.delegate cityView:self getCityName:name];
        }
    }
}

//创建头部视图
-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    //判断类型是否为头部视图
    if (kind == UICollectionElementKindSectionHeader) {
        //创建头部视图
        UICollectionReusableView *headerCell = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:header forIndexPath:indexPath];
        
        [headerCell addSubview:_textField];
        
        return headerCell;
    }
    return nil;
}


//设置四周间距 上下左右
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(10, 10, 10, 10);
}


//单元格即将消失
- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath{
    
    CityCollectionViewCell *celll = (CityCollectionViewCell *)cell;
    
    celll.label.textColor = [UIColor blackColor];
    celll.label.backgroundColor = BGCOLOR;
}


@end

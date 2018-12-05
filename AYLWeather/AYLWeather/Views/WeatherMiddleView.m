//
//  WeatherMiddleView.m
//  AYLWeather
//
//  Created by AYLiOS on 2018/11/30.
//  Copyright © 2018年 AYLiOS. All rights reserved.
//

#import "WeatherMiddleView.h"

#import "WeatherMiddleListCell.h"

@interface WeatherMiddleView()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic ,strong) UICollectionView *collectionView;

@end


@implementation WeatherMiddleView


- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.collectionView];
        self.backImageVIew = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 120)];
        self.backImageVIew.contentMode = UIViewContentModeScaleToFill;
        [self insertSubview:self.backImageVIew atIndex:0];
        
        
        UIView *line1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 0.5)];
        line1.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.6];
        [self addSubview:line1];
        
        UIView *line2 = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetHeight(self.bounds) - 0.5, ScreenWidth, 0.5)];
        line2.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.6];
        [self addSubview:line2];
        
    }
    return self;
}

#pragma mark - collectionView dataSource and delegate
// 自定义cell
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    WeatherMiddleListCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"WeatherMiddleListCell" forIndexPath:indexPath];
    [cell setModel:[self.weatherList objectAtIndex:indexPath.row]];
    return cell;
}

// 分区数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

// 每个分区的cell数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.weatherList.count;
}

// 自定义item
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    return CGSizeMake(80,120);
}


//每个分组的边缘尺寸

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

//每个分组的行间距

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    
    return 0.f;
    
}

//每个分组的列间距

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.f;
}

// 每个分区的头部尺寸
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    
    return CGSizeMake(0, 0);
}

//返回头／尾视图的样式
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}


// 点击方法
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
}

#pragma mark - getter

- (UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *flow = [[UICollectionViewFlowLayout alloc] init];
        flow.sectionHeadersPinToVisibleBounds = YES;
        flow.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 120) collectionViewLayout:flow];
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.showsHorizontalScrollIndicator = NO;
        [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
        [_collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([WeatherMiddleListCell class]) bundle:nil] forCellWithReuseIdentifier:@"WeatherMiddleListCell"];
    }
    return _collectionView;
}

-(void)setWeatherList:(NSArray *)weatherList{
    
    _weatherList = weatherList;
    [self.collectionView reloadData];
}


@end

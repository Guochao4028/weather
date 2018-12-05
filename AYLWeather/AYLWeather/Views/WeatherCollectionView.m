//
//  WeatherCollectionView.m
//  AYLWeather
//
//  Created by AYLiOS on 2018/12/3.
//  Copyright © 2018年 AYLiOS. All rights reserved.
//

#import "WeatherCollectionView.h"
#import "WeatherListCollectionViewCell.h"
#import "WeatherTableView.h"

static NSString *identifier = @"WeatherCollectionCell";

@interface WeatherCollectionView()<UICollectionViewDelegateFlowLayout,UICollectionViewDataSource>

@end

@implementation WeatherCollectionView

//重写init方法
- (instancetype)initWithFrame:(CGRect)frame{
    //1.创建布局类
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    //设置滑动方向
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    //设置单元格大小
    layout.itemSize = CGSizeMake(ScreenWidth, ScreenHeight-[[UIApplication sharedApplication] statusBarFrame].size.height - 40);
    //设置单元格之间的间隙
    layout.minimumLineSpacing = 0;
    
    self.backgroundColor = [UIColor whiteColor];
    
    if (self = [super initWithFrame:frame collectionViewLayout:layout]) {
        //设置代理
        self.delegate = self;
        self.dataSource = self;
        //注册单元格
        [self registerClass:[WeatherListCollectionViewCell class] forCellWithReuseIdentifier:identifier];
        //分页效果
        self.pagingEnabled = YES;
    }
    return self;
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataSourceArray.count;
}

//返回单元格
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    WeatherListCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    cell.pageC = _pageC;
    cell.totalWeatherModel = self.dataSourceArray[indexPath.row];
    return cell;
}

//结束滑动
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{
    _pageC.currentPage = targetContentOffset->x/ScreenWidth;
    
    if ([self.p_Delegate respondsToSelector:@selector(weatherCollectinView:getCurrentPage:)] == YES) {
        [self.p_Delegate weatherCollectinView:self getCurrentPage:[_pageC currentPage]];
    }
    
}

//视图将要消失时
- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath{
    //设置滑动离开当前页面后  表视图偏移量为0
    WeatherListCollectionViewCell *celll = (WeatherListCollectionViewCell *)cell;
    celll.weatherTableView.contentOffset = CGPointMake(0, 0);
}

- (void)reloadData{
    [super reloadData];
    
    if (self.dataSourceArray.count > 0) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        
        _pageC.currentPage = 0;
        
        [self scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
    }
    
}


@end

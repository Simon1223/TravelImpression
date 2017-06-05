//
//  TankCycleScrollView.m
//  TankCarouselFigure
//
//  Created by yanwb on 15/12/23.
//  Copyright © 2015年 JINMARONG. All rights reserved.
//

#import "HDParallaxHeaderView.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface HDParallaxHeaderView () <UIScrollViewDelegate>
//定时器
@property (nonatomic, strong) NSTimer *animationTimer;

//是否启动定时器
@property (nonatomic, assign) BOOL openTimer;

//轮播视图
@property (nonatomic, weak) UIScrollView *parallaxScrollView;
//定时器时间
@property (nonatomic, assign) NSTimeInterval animationDuration;
//当前显示页码
@property (nonatomic, assign) NSInteger currentPageIndex;
//总页码数
@property (nonatomic, assign) NSInteger totalPageCount;
//用于显示的图片控件数组
@property (nonatomic, strong) NSMutableArray *contentViews;
//总图片控件数组
@property (nonatomic, strong) NSMutableArray *subContentViews;
////点击页码
//@property (nonatomic, assign) NSInteger currentSelectIndex;
//实际滚动焦点图数组
@property (nonatomic, strong) NSMutableArray *parallaxCarouselArray;
//当前请求失败次数
@property (nonatomic, assign) NSInteger currentNetWorkFaildCount;
//页码显示器
@property (nonatomic, strong) UIPageControl *pageControl;
//初始宽度
@property (nonatomic, assign) CGFloat orginWidth;
//初始高度
@property (nonatomic, assign) CGFloat orginHeight;
//拉伸显示图片
@property (nonatomic, weak) UIImageView *stretchImageView;


@end

@implementation HDParallaxHeaderView

- (id)initWithFrame:(CGRect)frame animationDuration:(NSTimeInterval)animationDuration openTimer:(BOOL)open
{
    self = [self initWithFrame:frame];
    self.frame = frame;
    self.orginWidth = frame.size.width;
    self.orginHeight = frame.size.height;
    self.parallaxPageControlAliment = HDParallaxPageContolAlimentCenter;
    self.parallaxCurrentPageIndicatorTintColor = [UIColor blueColor];
    self.parallaxPageIndicatorTintColor = [UIColor whiteColor];
    self.showPageControl = YES;
    self.enbleStretch = NO;
    self.openTimer = open;
    if (animationDuration > 0.0 && open) {
        // 设置定时器
        self.animationTimer = [NSTimer scheduledTimerWithTimeInterval:(self.animationDuration = animationDuration)
                                                               target:self
                                                             selector:@selector(animationTimerDidFired:)
                                                             userInfo:nil
                                                              repeats:YES];
        [self.animationTimer pauseTimer];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        // Initialization code
        self.networkFailedCount = 10;
        self.autoresizesSubviews = YES;
        UIScrollView *parallaxScrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        parallaxScrollView.autoresizingMask = 0xFF;
        parallaxScrollView.contentMode = UIViewContentModeScaleAspectFit;
        parallaxScrollView.contentSize = CGSizeMake(3 * CGRectGetWidth(parallaxScrollView.frame), 0);
        parallaxScrollView.delegate = self;
        parallaxScrollView.contentOffset = CGPointMake(CGRectGetWidth(parallaxScrollView.frame), 0);
        parallaxScrollView.pagingEnabled = YES;
        parallaxScrollView.showsHorizontalScrollIndicator = NO;
        [self addSubview:parallaxScrollView];
        self.currentPageIndex = 0;
        self.parallaxScrollView = parallaxScrollView;
        
        
        UIImageView *stretchImageView = [[UIImageView alloc] initWithFrame:self.parallaxScrollView.frame];
        self.stretchImageView = stretchImageView;
        stretchImageView.hidden = YES;
        stretchImageView.clipsToBounds = YES;
        stretchImageView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:stretchImageView];
    }
    return self;
}

- (NSMutableArray *)subContentViews
{
    if (_subContentViews == nil) {
        _subContentViews = [NSMutableArray array];
    }
    return _subContentViews;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    UIPageControl *pageControl = [[UIPageControl alloc]init];
    pageControl.currentPageIndicatorTintColor = self.parallaxCurrentPageIndicatorTintColor;
    pageControl.pageIndicatorTintColor = self.parallaxPageIndicatorTintColor;
    pageControl.numberOfPages = self.totalPageCount;
    self.pageControl = pageControl;
    if (self.parallaxPageControlAliment == HDParallaxPageContolAlimentCenter) {
        pageControl.frame = CGRectMake((CGRectGetWidth(self.frame) - 100) * 0.5, CGRectGetHeight(self.frame) - 30, 100, 30);
    } else {
        pageControl.frame = CGRectMake(CGRectGetWidth(self.frame) - 120, CGRectGetHeight(self.frame) - 30, 100, 30);
    }
    [self addSubview:self.pageControl];
    
    if (self.showPageControl) {
        if (self.totalPageCount > 1) {
            pageControl.hidden = NO;
        } else {
            pageControl.hidden = YES;
        }
    } else {
        pageControl.hidden = YES;
    }
    self.pageControl.currentPage = self.currentPageIndex;
}

- (void)setModelArray:(NSArray *)modelArray
{
    _modelArray = modelArray;
}

- (void)setParallaxImageArray:(NSArray *)parallaxImageArray
{
    _parallaxImageArray = parallaxImageArray;


    if (parallaxImageArray.count==0 || parallaxImageArray==nil) {
        return;
    }
    
    self.parallaxCarouselArray = [NSMutableArray arrayWithCapacity:parallaxImageArray.count];
    for (int i = 0; i < parallaxImageArray.count; i++) {
        UIImage *image = parallaxImageArray[i];
        if (self.isBlur) {
            image = [UIImage blurImage:image withBlurLevel:0.2];
        }
        [self.parallaxCarouselArray addObject:image];
    }
    
    [self setSubImageViewWithPicArray:self.parallaxCarouselArray withURLType:NO];
    
    [self configContentViews];
}

- (void)setParallaxImageUrlArray:(NSArray *)parallaxImageUrlArray
{
    _parallaxImageUrlArray = parallaxImageUrlArray;
    
    if (parallaxImageUrlArray.count==0 || parallaxImageUrlArray==nil) {
        return;
    }

    
    self.parallaxCarouselArray = [NSMutableArray arrayWithCapacity:parallaxImageUrlArray.count];
    
    for (int i = 0; i < parallaxImageUrlArray.count; i++) {
        UIImage *image = [[UIImage alloc] init];
        [self.parallaxCarouselArray addObject:image];
    }
    
    [self setSubImageViewWithPicArray:self.parallaxImageUrlArray withURLType:YES];
    
    [self configContentViews];
    
}

- (void)setNetworkFailedCount:(NSInteger)networkFailedCount
{
    _networkFailedCount = networkFailedCount;
}

#pragma mark - 根据传递类型加载图片
-(void)setSubImageViewWithPicArray:(NSArray *)picArray withURLType:(BOOL)url
{
    self.totalPageCount = picArray.count;
    NSMutableArray *viewsArray = [@[] mutableCopy];
    if (picArray.count > 2) {
        for (int i = 0; i < picArray.count; ++i) {
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.parallaxScrollView.frame), CGRectGetHeight(self.parallaxScrollView.frame))];
            imageView.contentMode = UIViewContentModeScaleAspectFit;
            if (url) {
                [self imageView:imageView loadImageWithURL:picArray[i] atIndex:i];
            } else {
                UIImage *image = picArray[i];
                imageView.image = image;
            }
            [viewsArray addObject:imageView];
        }
    } else if (picArray.count == 2) {
        for (int i = 0; i < picArray.count * 2 ; ++i) {
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.parallaxScrollView.frame), CGRectGetHeight(self.parallaxScrollView.frame))];
            imageView.contentMode = UIViewContentModeScaleAspectFit;
            if (url) {
                [self imageView:imageView loadImageWithURL:picArray[i%2] atIndex:i];
            }else {
                UIImage *image = picArray[i%2];
                imageView.image = image;
            }
            [viewsArray addObject:imageView];
        }
    } else {
        for (int i = 0; i < picArray.count * 4; ++i) {
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.parallaxScrollView.frame), CGRectGetHeight(self.parallaxScrollView.frame))];
            imageView.contentMode = UIViewContentModeScaleAspectFit;
            if (url) {
                [self imageView:imageView loadImageWithURL:picArray[0] atIndex:i];
            } else {
                UIImage *image = picArray[0];
                imageView.image = image;
            }
            [viewsArray addObject:imageView];
        }
    }
    
    self.subContentViews = viewsArray;
    
    if (self.openTimer) {
        [self.animationTimer resumeTimer];
    }
}


// 加载网络图片
- (void)imageView:(UIImageView *)imageView loadImageWithURL:(NSString *)urlStr atIndex:(NSInteger)index{
    
    NSURL *url = nil;
    
    if ([urlStr isKindOfClass:[NSString class]]) {
        url = [NSURL URLWithString:urlStr];
    } else if ([urlStr isKindOfClass:[NSURL class]]) { // 兼容NSURL
        url = (NSURL *)urlStr;
    }
    
    UIImage *image = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:urlStr];
    if (image) {
        if (self.isBlur) {
            image = [UIImage blurImage:image withBlurLevel:0.2];
        }
        
        [self.parallaxCarouselArray setObject:image atIndexedSubscript:index];
        imageView.image = image;
    } else {
        
        __weak typeof(UIImageView *) weakImageView = imageView;
        [imageView sd_setImageWithURL:url placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            if (image) {
                if (self.isBlur) {
                    image = [UIImage blurImage:image withBlurLevel:0.2];
                }
                [self.parallaxCarouselArray setObject:image atIndexedSubscript:index];
            } else {
                if (self.currentNetWorkFaildCount > self.networkFailedCount) return;
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self imageView:weakImageView loadImageWithURL:urlStr atIndex:index];
                });
                self.currentNetWorkFaildCount++;
                
            }
 
        }];
//        [imageView sd_sd_setImageWithURL:url placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//        }];
    }
}

#pragma mark - 私有函数

- (void)configContentViews
{
    [self.parallaxScrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self setScrollViewContentDataSource];
    
    NSInteger counter = 0;
    for (UIView *contentView in self.contentViews) {
        contentView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(contentViewTapAction:)];
        [contentView addGestureRecognizer:tapGesture];
        CGRect rightRect = contentView.frame;
        rightRect.origin = CGPointMake(CGRectGetWidth(self.parallaxScrollView.frame) * (counter ++), 0);
        contentView.frame = rightRect;
        [self.parallaxScrollView addSubview:contentView];
    }
    [self.parallaxScrollView setContentOffset:CGPointMake(_parallaxScrollView.frame.size.width, 0)];
    
}


/**
 *  设置scrollView的content数据源，即contentViews
 */
- (void)setScrollViewContentDataSource
{
    NSInteger previousPageIndex = [self getValidNextPageIndexWithPageIndex:self.currentPageIndex - 1];
    NSInteger rearPageIndex = [self getValidNextPageIndexWithPageIndex:self.currentPageIndex + 1];
    if (self.contentViews == nil) {
        self.contentViews = [@[] mutableCopy];
    }
    [self.contentViews removeAllObjects];
    if ([self featchContentViewAtIndex:self.currentPageIndex]) {
        [self.contentViews addObject:[self featchContentViewAtIndex:previousPageIndex]];
        [self.contentViews addObject:[self featchContentViewAtIndex:self.currentPageIndex]];
        [self.contentViews addObject:[self featchContentViewAtIndex:rearPageIndex]];
    }
    if (self.totalPageCount > 1) {
        self.parallaxScrollView.scrollEnabled = YES;
    } else {
        self.parallaxScrollView.scrollEnabled = NO;
    }
}

-(UIView *)featchContentViewAtIndex:(NSInteger)index
{
    return self.subContentViews[index];
}


- (NSInteger)getValidNextPageIndexWithPageIndex:(NSInteger)currentPageIndex;
{
    
    if (self.totalPageCount > 2) {
        if(currentPageIndex == -1) {
            return self.totalPageCount - 1;
        } else if (currentPageIndex == self.totalPageCount) {
            return 0;
        } else {
            return currentPageIndex;
        }
    } else if (self.totalPageCount == 2){
        if(currentPageIndex == -1) {
            return (self.totalPageCount * 2 - 1);
        } else if (currentPageIndex == self.totalPageCount * 2) {
            return 0;
        } else {
            return currentPageIndex;
        }
    } else {
        if(currentPageIndex == -1) {
            return (self.totalPageCount * 4 - 1);
        } else if (currentPageIndex == self.totalPageCount * 4) {
            return 0;
        } else {
            return currentPageIndex;
        }
    }
}

#pragma mark -
#pragma mark - UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if (self.totalPageCount > 1) {
        if (self.openTimer) {
            [self.animationTimer pauseTimer];
        }
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (self.totalPageCount > 1) {
        if (self.openTimer) {
            [self.animationTimer resumeTimerAfterTimeInterval:self.animationDuration];
        }
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (self.parallaxCarouselArray.count == 0 || self.parallaxCarouselArray==nil) {
        return;
    }
    CGFloat contentOffsetX = scrollView.contentOffset.x;
    if(contentOffsetX >= (2 * CGRectGetWidth(scrollView.frame))) {
        self.currentPageIndex = [self getValidNextPageIndexWithPageIndex:self.currentPageIndex + 1];
        if (self.totalPageCount > 2) {
            self.pageControl.currentPage = self.currentPageIndex;
        } else if (self.totalPageCount == 2 ) {
            self.pageControl.currentPage = self.currentPageIndex % 2;
        } else {
            self.pageControl.currentPage = 0;
        }
        [self configContentViews];
    }
    if(contentOffsetX <= 0) {
        self.currentPageIndex = [self getValidNextPageIndexWithPageIndex:self.currentPageIndex - 1];
        if (self.totalPageCount > 2) {
            self.pageControl.currentPage = self.currentPageIndex;
        } else if (self.totalPageCount == 2 ) {
            self.pageControl.currentPage = self.currentPageIndex % 2;
        } else {
            self.pageControl.currentPage = 0;
        }
        [self configContentViews];
    }
    if (self.ScrollIndexBlock) {
        self.ScrollIndexBlock(self.pageControl.currentPage);
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [scrollView setContentOffset:CGPointMake(CGRectGetWidth(scrollView.frame), 0) animated:YES];
}

#pragma mark -
#pragma mark - 响应事件

- (void)animationTimerDidFired:(NSTimer *)timer
{
    CGPoint newOffset = CGPointMake(CGRectGetWidth(self.parallaxScrollView.frame) + CGRectGetWidth(self.parallaxScrollView.frame), self.parallaxScrollView.contentOffset.y);
    [self.parallaxScrollView setContentOffset:newOffset animated:YES];
    
}

- (void)contentViewTapAction:(UITapGestureRecognizer *)tap
{
    if (self.TapActionBlock) {
        NSInteger currentSelectIndex;
        if (self.modelArray.count > 2) {
            currentSelectIndex = self.currentPageIndex;
        } else if (self.modelArray.count == 2) {
            currentSelectIndex = self.currentPageIndex%2;
        } else {
            currentSelectIndex = 0;
        }
        self.TapActionBlock(currentSelectIndex);
    }
}

- (void)resumeTimer
{
    if (self.openTimer) {
        if (self.totalPageCount > 1) {
            [self.animationTimer resumeTimerAfterTimeInterval:self.animationDuration];
        }
    }
}


- (void)pauseTimer
{
    if (self.openTimer)
    {
        [self.animationTimer pauseTimer];
        CGPoint newOffset = CGPointMake(CGRectGetWidth(self.parallaxScrollView.frame), self.parallaxScrollView.contentOffset.y);
        [self.parallaxScrollView setContentOffset:newOffset animated:YES];
    }
}

- (void)setIsBlur:(BOOL)isBlur{
    _isBlur = isBlur;
}

#pragma mark - 图片拉伸问题
- (void)parallaxHeaderViewStretchingWithOffset:(CGFloat)offset
{
    if (!self.enbleStretch) {
        return;
    }
    CGFloat whpercent = self.orginWidth/self.orginHeight;
    CGFloat height = self.orginHeight - offset;
    CGFloat width = self.orginWidth - offset * whpercent;
    if (offset <= 0) {
        if (self.openTimer) {
            [self.animationTimer pauseTimer];
        }
        self.parallaxScrollView.hidden = YES;
        self.stretchImageView.hidden = NO;
        self.stretchImageView.image = self.parallaxCarouselArray[self.currentPageIndex];
        self.stretchImageView.frame = CGRectMake(offset, offset, width, height);

    } else {
        if (self.openTimer) {
            [self.animationTimer resumeTimerAfterTimeInterval:2];
        }
        self.parallaxScrollView.hidden = NO;
        self.stretchImageView.hidden = YES;
        self.stretchImageView.frame = CGRectZero;
    }
}

@end

//
//  HRPhotoBrowser.m
//  ScaleImageView
//
//  Created by sohu on 13-3-26.
//  Copyright (c) 2013年 Qu. All rights reserved.
//


#import "HRPhotoBrowser.h"
#import "HRImageScaleView.h"
#import "HRPhotoBrowserConfig.h"
#import "SMPageControl.h"
#import "HcdActionSheet.h"

@interface HRPhotoBrowser()<ImageScaleViewDelegate>

@end

@implementation HRPhotoBrowser 
{
    UIScrollView *_scrollView;
    BOOL _hasShowedFistView;
    UIActivityIndicatorView *_indicatorView;
    BOOL _willDisappear;
    
    SMPageControl * _pageControll;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = SDPhotoBrowserBackgrounColor;
    }
    return self;
}


- (void)didMoveToSuperview
{
    [self setupScrollView];
    
    [self setupToolbars];
}

- (void)dealloc
{
    [[UIApplication sharedApplication].keyWindow removeObserver:self forKeyPath:@"frame"];
}

- (void)setupToolbars
{
    [self addPageControll];
}

- (void)addPageControll
{
    _pageControll = [[SMPageControl alloc] initWithFrame:CGRectMake(110, _scrollView.bounds.size.height - 44, 100, 40)];
    _pageControll.backgroundColor = [UIColor clearColor];
    [_pageControll setIndicatorMargin:2];
    [_pageControll setIndicatorDiameter:5];
    [_pageControll setIndicatorMargin:2];
    [_pageControll setIndicatorDiameter:5];
    [_pageControll setPageIndicatorImage:[UIImage imageNamed:@"xiaoyuanquan"]];
    [_pageControll setCurrentPageIndicatorImage:[UIImage imageNamed:@"xiaoyuanquan-cur"]];
    _pageControll.numberOfPages = self.imageCount;
    _pageControll.hidesForSinglePage = YES;
    [_pageControll setUserInteractionEnabled:NO];
    [self addSubview:_pageControll];
}

- (void)longpressToSaveImamge:(UILongPressGestureRecognizer *)gesture
{
    for (UIView * view in [UIApplication sharedApplication].keyWindow.subviews) {
        if ([view isKindOfClass:[HcdActionSheet class]]) {
            return;
        }
    }
    
    HcdActionSheet *sheet = [[HcdActionSheet alloc] initWithCancelStr:@"取消"
                                                    otherButtonTitles:@[@"保存图片"]
                                                          attachTitle:nil];
    
    sheet.selectButtonAtIndex = ^(NSInteger index) {
        if (index == 1) {
            [self saveImage];
        }
    };
    [[UIApplication sharedApplication].keyWindow addSubview:sheet];
    [sheet showHcdActionSheet];
}

- (void)saveImage
{
    
    int index = _scrollView.contentOffset.x / _scrollView.bounds.size.width;
    HRImageScaleView *currentImageView = _scrollView.subviews[index];
    
    if (!currentImageView.imageView.image) {
        return;
    }

    
    UIImageWriteToSavedPhotosAlbum(currentImageView.imageView.image, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
    
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] init];
    indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    indicator.center = self.center;
    _indicatorView = indicator;
    [[UIApplication sharedApplication].keyWindow addSubview:indicator];
    [indicator startAnimating];
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo;
{
    [_indicatorView removeFromSuperview];
    if (error) {
        [self showTotasViewWithMes:@"保存失败"];
    }   else {
        [self showTotasViewWithMes:@"保存成功"];
    }
}

- (void)showTotasViewWithMes:(NSString *)message
{
    ToastAlertView * alertView = [[ToastAlertView alloc] initWithTitle:message controller:self];
    [alertView show];
}

- (void)setupScrollView
{
    _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    _scrollView.delegate = self;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.pagingEnabled = YES;
    [self addSubview:_scrollView];
    _pageControll.numberOfPages = self.imageCount;
    for (int i = 0; i < self.imageCount; i++) {
        HRImageScaleView *imageView = [[HRImageScaleView alloc] initWithFrame:_scrollView.bounds];
        imageView.tag = i;
        imageView.Adelegate = self;
        [_scrollView addSubview:imageView];
    }
    
    [self setupImageOfImageViewForIndex:self.currentImageIndex];
    
}

// 加载图片
- (void)setupImageOfImageViewForIndex:(NSInteger)index
{
    HRImageScaleView *imageView = _scrollView.subviews[index];
    self.currentImageIndex = index;
    if (imageView.hasLoadedImage) return;
    
    if ([_delegate respondsToSelector:@selector(photoBrowser:loadingImage:withIndexPath:)]) {
        if ([_delegate photoBrowser:self loadingImage:imageView withIndexPath:index]) {
            imageView.hasLoadedImage = YES;
        }
    }
}

- (void)imageViewScale:(HRImageScaleView *)imageScale clickCurImage:(UIImageView *)imageview
{
    _scrollView.hidden = YES;
    _willDisappear = YES;
    
    HRImageScaleView *currentImageView = (HRImageScaleView *)imageScale;
    NSInteger currentIndex = currentImageView.tag;
    
    UIView *sourceView = self.sourceImagesContainerView.subviews[currentIndex];
    CGRect targetTemp = [self.sourceImagesContainerView convertRect:sourceView.frame toView:self];
    
    UIImageView *tempView = [[UIImageView alloc] init];
    tempView.contentMode = sourceView.contentMode;
    tempView.clipsToBounds = YES;
    tempView.image = currentImageView.imageView.image;
    CGFloat h = (self.bounds.size.width / currentImageView.imageView.image.size.width) * currentImageView.imageView.image.size.height;
    
    if (!currentImageView.imageView.image) {
        h = self.bounds.size.height;
    }
    
    tempView.bounds = CGRectMake(0, 0, self.bounds.size.width, h);
    tempView.center = self.center;
    
    [self addSubview:tempView];
    
    
    [UIView animateWithDuration:SDPhotoBrowserHideImageAnimationDuration animations:^{
        tempView.frame = targetTemp;
        self.backgroundColor = [UIColor clearColor];
        _pageControll.alpha = 0.1;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];

}

- (void)imageViewScale:(HRImageScaleView *)imageScale longPressCurImage:(UIImageView *)imageview
{
    [self longpressToSaveImamge:nil];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGRect rect = self.bounds;
    rect.size.width += SDPhotoBrowserImageViewMargin * 2;
    
    _scrollView.bounds = rect;
    _scrollView.center = self.center;
    
    CGFloat y = 0;
    CGFloat w = _scrollView.frame.size.width - SDPhotoBrowserImageViewMargin * 2;
    CGFloat h = _scrollView.frame.size.height;
    
    
    
    [_scrollView.subviews enumerateObjectsUsingBlock:^(HRImageScaleView *obj, NSUInteger idx, BOOL *stop) {
        CGFloat x = SDPhotoBrowserImageViewMargin + idx * (SDPhotoBrowserImageViewMargin * 2 + w);
        obj.frame = CGRectMake(x, y, w, h);
    }];
    
    _scrollView.contentSize = CGSizeMake(_scrollView.subviews.count * _scrollView.frame.size.width, 0);
    _scrollView.contentOffset = CGPointMake(self.currentImageIndex * _scrollView.frame.size.width, 0);
    
    
    if (!_hasShowedFistView) {
        [self showFirstImage];
    }
    
//    _indexLabel.center = CGPointMake(self.bounds.size.width * 0.5, 35);
//    _saveButton.frame = CGRectMake(30, self.bounds.size.height - 70, 50, 25);
    _pageControll.frame = CGRectMake(_scrollView.width /2.5 - 50.f, _scrollView.bounds.size.height - 44, 100, 40);
    _pageControll.centerX = _scrollView.width/2.f;
}

- (void)show
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    self.frame = window.bounds;
    [window addObserver:self forKeyPath:@"frame" options:0 context:nil];
    [window addSubview:self];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(UIView *)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"frame"]) {
        self.frame = object.bounds;
        HRImageScaleView *currentImageView = _scrollView.subviews[_currentImageIndex];
        if ([currentImageView isKindOfClass:[HRImageScaleView class]]) {
            [currentImageView clear];
        }
    }
}

- (void)showFirstImage
{
    UIView *sourceView = self.sourceImagesContainerView.subviews[self.currentImageIndex];
    CGRect rect = [self.sourceImagesContainerView convertRect:sourceView.frame toView:self];
    
    
    HRImageScaleView *currentImageView = _scrollView.subviews[_currentImageIndex];
    UIImageView *tempView = [[UIImageView alloc] init];
    tempView.image = currentImageView.imageView.image;
    [self addSubview:tempView];
    
    CGRect targetTemp = [[(HRImageScaleView *)_scrollView.subviews[self.currentImageIndex] imageView] frame];
    
    tempView.frame = rect;
    tempView.contentMode = [_scrollView.subviews[self.currentImageIndex] contentMode];
    _scrollView.hidden = YES;
    
    
    [UIView animateWithDuration:SDPhotoBrowserShowImageAnimationDuration animations:^{
        tempView.center = self.center;
        tempView.bounds = (CGRect){CGPointZero, targetTemp.size};
    } completion:^(BOOL finished) {
        _hasShowedFistView = YES;
        [tempView removeFromSuperview];
        _scrollView.hidden = NO;
    }];
}

#pragma mark - scrollview代理方法

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    int index = (scrollView.contentOffset.x + _scrollView.bounds.size.width * 0.5) / _scrollView.bounds.size.width;
    
    // 有过缩放的图片在拖动一定距离后清除缩放
    CGFloat margin = 150;
    CGFloat x = scrollView.contentOffset.x;
    if ((x - index * self.bounds.size.width) > margin || (x - index * self.bounds.size.width) < - margin) {
        HRImageScaleView *imageView = _scrollView.subviews[index];
        if (imageView.isScaled) {
            [UIView animateWithDuration:0.5 animations:^{
                imageView.transform = CGAffineTransformIdentity;
            } completion:^(BOOL finished) {
                [imageView eliminateScale];
            }];
        }
    }
    
    
    if (!_willDisappear) {
//        _indexLabel.text = [NSString stringWithFormat:@"%d/%ld", index + 1, (long)self.imageCount];
        _pageControll.currentPage = index + 1;
    }
    [self setupImageOfImageViewForIndex:index];
}



@end

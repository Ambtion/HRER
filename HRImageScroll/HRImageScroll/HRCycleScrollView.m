//
//  HRCycleScrollView.m
//  HRImageScroll
//
//  Created by quke on 16/5/27.
//  Copyright © 2016年 linjunhou. All rights reserved.
//

#import "HRCycleScrollView.h"


@interface HRCycleScrollView()<UIScrollViewDelegate,ImageScaleViewDelegate>
{
    NSInteger _totalPageNumber;
    NSInteger _curIndexPage;
    NSMutableArray * _viewContainers;
}

@property(nonatomic,strong)UIScrollView * scrollView;

@end

@implementation HRCycleScrollView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        // Initialization code
        _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        _scrollView.backgroundColor = [UIColor blackColor];
        _scrollView.delegate = self;
        _scrollView.contentSize = CGSizeMake(self.bounds.size.width * 3, 0);
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.contentOffset = CGPointMake(self.bounds.size.width, 0);
        _scrollView.pagingEnabled = YES;
        [self addSubview:_scrollView];
        
        
        _totalPageNumber = 0;
        _curIndexPage = 0;
        
        _viewContainers = [NSMutableArray arrayWithCapacity:3];
        
        
    }
    
    return self;
}


- (void)reloadData
{
    
    
    if ([_dataSource respondsToSelector:@selector(hrCycleScrollViewNumberofPage:)]) {
        _totalPageNumber = [_dataSource hrCycleScrollViewNumberofPage:self];
    }
    if (_totalPageNumber == 0) {
        return;
    }
    
    [self refreshViewContainer];

    [self refreshScrollViewContent];

}


- (void)refreshScrollViewContent
{
    
    for (int i = 0; i < [_viewContainers count]; i++) {
        UIView *v = [_viewContainers objectAtIndex:i];
        v.frame = CGRectMake(v.frame.size.width * i, 0, v.frame.size.width, v.frame.size.height);
        [_scrollView addSubview:v];
    }
    
    _scrollView.contentSize = CGSizeMake(self.bounds.size.width * [_viewContainers count],0);
    
    if ([_viewContainers count] == 1) {
        [_scrollView setContentOffset:CGPointMake(0, 0)];
    }else{
        [_scrollView setContentOffset:CGPointMake(_scrollView.frame.size.width, 0)];
    }
}

- (void)refreshViewContainer
{
    
    NSArray *subViews = _viewContainers;
    if([subViews count] != 0) {
        [subViews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    }
    
    [_viewContainers removeAllObjects];
    
    if ([_dataSource respondsToSelector: @selector(hrCycleScrollView:pageAtIndex:)] == NO) {
        return;
    }
    
    NSInteger pre = [self validPageValue:_curIndexPage -1];
    NSInteger last = [self validPageValue:_curIndexPage + 1];
    
    if (_totalPageNumber == 1) {
        
        HRImageScaleView *view = [self viewAtIndex:_curIndexPage];
        if (view)
            [_viewContainers addObject:view];
        
    } else {
        
        
        HRImageScaleView *view = [self viewAtIndex:pre];
        if(view)
            [_viewContainers addObject:view];
        
        view = [self viewAtIndex:_curIndexPage];
        if (view) {
            [_viewContainers addObject:view];
        }
        
        view = [self viewAtIndex:last];
        if (view) {
            [_viewContainers addObject:view];
        }
    }
}

- (HRImageScaleView *)viewAtIndex:(NSInteger)index
{
    if ([_dataSource respondsToSelector:@selector(hrCycleScrollView:pageAtIndex:)]) {
        HRImageScaleView *v = [_dataSource hrCycleScrollView: self pageAtIndex:_curIndexPage];
        if ([_dataSource respondsToSelector:@selector(hrCycleScrollView:frameForImageViewInIndex:)]) {
//            CGRect imageFrame = [_dataSource hrCycleScrollView:self frameForImageViewInIndex:_curIndexPage];
//            v.imageView.frame = imageFrame;
        }
        v.tag = index;
        v.Adelegate = self;
        return v;
    }
    return nil;
}


- (NSInteger)validPageValue:(NSInteger)value {
    
    if(value == -1) value = _totalPageNumber - 1;
    if(value == _totalPageNumber) value = 0;
    return value;
    
}

- (void)scrollViewDidScroll:(UIScrollView *)aScrollView
{
    
    NSInteger x = aScrollView.contentOffset.x;
    //往下翻一张
    if(x >= (2 * self.frame.size.width)) {
        
        _curIndexPage = [self validPageValue:_curIndexPage + 1];
        
        if ([_delegate respondsToSelector:@selector(hrcycleScrollView:didScrollToPage:)]) {
            [_delegate hrcycleScrollView:self didScrollToPage:_curIndexPage];
        }
        
        [self reloadData];
    }
    
    //往上翻
    if(x <= 0) {
        _curIndexPage = [self validPageValue:_curIndexPage - 1];
        
        if ([_delegate respondsToSelector:@selector(hrcycleScrollView:didScrollToPage:)]) {
            [_delegate hrcycleScrollView:self didScrollToPage:_curIndexPage];
        }
        
        [self reloadData];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)aScrollView
{
    [_scrollView setContentOffset:CGPointMake(_scrollView.frame.size.width, 0) animated:YES];
}

- (void)imageViewScale:(HRImageScaleView *)imageScale clickCurImage:(UIImageView *)imageview
{
    if ([_delegate respondsToSelector:@selector(hrcycleScrollView:didSeletPage:)]) {
        [_delegate hrcycleScrollView:self didSeletPage:imageScale.tag];
    }
}

@end

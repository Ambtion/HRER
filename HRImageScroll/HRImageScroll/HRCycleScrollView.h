//
//  HRCycleScrollView.h
//  HRImageScroll
//
//  Created by quke on 16/5/27.
//  Copyright © 2016年 linjunhou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HRImageScaleView.h"

@class HRCycleScrollView;

@protocol HRCycleScrollViewDataSource <NSObject>

- (NSInteger)hrCycleScrollViewNumberofPage:(HRCycleScrollView *)scrollView;
//- (CGRect)hrCycleScrollView:(HRCycleScrollView *)scrollView frameForImageViewInIndex:(NSInteger)index;
- (HRImageScaleView *)hrCycleScrollView:(HRCycleScrollView *)cycleScrollView pageAtIndex:(NSInteger)index;

@end

@protocol HRCycleScrollViewDelegate <NSObject>
@optional
- (void)hrcycleScrollView:(HRCycleScrollView *)cycleScrollView didScrollToPage:(NSInteger)indexPage;
- (void)hrcycleScrollView:(HRCycleScrollView *)cycleScrollView didSeletPage:(NSInteger)indexPage;
@end

@interface HRCycleScrollView : UIView

@property(nonatomic,weak)id<HRCycleScrollViewDataSource>dataSource;
@property(nonatomic,weak)id<HRCycleScrollViewDelegate>delegate;


- (void)reloadData;

@end

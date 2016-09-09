//
//  HRUserHomeCaterInfoView.h
//  HRER
//
//  Created by quke on 16/7/19.
//  Copyright © 2016年 linjunhou. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HRUserHomeMapCaterInfoView;

@protocol HRUserHomeMapCaterInfoMapViewDelegate <NSObject>

- (void)userHomeCaterInfoViewDidSeletedIndex:(NSInteger)index;
- (void)userHomeCaterInfoViewDidCancelSeleted:(HRUserHomeMapCaterInfoView *)view;

- (void)userHomeCaterSwithButtonDidClick:(HRUserHomeMapCaterInfoView *)view;
@end

@interface HRUserHomeMapCaterInfoView : UIView

@property(nonatomic,weak)id<HRUserHomeMapCaterInfoMapViewDelegate>delegate;

+ (CGFloat)heigthForView;

- (void)setDataSource:(HRUserHomeInfo *)dataSource;

- (void)setSeletedAtIndex:(NSInteger)index;

- (NSInteger)seletedIndex;

@end

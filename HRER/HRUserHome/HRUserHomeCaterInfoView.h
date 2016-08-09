//
//  HRUserHomeCaterInfoView.h
//  HRER
//
//  Created by quke on 16/7/19.
//  Copyright © 2016年 linjunhou. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HRUserHomeCaterInfoView;

@protocol HRUserHomeCaterInfoViewDelegate <NSObject>

- (void)userHomeCaterInfoViewDidSeletedIndex:(NSInteger)index;
- (void)userHomeCaterSwithButtonDidClick:(HRUserHomeCaterInfoView *)view;

@end

@interface HRUserHomeCaterInfoView : UIView

@property(nonatomic,weak)id<HRUserHomeCaterInfoViewDelegate>delegate;

+ (CGFloat)heigthForView;

- (void)setDataSource:(HRUserHomeInfo *)dataSource;

- (void)setSeletedAtIndex:(NSInteger)index;

- (NSInteger)seletedIndex;

@end

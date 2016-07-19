//
//  HRUserHomeHeadView.h
//  HRER
//
//  Created by kequ on 16/7/18.
//  Copyright © 2016年 linjunhou. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HRUserHomeHeadView;
@protocol HRUserHomeHeadViewDelegate <NSObject>

- (void)userHomeHeadView:(HRUserHomeHeadView *)headView DidClickRightButton:(UIButton *)button;
- (void)userHomeHeadView:(HRUserHomeHeadView *)headView DidClickCateAtIndex:(NSInteger)index;
- (void)userHomeHeadViewDidClickSwitchButton:(HRUserHomeHeadView *)headView;

@end

@interface HRUserHomeHeadView : UIView

@property(nonatomic,weak)id<HRUserHomeHeadViewDelegate>delegate;

+ (CGFloat)heightForView;

- (void)setDataSource:(id)dataSource;

- (void)setSeltedAtIndex:(NSInteger)index;

- (NSInteger)seltedIndex;

@end

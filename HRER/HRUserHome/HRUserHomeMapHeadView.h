//
//  HRUserHomeHeadView.h
//  HRER
//
//  Created by kequ on 16/7/18.
//  Copyright © 2016年 linjunhou. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HRUserHomeMapHeadView;
@protocol HRUserHomeMapHeadViewDelegate <NSObject>

- (void)userHomeHeadView:(HRUserHomeMapHeadView *)headView DidClickRightButton:(UIButton *)button;
- (void)userHomeHeadViewDidCancelSeletedButton:(HRUserHomeMapHeadView *)headView;
- (void)userHomeHeadView:(HRUserHomeMapHeadView *)headView DidClickCateAtIndex:(NSInteger)index;
- (void)userHomeHeadViewDidClickSwitchButton:(HRUserHomeMapHeadView *)headView;
- (void)userHomeHeadViewDidClickDetail:(HRUserHomeMapHeadView *)headView;

@end

@interface HRUserHomeMapHeadView : UIView

@property(nonatomic,strong)HRUserHomeInfo * dataSource;
@property(nonatomic,weak)id<HRUserHomeMapHeadViewDelegate> delegate;

+ (CGFloat)heightForView;

- (void)setSeltedAtIndex:(NSInteger)index;

- (NSInteger)seltedIndex;

@end

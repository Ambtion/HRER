//
//  HRUserHomeInfoCardView.h
//  HRER
//
//  Created by quke on 16/7/19.
//  Copyright © 2016年 linjunhou. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HRUserHomeMapInfoCardView;

@protocol HRUserHomeMapInfoCardViewDelegate <NSObject>

- (void)userHomeInfoCardViewDidClickRightButton:(UIButton *)button;
- (void)userHomeInfoCardViewDidClickDetail:(HRUserHomeMapInfoCardView *)view;

@end

@interface HRUserHomeMapInfoCardView : UIImageView

@property(nonatomic,strong)HRUserHomeInfo * dataSource;
@property(nonatomic,weak)id<HRUserHomeMapInfoCardViewDelegate>delegate;


+ (CGFloat)heightForView;

@end

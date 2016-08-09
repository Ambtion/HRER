//
//  HRUserHomeInfoCardView.h
//  HRER
//
//  Created by quke on 16/7/19.
//  Copyright © 2016年 linjunhou. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HRUserHomeInfoCardView;

@protocol HRUserHomeInfoCardViewDelegate <NSObject>

- (void)userHomeInfoCardViewDidClickRightButton:(UIButton *)button;
- (void)userHomeInfoCardViewDidClickDetail:(HRUserHomeInfoCardView *)view;

@end

@interface HRUserHomeInfoCardView : UIImageView

@property(nonatomic,strong)HRUserHomeInfo * dataSource;
@property(nonatomic,weak)id<HRUserHomeInfoCardViewDelegate>delegate;


+ (CGFloat)heightForView;

@end

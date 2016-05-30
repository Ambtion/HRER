//
//  HRRegisterView.h
//  HRER
//
//  Created by quke on 16/5/30.
//  Copyright © 2016年 linjunhou. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HRRegisterView;

@protocol HRRegisterViewDelegate <NSObject>
- (void)hrRegisterViewDidClickRegisterButton:(HRRegisterView *)registerView;
- (void)hrRegisterViewDidClickDealButton:(HRRegisterView *)registerView;

@end

@interface HRRegisterView : UIView

@end

//
//  HRPoiUserInfoBottomView.h
//  HRER
//
//  Created by kequ on 16/7/14.
//  Copyright © 2016年 linjunhou. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HRPoiUserInfoBottomView;
@protocol HRPoiUserInfoBottomViewDelegate <NSObject>
- (void)poiUserInfoBottomViewDidClickWantTogo:(HRPoiUserInfoBottomView *)vew;
- (void)poiUserInfoBottomViewDidClickRecomend:(HRPoiUserInfoBottomView *)vew;
@end

@interface HRPoiUserInfoBottomView : UIView

@property(nonatomic,weak)id<HRPoiUserInfoBottomViewDelegate>delegate;

+ (CGFloat)heightForView;

- (void)setData:(id)data;


@end

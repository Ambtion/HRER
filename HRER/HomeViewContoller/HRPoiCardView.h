//
//  HRPoiCardView.h
//  HRER
//
//  Created by quke on 16/6/16.
//  Copyright © 2016年 linjunhou. All rights reserved.
//



#import <UIKit/UIKit.h>
#import "HereDataModel.h"

@class HRPoiCardView;
@protocol HRPoiCardViewdelegate <NSObject>
@optional
- (void)poiView:(HRPoiCardView *)poiSetsview DidClickFrameImage:(UIImageView *)imageView;
- (void)poiViewDidClick:(HRPoiCardView *)poiSetsview;
- (void)poiViewDidClickUserPortrait:(HRPoiCardView *)poiSetsview;
@end

@interface HRPoiCardView : UIView

@property(nonatomic,weak)id<HRPoiCardViewdelegate>delegate;
@property(nonatomic,weak)UIViewController * controller;
@property(nonatomic,strong)UILabel * locLabel;
@property(nonatomic,strong)UIImageView * locIconView;
@property(nonatomic,strong)UIView * maskView;

+ (CGFloat)heightForCardView;

- (void)setDataSource:(HRPOIInfo *)data;

@end

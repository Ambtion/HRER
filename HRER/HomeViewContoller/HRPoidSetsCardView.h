//
//  HRPoidSetsCardView.h
//  HRER
//
//  Created by quke on 16/6/16.
//  Copyright © 2016年 linjunhou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HereDataModel.h"

@class HRPoidSetsCardView;
@protocol HRPoidSetsCardViewdelegate <NSObject>
- (void)poiSetsView:(HRPoidSetsCardView *)poiSetsview DidClickFrameImage:(UIImageView *)imageView;
@optional
- (void)poiSetsViewDidClick:(HRPoidSetsCardView *)poiSetsview;
- (void)poiSetsViewDidClickPor:(HRPoidSetsCardView *)poiSetsview;
@end

@interface HRPoidSetsCardView : UIView

@property(nonatomic,weak)id<HRPoidSetsCardViewdelegate>delegate;

+ (CGFloat)heightForCardView;

- (void)setData:(HRPOISetInfo *)data;

@end

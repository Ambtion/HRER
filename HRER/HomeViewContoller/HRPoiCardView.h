//
//  HRPoiCardView.h
//  HRER
//
//  Created by quke on 16/6/16.
//  Copyright © 2016年 linjunhou. All rights reserved.
//



#import <UIKit/UIKit.h>


@class HRPoiCardView;
@protocol HRPoiCardViewdelegate <NSObject>
- (void)poiView:(HRPoiCardView *)poiSetsview DidClickFrameImage:(UIImageView *)imageView;
@optional
- (void)poiViewDidClick:(HRPoiCardView *)poiSetsview;
@end

@interface HRPoiCardView : UIView

@property(nonatomic,weak)id<HRPoiCardViewdelegate>delegate;

+ (CGFloat)heightForCardView;

@end

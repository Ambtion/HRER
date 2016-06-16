//
//  HRPoiSetsMapView.h
//  HRER
//
//  Created by kequ on 16/6/15.
//  Copyright © 2016年 linjunhou. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HRPoiSetsMapView;
@protocol HRPoiSetsMapViewDelegate <NSObject>
- (void)poiSetsMapView:(HRPoiSetsMapView *)view didClickCarViewAtIndex:(NSInteger)index;
@end

@interface HRPoiSetsMapView : UIView

@property(nonatomic,weak)id<HRPoiSetsMapViewDelegate>delegate;

- (void)refreshUIWithData:(NSArray *)array;
- (void)setSeletedIndexCar:(NSInteger)index;

@end

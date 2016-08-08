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
- (void)poiSetsMapViewdidClickBackButton:(HRPoiSetsMapView *)view;
- (void)poiSetsMapViewdidClickListButton:(HRPoiSetsMapView *)view;
- (void)poiSetsMapViewdidClickPortView:(HRPoiSetsMapView *)view withDataSource:(HRPOIInfo *)poiInfo;
- (void)poiSetsMapViewdidClickDetailView:(HRPoiSetsMapView *)view withDataSource:(HRPOIInfo *)poiInfo;

@end

@interface HRPoiSetsMapView : UIView

@property(nonatomic,weak)id<HRPoiSetsMapViewDelegate>delegate;

- (void)refreshUIWithData:(NSArray *)array;
- (void)setSeletedIndexCar:(NSInteger)index;
- (HRPOIInfo *)seletedPoiInfo;

@end

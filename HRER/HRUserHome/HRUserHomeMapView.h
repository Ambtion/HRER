//
//  HRUserHomeMapView.h
//  HRER
//
//  Created by quke on 16/7/19.
//  Copyright © 2016年 linjunhou. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HRUserHomeMapView;
@protocol HRUserHomeMapViewDelegate <NSObject>

- (void)userHomeMapViewDidClickSwitchButton:(HRUserHomeMapView *)mapView;
- (void)userHomeMapViewDidClickRightButton:(HRUserHomeMapView *)mapView;
- (void)userHomeMapView:(HRUserHomeMapView *)mapView DidCategoryAtIndex:(NSInteger)index;
- (void)userHomeMapView:(HRUserHomeMapView *)mapView DidClickCellWithSource:(id)dataSource;
@end

@interface HRUserHomeMapView : UIView

@property(nonatomic,weak)id<HRUserHomeMapViewDelegate>delegate;

- (void)refreshUIWithData:(NSArray *)array;
- (void)setSeletedIndexCarD:(NSInteger)index;

@end

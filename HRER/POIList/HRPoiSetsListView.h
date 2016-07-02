//
//  HRPoiSetsListView.h
//  HRER
//
//  Created by kequ on 16/6/15.
//  Copyright © 2016年 linjunhou. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HRPoiSetsListView;
@protocol HRPoiSetsListViewDelegate <NSObject>

- (void)poiSetsListViewdidClickBackButton:(HRPoiSetsListView *)view;
- (void)poiSetsListViewdidClickListButton:(HRPoiSetsListView *)view;

@end

@interface HRPoiSetsListView : UIView

@property(nonatomic,weak)id<HRPoiSetsListViewDelegate> delegate;

- (void)refreshUIWithData:(NSArray *)array;

@end

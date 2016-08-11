//
//  HRUserHomeListView.h
//  HRER
//
//  Created by quke on 16/7/19.
//  Copyright © 2016年 linjunhou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HRUserHomeController.h"
#import "RefreshTableView.h"

@class HRUserHomeListView;
@protocol HRUserHomeListViewDelegate <NSObject>

- (void)userHomeListViewDidClickSwitchButton:(HRUserHomeListView *)listView;
- (void)userHomeListViewDidClickRightButton:(HRUserHomeListView *)listView;
- (void)userHomeListViewDidDetailButton:(HRUserHomeListView *)listView;

- (void)userHomeListViewDidCalcelSeleted:(HRUserHomeListView *)listView;
- (void)userHomeListView:(HRUserHomeListView *)listView DidCategoryAtIndex:(NSInteger)index;
- (void)userHomeListView:(HRUserHomeListView *)listView DidClickCellWithSource:(HRPOIInfo *)dataSource;
- (void)userHomeListView:(HRUserHomeListView *)listView DidNeedRefreshData:(RefreshTableView *)refreshTableView;
@end

@interface HRUserHomeListView : UIView

@property(nonatomic,weak)id<HRUserHomeListViewDelegate>delegate;
@property(nonatomic,strong)NSArray * dataSource;

- (void)setHeadUserInfo:(HRUserHomeInfo *)homeInfo dataSource:(NSArray *)dataSource;

- (void)setSeltedAtIndex:(NSInteger)index;

@end

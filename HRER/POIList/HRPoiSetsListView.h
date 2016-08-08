//
//  HRPoiSetsListView.h
//  HRER
//
//  Created by kequ on 16/6/15.
//  Copyright © 2016年 linjunhou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RefreshTableView.h"

@class HRPoiSetsListView;
@protocol HRPoiSetsListViewDelegate <NSObject>

- (void)poiSetsListViewdidClickBackButton:(HRPoiSetsListView *)view;
- (void)poiSetsListViewdidClickListButton:(HRPoiSetsListView *)view;
- (void)poiSetsListViewdidClickPortView:(HRPoiSetsListView *)view withDataSource:(HRPOIInfo *)poiInfo;
- (void)poiSetsListViewdidClickDetailView:(HRPoiSetsListView *)view withDataSource:(HRPOIInfo *)poiInfo;
@end

@interface HRPoiSetsListView : UIView

@property(nonatomic,weak)id<HRPoiSetsListViewDelegate> delegate;

@property(nonatomic,strong)RefreshTableView * tableView;
@property(nonatomic,strong)NSArray * dataSource;
@property(nonatomic,strong)UILabel * titelLabel;

- (instancetype)initWithFrame:(CGRect)frame
              PoiSetCreteType:(KPoiSetsCreteType)creteType
                      creteId:(NSString *)userID
                creteUserName:(NSString *)creteUserName
                     category:(NSInteger)categoryType;
- (void)quaryData;

@end

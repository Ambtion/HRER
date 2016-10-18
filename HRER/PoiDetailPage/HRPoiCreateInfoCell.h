//
//  HRPoiCreateInfoCell.h
//  HRER
//
//  Created by kequ on 16/7/13.
//  Copyright © 2016年 linjunhou. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "HRPoiUserInfo.h"

@class HRPoiCreateInfoCell;
@protocol HRPoiCreateInfoCellDelegate <NSObject>

- (void)poiUserInfoCell:(HRPoiCreateInfoCell *)cell DidClickWantTogo:(UIButton *)button;
- (void)poiUserInfoCellDidClickRecomend:(HRPoiCreateInfoCell *)cell;

@end


@interface HRPoiCreateInfoCell : UITableViewCell

@property(nonatomic,strong)HRPoiUserInfo * userInfo;

@property(nonatomic,weak)id<HRPoiCreateInfoCellDelegate>delegate;

+ (CGFloat)cellHeithForData:(HRPOIInfo *)data;

- (void)setDataSource:(HRPOIInfo *)dataSource;

@end

//
//  HRPoiCreateInfoCell.h
//  HRER
//
//  Created by kequ on 16/7/13.
//  Copyright © 2016年 linjunhou. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HRPoiCreateInfoCell;
@protocol HRPoiCreateInfoCellDelegate <NSObject>

- (void)poiUserInfoCellDidClickWantTogo:(HRPoiCreateInfoCell *)cell;
- (void)poiUserInfoCellDidClickRecomend:(HRPoiCreateInfoCell *)cell;

@end


@interface HRPoiCreateInfoCell : UITableViewCell

@property(nonatomic,weak)id<HRPoiCreateInfoCellDelegate>delegate;

+ (CGFloat)cellHeithForData:(id)data;

- (void)setDataSource:(id)dataSource;

@end

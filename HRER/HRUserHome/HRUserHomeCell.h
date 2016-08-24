//
//  HRUserHomeCell.h
//  HRER
//
//  Created by kequ on 16/7/19.
//  Copyright © 2016年 linjunhou. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SWTableViewCell.h"


typedef NS_ENUM(NSUInteger,KCellStation) {
    KCellstationTop,
    KCellstationMiddle,
    KCellstationBottom,
    KCellstationFull
};

@class HRUserHomeCell;
@protocol HRUserHomeCellDelegate <NSObject>
@optional
- (void)userHomeCellDidClickDetalInfo:(HRUserHomeCell *)cell;

@end

@interface HRUserHomeCell : SWTableViewCell

@property(nonatomic,strong)HRPOIInfo * dataSource;
@property(nonatomic,weak)id<HRUserHomeCellDelegate>adelegate;

+ (CGFloat)heightForView;

- (void)setCellStation:(KCellStation)station;

@end

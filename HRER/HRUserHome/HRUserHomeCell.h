//
//  HRUserHomeCell.h
//  HRER
//
//  Created by kequ on 16/7/19.
//  Copyright © 2016年 linjunhou. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger,KCellStation) {
    KCellstationTop,
    KCellstationMiddle,
    KCellstationBottom,
    KCellstationFull
};

@class HRUserHomeCell;
@protocol HRUserHomeCellDelegate <NSObject>

- (void)userHomeCellDidClickDetalInfo:(HRUserHomeCell *)cell;

@end

@interface HRUserHomeCell : UITableViewCell

@property(nonatomic,strong)id datsSource;
@property(nonatomic,weak)id<HRUserHomeCellDelegate>delegate;

+ (CGFloat)heightForView;

- (void)setCellStation:(KCellStation)station;

@end

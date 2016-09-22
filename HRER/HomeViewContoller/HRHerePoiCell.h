//
//  HRHerePoiCell.h
//  HRER
//
//  Created by quke on 16/6/12.
//  Copyright © 2016年 linjunhou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HereDataModel.h"

@class HRHerePoiCell;
@protocol HRHerePoiCellDelegate <NSObject>
@optional
- (void)herePoiCell:(HRHerePoiCell *)cell DidClickFrameView:(UIImageView *)imageView;
- (void)herePoiCellDidClick:(HRHerePoiCell *)cell;
- (void)herePoiCellDidClickUserPortrait:(HRHerePoiCell *)cell;
@end


@interface HRHerePoiCell : UITableViewCell

@property(nonatomic,weak)id<HRHerePoiCellDelegate>delegate;
@property(nonatomic,strong)HRPOIInfo * data;

- (void)setLocaitonStr:(NSString *)str;

+ (CGFloat)heightForCell;

- (void)showMask:(BOOL)isShow;

@end

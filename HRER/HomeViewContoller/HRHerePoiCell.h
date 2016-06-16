//
//  HRHerePoiCell.h
//  HRER
//
//  Created by quke on 16/6/12.
//  Copyright © 2016年 linjunhou. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HRHerePoiCell;
@protocol HRHerePoiCellDelegate <NSObject>
- (void)herePoiCell:(HRHerePoiCell *)cell DidClickFrameView:(UIImageView *)imageView;
- (void)herePoiCellDidClick:(HRHerePoiCell *)cell;

@end


@interface HRHerePoiCell : UITableViewCell

@property(nonatomic,weak)id<HRHerePoiCellDelegate>delegate;


+ (CGFloat)heightForCell;

@end

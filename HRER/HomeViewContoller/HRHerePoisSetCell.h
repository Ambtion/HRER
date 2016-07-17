//
//  HRHerePoisSetCell.h
//  HRER
//
//  Created by quke on 16/6/12.
//  Copyright © 2016年 linjunhou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HereDataModel.h"

@class HRHerePoisSetCell;
@protocol HRHerePoisSetCellDelegate <NSObject>
@optional
- (void)herePoisSetCell:(HRHerePoisSetCell *)cell DidClickFrameView:(UIImageView *)imageView;
- (void)herePoisSetCellDidClick:(HRHerePoisSetCell *)cell;
- (void)herePoisSetCellDidClickUserPortrait:(HRHerePoisSetCell *)poiSetsview;

@end

@interface HRHerePoisSetCell : UITableViewCell

@property(nonatomic,weak)id<HRHerePoisSetCellDelegate>delegate;

@property(nonatomic,strong)HRPOISetInfo * data;

+ (CGFloat)heightForCell;


@end

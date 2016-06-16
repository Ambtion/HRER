//
//  HRHerePoisSetCell.h
//  HRER
//
//  Created by quke on 16/6/12.
//  Copyright © 2016年 linjunhou. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HRHerePoisSetCell;
@protocol HRHerePoisSetCellDelegate <NSObject>
- (void)herePoisSetCell:(HRHerePoisSetCell *)cell DidClickFrameView:(UIImageView *)imageView;
- (void)herePoisSetCellDidClick:(HRHerePoisSetCell *)cell;

@end

@interface HRHerePoisSetCell : UITableViewCell

@property(nonatomic,weak)id<HRHerePoisSetCellDelegate>delegate;

+ (CGFloat)heightForCell;

@end

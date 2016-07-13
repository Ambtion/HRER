//
//  BMOldFriendCell.h
//  HRER
//
//  Created by quke on 16/7/10.
//  Copyright © 2016年 linjunhou. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BMOldFriendCell;
@protocol BMOldFriendCellDelegate <NSObject>
- (void)oldFriendCell:(BMOldFriendCell *)cell didClickFavButton:(UIButton *)button;
@end

@interface BMOldFriendCell : UITableViewCell

@property(nonatomic,strong)UIView * lineView;
@property(nonatomic,strong)HRFriendsInfo * dataModel;

@property(nonatomic,weak)id<BMOldFriendCellDelegate>delegate;

+ (CGFloat)heighForCell;

@end

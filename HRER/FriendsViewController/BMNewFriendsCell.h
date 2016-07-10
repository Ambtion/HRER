//
//  BMNewFriendsCell.h
//  HRER
//
//  Created by quke on 16/7/10.
//  Copyright © 2016年 linjunhou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BMNewFriendsCell : UITableViewCell

@property(nonatomic,strong)UILabel * maintitle;
@property(nonatomic,strong)UILabel * subTitle;
@property(nonatomic,strong)UIView * lineView;

+ (CGFloat)heighForCell;

@end

//
//  HRSettingUserinfoCell.h
//  HRER
//
//  Created by quke on 16/7/27.
//  Copyright © 2016年 linjunhou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HRSettingUserinfoCell : UITableViewCell

+ (CGFloat)heightForCell;

@property(nonatomic,strong)UIImageView * porView;
@property(nonatomic,strong)UILabel * passLabel;
@property(nonatomic,strong)UIButton * uploadImageButton;

@end


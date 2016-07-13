//
//  BMNewFriendsCell.m
//  HRER
//
//  Created by quke on 16/7/10.
//  Copyright © 2016年 linjunhou. All rights reserved.
//

#import "BMNewFriendsCell.h"

@implementation BMNewFriendsCell

+ (CGFloat)heighForCell
{
    return 50.f;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initUI];
    }
    return  self;
}


- (void)initUI
{
    self.maintitle = [[UILabel alloc] init];
    self.maintitle.textColor = RGB_Color(0x5b, 0x5b, 0x5b);
    self.maintitle.font = [UIFont systemFontOfSize:15.f];
    [self.contentView addSubview:self.maintitle];
    
    self.subTitle = [[UILabel alloc] init];
    self.subTitle.textColor = RGB_Color(0xcc, 0xcc, 0xcc);
    self.subTitle.font = [UIFont systemFontOfSize:12.f];
    [self.contentView addSubview:self.subTitle];

    self.lineView = [[UIView alloc] init];
    self.lineView.backgroundColor = RGB_Color(0xec, 0xec, 0xec);
    [self addSubview:self.lineView];
    
    [self.maintitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(14.f);
        make.centerY.equalTo(self.contentView);
    }];
    
    [self.subTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.maintitle.mas_right).offset(7.f);
        make.centerY.equalTo(self.contentView);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.maintitle);
        make.right.equalTo(self.contentView).offset(-14.f);
        make.bottom.equalTo(self.contentView);
        make.height.equalTo(@(0.5));
    }];
}

#pragma mark
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}
- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    [super setHighlighted:highlighted animated:animated];
}

@end

//
//  BMOldFriendCell.m
//  HRER
//
//  Created by quke on 16/7/10.
//  Copyright © 2016年 linjunhou. All rights reserved.
//

#import "BMOldFriendCell.h"

@interface BMOldFriendCell ()

@property(nonatomic,strong)UIImageView * poraitView;
@property(nonatomic,strong)UILabel * mainTitle;
@property(nonatomic,strong)UILabel * subTitle;
@property(nonatomic,strong)UILabel * fromTitle;
@property(nonatomic,strong)UIButton * favButton;


@end

@implementation BMOldFriendCell

+ (CGFloat)heighForCell
{
    return 80.f;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initUI];
    }
    return self;
}

- (void)initUI
{
    self.poraitView = [[UIImageView alloc] init];
    self.poraitView.layer.cornerRadius = 25.f;
    [self.poraitView setClipsToBounds:YES];
    [self.contentView addSubview:self.poraitView];
    
    self.mainTitle = [[UILabel alloc] init];
    self.mainTitle.textColor = RGB_Color(0x5c, 0x5c, 0x5c);
    self.mainTitle.font = [UIFont systemFontOfSize:15.f];
    [self.contentView addSubview:self.mainTitle];
    
    
    self.subTitle = [[UILabel alloc] init];
    self.subTitle.textColor = RGB_Color(0x79, 0x79, 0x79);
    self.subTitle.font = [UIFont systemFontOfSize:13.f];
    [self.contentView addSubview:self.subTitle];
    
    
    self.fromTitle = [[UILabel alloc] init];
    self.fromTitle.textColor = RGB_Color(0xc3, 0xc3, 0xc3);
    self.fromTitle.font = [UIFont systemFontOfSize:10.f];
    [self.contentView addSubview:self.fromTitle];
    
    self.favButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.favButton addTarget:self action:@selector(favButtonDidClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.favButton setBackgroundImage:[UIImage imageNamed:@"friends_fav"] forState:UIControlStateNormal];
    [self.favButton setTitleColor:RGB_Color(0xe6, 0x4f, 0x20) forState:UIControlStateNormal];
    [[self.favButton titleLabel] setFont:[UIFont systemFontOfSize:14.f]];
    [self.contentView addSubview:self.favButton];
    
    self.lineView = [[UIView alloc] init];
    self.lineView.backgroundColor = RGB_Color(0xec, 0xec, 0xec);
    [self addSubview:self.lineView];
    
    [self.poraitView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(14.f);
        make.size.mas_equalTo(CGSizeMake(50.f, 50.f));
        make.centerY.equalTo(self.contentView);
    }];
    
    [self.mainTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.poraitView.mas_right).offset(5.f);
        make.top.equalTo(self.contentView).offset(24.f);
        make.width.priorityLow();
    }];
    
    [self.subTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mainTitle.mas_right).offset(7.f);
//        make.right.equalTo(self.favButton.mas_left).offset(-10).priorityLow();
        make.centerY.equalTo(self.mainTitle);
    }];
    
    [self.favButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-10.f);
        make.centerY.equalTo(self.contentView);
        make.height.equalTo(@(36.f));
        make.width.equalTo(@(65));
    }];
    
    [self.fromTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.subTitle);
        make.top.equalTo(self.subTitle.mas_bottom).offset(10.f);
        make.right.equalTo(self.favButton.mas_left).offset(-10);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.poraitView);
        make.right.equalTo(self.contentView).offset(-14.f);
        make.bottom.equalTo(self.contentView);
        make.height.equalTo(@(0.5));
    }];
}

- (void)setDataModel:(HRFriendsInfo *)dataModel
{
    if (_dataModel == dataModel) {
        return;
    }
    _dataModel = dataModel;
    self.poraitView.image = [UIImage imageNamed:@"man"];
    if (self.dataModel.image) {
        [self.poraitView sd_setImageWithURL:[NSURL URLWithString:self.dataModel.image] placeholderImage:[UIImage imageNamed:@"man"]];
    }
    self.mainTitle.text = self.dataModel.name;
    self.subTitle.text = self.dataModel.subName;
    self.fromTitle.text = self.dataModel.userInfo;
    
    switch (self.dataModel.isFollow) {
        case 0:
            //没有关注
            [self.favButton setTitle:@"未关注" forState:UIControlStateNormal];
            break;
        case 1:
            //关注
            [self.favButton setTitle:@"已关注" forState:UIControlStateNormal];
            //关注
            break;
        case 2:
            [self.favButton setTitle:@"相互关注" forState:UIControlStateNormal];
            //相互关注
            break;
        default:
            break;
    }
}



- (void)favButtonDidClick:(UIButton *)button
{
    if ([_delegate respondsToSelector:@selector(oldFriendCell:didClickFavButton:)]){
        [_delegate oldFriendCell:self didClickFavButton:button];
    }
}

#pragma mark
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}
- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated{
    [super setHighlighted:highlighted animated:animated];
}

@end

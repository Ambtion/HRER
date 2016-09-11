//
//  HRUserHomeInfoCardView.m
//  HRER
//
//  Created by quke on 16/7/19.
//  Copyright © 2016年 linjunhou. All rights reserved.
//

#import "HRUserHomeInfoCardView.h"
#import "LoginStateManager.h"
#import "PortraitView.h"

@interface HRUserHomeInfoCardView()

@property(nonatomic,strong)PortraitView * portraitView;
@property(nonatomic,strong)UILabel * nameLabel;
@property(nonatomic,strong)UILabel * nameValue;
@property(nonatomic,strong)UILabel * passLabel;
@property(nonatomic,strong)UILabel * passValueLabel;
@property(nonatomic,strong)UILabel * friendsLabel;
@property(nonatomic,strong)UILabel * visitCityLabel;
@property(nonatomic,strong)UIImageView * identifyImageView;

@property(nonatomic,strong)UIButton * shareButton;

@end

@implementation HRUserHomeInfoCardView

+ (CGFloat)heightForView
{
    return 167;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setUserInteractionEnabled:YES];
        [self initUI];
    }
    return self;
}

- (void)initUI
{
    
    self.portraitView = [[PortraitView alloc] init];
    self.portraitView.layer.borderWidth = 5.f;
    self.portraitView.layer.borderColor = [UIColor whiteColor].CGColor;
    [self addSubview:self.portraitView];
    
    self.nameLabel = [[UILabel alloc] init];
    self.nameLabel.font = [UIFont systemFontOfSize:11.f];
    self.nameLabel.text = @"姓名/Name";
    self.nameLabel.textColor =UIColorFromRGB(0xdb4d30);
    [self addSubview:self.nameLabel];
    
    self.nameValue = [[UILabel alloc] init];
    self.nameValue.font = [UIFont systemFontOfSize:15.f];
    self.nameValue.textColor = UIColorFromRGB(0x4c4c4c);
    [self addSubview:self.nameValue];
    
    
    self.passLabel = [[UILabel alloc] init];
    self.passLabel.font = [UIFont systemFontOfSize:14.f];
    self.passLabel.textColor =UIColorFromRGB(0xdb4d30);
    self.passLabel.text = @"护照号/Passport No";
    [self addSubview:self.passLabel];
    
    self.passValueLabel = [[UILabel alloc] init];
    self.passValueLabel.font = [UIFont systemFontOfSize:15.f];
    self.passValueLabel.textColor = UIColorFromRGB(0x4c4c4c);
    [self addSubview:self.passValueLabel];

    self.friendsLabel = [[UILabel alloc] init];
    self.friendsLabel.font = [UIFont systemFontOfSize:12.f];
    self.friendsLabel.textColor =  UIColorFromRGB(0x999999);
    [self addSubview:self.friendsLabel];
    
    self.visitCityLabel = [[UILabel alloc] init];
    self.visitCityLabel.font = [UIFont systemFontOfSize:12.f];
    self.visitCityLabel.textColor = UIColorFromRGB(0x999999);
    [self addSubview:self.visitCityLabel];
    
//    self.shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    [self.shareButton addTarget:self action:@selector(buttonDidClick:) forControlEvents:UIControlEventTouchUpInside];
//    [self addSubview:self.shareButton];
    
//    self.identifyImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"barcode"]];
//    [self addSubview:self.identifyImageView];
    
    
    [self.portraitView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(19.f);
        make.left.equalTo(self).offset(25.f);
        make.width.equalTo(@(109));
        make.bottom.equalTo(self.visitCityLabel);
    }];
    
//    [self.shareButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self).offset(10.f);
//        make.right.equalTo(self).offset(-10);
//        make.size.mas_equalTo(CGSizeMake(22, 22));
//    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.portraitView.mas_right).offset(20.f);
        make.height.equalTo(@(11));
        make.top.equalTo(self.portraitView);
        make.right.equalTo(self).offset(-20);
    }];
    
    
    [self.nameValue mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.nameLabel);
        make.height.equalTo(@(15));
        make.top.equalTo(self.nameLabel.mas_bottom).offset(10.f);
    }];
    
    
    [self.passLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.nameLabel);
        make.height.equalTo(@(11));
        make.top.equalTo(self.nameValue.mas_bottom).offset(18.f);
    }];
    [self.passValueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.nameLabel);
        make.top.equalTo(self.passLabel.mas_bottom).offset(10.f);
        make.height.equalTo(@(15));

    }];
    
    
    [self.friendsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(12));
        make.left.right.equalTo(self.nameLabel);
        make.top.equalTo(self.passValueLabel.mas_bottom).offset(20.f);
    }];
    
    [self.visitCityLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.nameLabel);
        make.top.equalTo(self.friendsLabel.mas_bottom).offset(8.f);
        make.height.equalTo(@(12));
    }];
    
//    [self.identifyImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.nameLabel);
//        make.top.equalTo(self.visitCityLabel.mas_bottom).offset(12.f);
//    }];
    
    [self setUserInteractionEnabled:YES];
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onClickDetailInfo:)];
    [self addGestureRecognizer:tap];
}

#pragma mark Data
- (void)setDataSource:(HRUserHomeInfo *)dataSource
{
    if (_dataSource == dataSource) {
        return;
    }
    _dataSource = dataSource;
    self.nameValue.text = dataSource.name;
    self.passValueLabel.text = dataSource.passport_num;
    self.friendsLabel.text = [NSString stringWithFormat:@"拥有%ld个朋友",(long)dataSource.f_num];
    self.visitCityLabel.text = [NSString stringWithFormat:@"足迹遍布%ld个城市",(long)dataSource.f_city_num];
    [self.portraitView.imageView sd_setImageWithURL:[NSURL URLWithString:dataSource.image] placeholderImage:[UIImage imageNamed:@"man"]];    
//    if ([[LoginStateManager getInstance] userLoginInfo] &&
//        [[LoginStateManager getInstance] userLoginInfo].user_id &&
//        [[[LoginStateManager getInstance] userLoginInfo].user_id isEqualToString:dataSource.user_id]) {
//        [self.shareButton setImage:[UIImage imageNamed:@"userhome_share"] forState:UIControlStateNormal];
//        [self.shareButton setImage:[UIImage imageNamed:@"userhome_share"] forState:UIControlStateHighlighted];
//
//    }else{
//        [self.shareButton setImage:[UIImage imageNamed:@"userhome_follow_add"] forState:UIControlStateSelected];
//        [self.shareButton setImage:[UIImage imageNamed:@"userhome_follow"] forState:UIControlStateNormal];
//        [self.shareButton setSelected:dataSource.is_focus];
//    }
}


#pragma mark Action
- (void)buttonDidClick:(UIButton *)button
{
    if ([_delegate respondsToSelector:@selector(userHomeInfoCardViewDidClickRightButton:)]) {
        [_delegate userHomeInfoCardViewDidClickRightButton:button];
    }
}

- (void)onClickDetailInfo:(UITapGestureRecognizer *)tap
{
    if ([_delegate respondsToSelector:@selector(userHomeInfoCardViewDidClickDetail:)]) {
        [_delegate userHomeInfoCardViewDidClickDetail:self];
    }
}

@end

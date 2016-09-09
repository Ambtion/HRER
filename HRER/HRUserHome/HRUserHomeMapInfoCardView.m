//
//  HRUserHomeInfoCardView.m
//  HRER
//
//  Created by quke on 16/7/19.
//  Copyright © 2016年 linjunhou. All rights reserved.
//

#import "HRUserHomeMapInfoCardView.h"
#import "LoginStateManager.h"

@interface HRUserHomeMapInfoCardView()

@property(nonatomic,strong)UIImageView * portraitView;
@property(nonatomic,strong)UILabel * nameLabel;
@property(nonatomic,strong)UILabel * passLabel;
@property(nonatomic,strong)UILabel * friendsLabel;
@property(nonatomic,strong)UILabel * visitCityLabel;
@property(nonatomic,strong)UIImageView * identifyImageView;

@property(nonatomic,strong)UIButton * shareButton;

@end

@implementation HRUserHomeMapInfoCardView

+ (CGFloat)heightForView
{
    return 160;
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
    self.image = [UIImage imageNamed:@"information_bg"];
    self.portraitView = [[UIImageView alloc] init];
    [self addSubview:self.portraitView];
    
    self.nameLabel = [[UILabel alloc] init];
    self.nameLabel.font = [UIFont systemFontOfSize:14.f];
    self.nameLabel.textColor = [UIColor whiteColor];
    [self addSubview:self.nameLabel];
    
    self.passLabel = [[UILabel alloc] init];
    self.passLabel.font = [UIFont systemFontOfSize:14.f];
    self.passLabel.textColor = [UIColor whiteColor];
    [self addSubview:self.passLabel];
    
    self.friendsLabel = [[UILabel alloc] init];
    self.friendsLabel.font = [UIFont systemFontOfSize:14.f];
    self.friendsLabel.textColor = [[UIColor whiteColor] colorWithAlphaComponent:0.6];
    [self addSubview:self.friendsLabel];
    
    self.visitCityLabel = [[UILabel alloc] init];
    self.visitCityLabel.font = [UIFont systemFontOfSize:14.f];
    self.visitCityLabel.textColor = [[UIColor whiteColor] colorWithAlphaComponent:0.6];
    [self addSubview:self.visitCityLabel];
    
    self.shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.shareButton addTarget:self action:@selector(buttonDidClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.shareButton];
    
    self.identifyImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"barcode"]];
    [self addSubview:self.identifyImageView];
    
    
    [self.portraitView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self).offset(15.f);
        make.width.equalTo(@(90));
        make.height.equalTo(@(130));
    }];
    
    [self.shareButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(10.f);
        make.right.equalTo(self).offset(-10);
        make.size.mas_equalTo(CGSizeMake(22, 22));
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.portraitView.mas_right).offset(11.f);
        make.top.equalTo(self.portraitView);
        make.right.equalTo(self.shareButton.mas_left);
    }];
    
    [self.passLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(self.nameLabel);
        make.left.equalTo(self.nameLabel);
        make.top.equalTo(self.nameLabel.mas_bottom).offset(12.f);
    }];
    
    [self.friendsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(self.nameLabel);
        make.left.equalTo(self.nameLabel);
        make.top.equalTo(self.passLabel.mas_bottom).offset(12.f);
    }];
    
    [self.visitCityLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(self.nameLabel);
        make.left.equalTo(self.nameLabel);
        make.top.equalTo(self.friendsLabel.mas_bottom).offset(12.f);

    }];
    
    [self.identifyImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel);
        make.top.equalTo(self.visitCityLabel.mas_bottom).offset(12.f);
    }];
    
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
    self.nameLabel.text = [NSString stringWithFormat:@"姓名: %@",dataSource.name];
    self.passLabel.text = [NSString stringWithFormat:@"护照号:  %@",dataSource.passport_num];
    self.friendsLabel.text = [NSString stringWithFormat:@"拥有%ld个朋友",(long)dataSource.f_num];
    self.visitCityLabel.text = [NSString stringWithFormat:@"足迹遍布%ld个城市",(long)dataSource.f_city_num];
    [self.portraitView sd_setImageWithURL:[NSURL URLWithString:dataSource.image] placeholderImage:[UIImage imageNamed:@"man"]];
    
    if ([[LoginStateManager getInstance] userLoginInfo] &&
        [[LoginStateManager getInstance] userLoginInfo].user_id &&
        [[[LoginStateManager getInstance] userLoginInfo].user_id isEqualToString:dataSource.user_id]) {
        [self.shareButton setImage:[UIImage imageNamed:@"userhome_share"] forState:UIControlStateNormal];
        [self.shareButton setImage:[UIImage imageNamed:@"userhome_share"] forState:UIControlStateHighlighted];

    }else{
        [self.shareButton setImage:[UIImage imageNamed:@"userhome_follow_add"] forState:UIControlStateSelected];
        [self.shareButton setImage:[UIImage imageNamed:@"userhome_follow"] forState:UIControlStateNormal];
        [self.shareButton setSelected:dataSource.is_focus];
    }
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

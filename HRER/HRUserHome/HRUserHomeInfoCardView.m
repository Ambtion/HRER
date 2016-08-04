//
//  HRUserHomeInfoCardView.m
//  HRER
//
//  Created by quke on 16/7/19.
//  Copyright © 2016年 linjunhou. All rights reserved.
//

#import "HRUserHomeInfoCardView.h"

@interface HRUserHomeInfoCardView()

@property(nonatomic,strong)UIImageView * portraitView;
@property(nonatomic,strong)UILabel * nameLabel;
@property(nonatomic,strong)UILabel * passLabel;
@property(nonatomic,strong)UILabel * friendsLabel;
@property(nonatomic,strong)UILabel * visitCityLabel;
@property(nonatomic,strong)UIImageView * identifyImageView;

@property(nonatomic,strong)UIButton * shareButton;

@end

@implementation HRUserHomeInfoCardView

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
- (void)setDataSource:(id)dataSource
{
    self.nameLabel.text = @"姓名: DJ";
    self.passLabel.text = @"护照号:  BJ01";
    self.friendsLabel.text = @"拥有178个朋友";
    self.visitCityLabel.text = @"足迹遍布27个城市";
 
    [self.shareButton setImage:[UIImage imageNamed:@"userhome_share"] forState:UIControlStateNormal];
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

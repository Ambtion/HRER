//
//  HRPoiUserInfoBottomView.m
//  HRER
//
//  Created by kequ on 16/7/14.
//  Copyright © 2016年 linjunhou. All rights reserved.
//

#import "HRPoiUserInfoBottomView.h"

@interface HRPoiUserInfoBottomView()

@property(nonatomic,strong)UILabel * timeLabel;
@property(nonatomic,strong)UIButton * wantTogoButton;
@property(nonatomic,strong)UIButton * recomendButton;

@end

@implementation HRPoiUserInfoBottomView

+ (CGFloat)heightForView
{
    return 54.f;
}


- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initUI];
    }
    return self;
}

- (void)initUI
{
    self.timeLabel = [[UILabel alloc] init];
    self.timeLabel.textColor = RGB_Color(0xa6, 0xa6, 0xa6);
    self.timeLabel.font = [UIFont systemFontOfSize:12.f];
    [self addSubview:self.timeLabel];
    
    self.wantTogoButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.wantTogoButton addTarget:self action:@selector(wantGoButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.wantTogoButton setImage:[UIImage imageNamed:@"xiangqu"] forState:UIControlStateNormal];
    [self addSubview:self.wantTogoButton];
    
    self.recomendButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.recomendButton setImage:[UIImage imageNamed:@"pinglun"] forState:UIControlStateNormal];
    [self.recomendButton addTarget:self action:@selector(recomendButtonDidClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.recomendButton];
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(12.f);
        make.top.equalTo(self);
        
    }];
    
    [self.recomendButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-12.f);
        make.bottom.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(71, 32));
    }];
    
    [self.wantTogoButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(self.recomendButton);
        make.right.equalTo(self.recomendButton.mas_left).offset(-12.f);
        make.centerY.equalTo(self.recomendButton);
    }];
    
}

- (void)wantGoButton:(UIButton *)button
{
    if ([_delegate respondsToSelector:@selector(poiUserInfoBottomViewDidClickWantTogo:)]) {
        [_delegate poiUserInfoBottomViewDidClickWantTogo:self];
    }
}


- (void)recomendButtonDidClick:(UIButton *)button
{
    if ([_delegate respondsToSelector:@selector(poiUserInfoBottomViewDidClickRecomend:)]) {
        [_delegate poiUserInfoBottomViewDidClickRecomend:self];
    }
}

- (void)setData:(HRPOIInfo *)data
{
    self.timeLabel.text = data.ctimeStr;
}


@end

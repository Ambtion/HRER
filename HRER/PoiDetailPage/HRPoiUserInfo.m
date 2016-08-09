//
//  HRPoiUserInfo.m
//  HRER
//
//  Created by kequ on 16/7/14.
//  Copyright © 2016年 linjunhou. All rights reserved.
//

#import "HRPoiUserInfo.h"

@interface HRPoiUserInfo()

@property(nonatomic,strong)UIImageView * porImageView;
@property(nonatomic,strong)UILabel * userName;
@property(nonatomic,strong)UIImageView * iconImageView;
@property(nonatomic,strong)UILabel * recomendLabel;

@end

@implementation HRPoiUserInfo


+ (CGFloat)heightForView
{
    return 77.f;
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
    self.porImageView = [[UIImageView alloc] init];
    self.porImageView.layer.cornerRadius = 24.f;
    self.porImageView.layer.masksToBounds = YES;
    [self addSubview:self.porImageView];
    
    self.userName = [[UILabel alloc] init];
    self.userName.font = [UIFont systemFontOfSize:16.f];
    self.userName.textColor = [UIColor blackColor];
    [self addSubview:self.userName];
    
    self.iconImageView = [[UIImageView alloc] init];
    self.iconImageView.image = [UIImage imageNamed:@"tuijian"];
    [self addSubview:self.iconImageView];
    
    self.recomendLabel = [[UILabel alloc] init];
    self.recomendLabel.textColor =  RGB_Color(0xa6, 0xa6, 0xa6);
    self.recomendLabel.font = [UIFont systemFontOfSize:14.f];
    [self addSubview:self.recomendLabel];
    
    [self.porImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(12.f);
        make.size.mas_equalTo(CGSizeMake(48, 48));
        make.centerY.equalTo(self);
    }];
    
    [self.userName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(17.f);
        make.left.equalTo(self.porImageView.mas_right).offset(15.f);
        make.right.equalTo(self).offset(-17.f);
    }];
    
    
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.userName);
        make.top.equalTo(self.userName.mas_bottom).offset(9);
        make.size.mas_equalTo(CGSizeMake(19, 19));
    }];
    
    [self.recomendLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.userName.mas_bottom).offset(9.f);
        make.left.equalTo(self.iconImageView.mas_right).offset(5);
    }];
}

- (void)setDtata:(HRPOIInfo *)data
{
    self.userName.text = data.creator_name;
    self.recomendLabel.text = [NSString stringWithFormat:@"推荐%ld%@",(long)data.recommand,data.typeName];
    [self.porImageView sd_setImageWithURL:[NSURL URLWithString:data.portrait] placeholderImage:[UIImage imageNamed:@"man"]];
}


@end

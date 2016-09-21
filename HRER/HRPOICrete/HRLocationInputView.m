//
//  HRLocationInputView.m
//  HRER
//
//  Created by kequ on 16/7/20.
//  Copyright © 2016年 linjunhou. All rights reserved.
//

#import "HRLocationInputView.h"

@implementation HRLocationInputView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initUI];
    }
    return self;
}

- (void)initUI
{
    self.iconView = [[UIImageView alloc] init];
    [self addSubview:self.iconView];
    
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.font = [UIFont boldSystemFontOfSize:16.f];
    self.titleLabel.textColor = RGB_Color(0x4d, 0x4d, 0x4d);
    [self addSubview:self.titleLabel];
    
    self.textField = [[UITextField alloc] init];
    self.textField.font = [UIFont systemFontOfSize:12.f];
    self.textField.textAlignment = NSTextAlignmentLeft;
    self.textField.textColor = RGB_Color(0x4d, 0x4d, 0x4d);
    [self addSubview:self.textField];
    
    self.lineView = [[UIView alloc] init];
    self.lineView.backgroundColor = RGB_Color(0xec, 0xec, 0xec);
    [self addSubview:self.lineView];
    
    CGFloat offset = 20;
    [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(offset);
        make.centerY.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(6, 6));
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconView.mas_right).offset(7.f);
        make.top.height.equalTo(self);
        make.width.equalTo(@(75));
    }];
    
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.height.equalTo(self);
        make.left.equalTo(self.titleLabel.mas_right).offset(10.f);
        make.right.equalTo(self).offset(-offset);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconView);
        make.right.equalTo(self.textField.mas_right);
        make.bottom.equalTo(self);
        make.height.equalTo(@(0.5));
    }];
}

@end

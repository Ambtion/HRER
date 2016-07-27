//
//  HRSettingUserinfoCell.m
//  HRER
//
//  Created by quke on 16/7/27.
//  Copyright © 2016年 linjunhou. All rights reserved.
//

#import "HRSettingUserinfoCell.h"

@interface HRSettingUserinfoCell()

@property(nonatomic,strong)UIImageView * passBgView;

@end

@implementation HRSettingUserinfoCell

+ (CGFloat)heightForCell
{
    return 143;
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
    
    self.passBgView = [[UIImageView alloc] init];
    self.passBgView.image = [[UIImage imageNamed:@"BJ01"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 30, 0, 30)];
    [self.contentView addSubview:self.passBgView];

    self.porView = [[UIImageView alloc] init];
    self.porView.layer.cornerRadius = 35.f;
    [self.contentView addSubview:self.porView];

    self.passLabel = [[UILabel alloc] init];
    self.passLabel.font = [UIFont boldSystemFontOfSize:17.f];
    self.passLabel.textColor = [UIColor whiteColor];
    [self.contentView addSubview:self.passLabel];
    
    [self.porView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(29.f);
        make.centerX.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(70, 70.f));
    }];
    
    [self.passLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.porView);
        make.left.equalTo(self.porView.mas_right).offset(10);
    }];
    self.passLabel.backgroundColor = [UIColor greenColor];
    
    [self.passBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.porView);
        make.left.equalTo(self.porView.mas_right).offset(-15);
        make.right.equalTo(self.passLabel.mas_right).offset(15.f);
        
    }];
    
    self.uploadImageButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.uploadImageButton setImage:[UIImage imageNamed:@"photo"] forState:UIControlStateNormal];
    [self.contentView addSubview:self.uploadImageButton];
    
    [self.uploadImageButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.porView).offset(6);
        make.left.equalTo(self.porView.mas_left).offset(-6);
    }];
}

@end

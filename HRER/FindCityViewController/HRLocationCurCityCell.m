//
//  HRLocationCurCityCell.m
//  HRER
//
//  Created by kequ on 16/7/28.
//  Copyright © 2016年 linjunhou. All rights reserved.
//

#import "HRLocationCurCityCell.h"

@interface HRLocationCurCityCell()

@property(nonatomic,strong)UIImageView * locImageView;
@property(nonatomic,strong)UILabel * subLabel;

@end

@implementation HRLocationCurCityCell

+ (CGFloat)heightForCell
{
    return 46.f;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = RGBA(244, 246, 245, 1);
        [self initUI];
    }
    return self;
}

- (void)initUI
{
    self.locImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"dingwei"]];
    [self.contentView addSubview:self.locImageView];
    
    self.cityLabel = [[UILabel alloc] init];
    self.cityLabel.font = [UIFont systemFontOfSize:16.f];
    self.cityLabel.textColor = RGBA(0xd6, 0x42, 0x4f, 1);
    [self.contentView addSubview:self.cityLabel];
    
    self.subLabel = [[UILabel alloc] init];
    self.subLabel.font = [UIFont systemFontOfSize:12.f];
    self.subLabel.textColor = RGBA(0x9c, 0x9c, 0x9c, 1);
    self.subLabel.text = @"当前定位城市";
    [self.contentView addSubview:self.subLabel];
    
    [self.locImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(self).offset(10.f);
    }];
    
    [self.cityLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.locImageView.mas_right).offset(12.f);
        make.centerY.equalTo(self);
    }];
    
    [self.subLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.cityLabel.mas_right).offset(12);
        make.centerY.equalTo(self);
    }];
}
@end

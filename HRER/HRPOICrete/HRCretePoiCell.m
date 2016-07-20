//
//  HRCretePoiCell.m
//  HRER
//
//  Created by quke on 16/7/20.
//  Copyright © 2016年 linjunhou. All rights reserved.
//

#import "HRCretePoiCell.h"

@interface HRCretePoiCell()

@property(nonatomic,strong)UIImageView * portraitImage;
@property(nonatomic,strong)UILabel * titleLabel;
@property(nonatomic,strong)UILabel * subLabel;

@property(nonatomic,strong)UIImageView * locIconView;
@property(nonatomic,strong)UILabel * locLabel;

@end

@implementation HRCretePoiCell


+ (CGFloat)heightforCell
{
    return 80.f;
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
    }
    return self;
}

- (void)initUI
{
    self.portraitImage = [[UIImageView alloc] init];
    [self addSubview:self.portraitImage];
    
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.font = [UIFont systemFontOfSize:16.f];
    self.titleLabel.textColor = RGB_Color(0x4d, 0x4d, 0x4d);
    self.titleLabel.textAlignment = NSTextAlignmentLeft;
    [self addSubview:self.titleLabel];
    
    
    self.subLabel = [[UILabel alloc] init];
    self.subLabel.font = [UIFont systemFontOfSize:12.f];
    self.subLabel.textColor = RGB_Color(0xa6, 0xa6, 0xa6);
    self.subLabel.textAlignment = NSTextAlignmentLeft;
    [self addSubview:self.subLabel];
    
    [self.portraitImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(46.f, 46.f));
        make.left.equalTo(self).offset(10.f);
        make.centerY.equalTo(self);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.portraitImage.mas_right).offset(12.f);
        make.right.equalTo(self).offset(-14.f);
        make.top.equalTo(self).offset(23.f);
        make.height.equalTo(@(16.f));
        
    }];
    
    
    [self.subLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel);
        make.width.equalTo(self.titleLabel);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(12.f);
    }];
    
    
    self.locIconView = [[UIImageView alloc] init];
    self.locIconView.image = [UIImage imageNamed:@"km"];
    [self addSubview:self.locIconView];
    
    self.locLabel = [[UILabel alloc] init];
    self.locLabel.font = [UIFont systemFontOfSize:12.f];
    self.locLabel.textColor = RGB_Color(0x4c, 0x4c, 0x4c);
    [self addSubview:self.locLabel];
    
    [self.locLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(19.f);
        make.height.equalTo(@(14.f));
        make.centerY.equalTo(self.subLabel);
    }];
    
    [self.locIconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.locLabel.mas_left).offset(-5);
        make.centerY.equalTo(self.locLabel);
    }];


}

#pragma mark
- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated{}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {}

@end

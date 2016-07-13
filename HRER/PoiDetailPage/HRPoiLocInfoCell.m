//
//  HRPoiLocInfoCell.m
//  HRER
//
//  Created by kequ on 16/7/13.
//  Copyright © 2016年 linjunhou. All rights reserved.
//

#import "HRPoiLocInfoCell.h"

@interface HRPoiLocInfoCell()

@property(nonatomic,strong)UIView * bgView;

@property(nonatomic,strong)UILabel * titleLabel;
@property(nonatomic,strong)UIView * caterBgView;
@property(nonatomic,strong)UILabel * catergortLabel;
@property(nonatomic,strong)UILabel * addressLabel;
@property(nonatomic,strong)UIImageView * locIcon;
@property(nonatomic,strong)UILabel * distanceLabel;

@property(nonatomic,strong)UILabel * cityName;

@end

@implementation HRPoiLocInfoCell

+ (CGFloat)heightForCell
{
    return 16 + 73.f;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = RGB_Color(236, 236, 236);
        [self initUI];
    }
    return self;
}

- (void)initUI
{
    self.bgView = [[UIView alloc] init];
    self.bgView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:self.bgView];
    
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self);
        make.width.equalTo(self);
        make.bottom.equalTo(self).offset(-16);
    }];
    
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.font = [UIFont systemFontOfSize:16.f];
    self.titleLabel.textColor = RGB_Color(0x4d, 0x4d, 0x4d);
    [self.contentView addSubview:self.titleLabel];
    
    self.caterBgView = [[UIView alloc] init];
    self.caterBgView.layer.cornerRadius = 4.f;
    self.caterBgView.clipsToBounds = YES;
    [self.contentView addSubview:self.caterBgView];
    
    self.catergortLabel = [[UILabel alloc] init];
    self.catergortLabel.textColor = [UIColor whiteColor];
    self.catergortLabel.font = [UIFont systemFontOfSize:12.f];
    [self.contentView addSubview:self.catergortLabel];
    
    self.addressLabel = [[UILabel alloc] init];
    self.addressLabel.font = [UIFont systemFontOfSize:14.f];
    self.addressLabel.textColor = RGB_Color(0xaa, 0xaa, 0xaa);
    [self.contentView addSubview:self.addressLabel];
    
    self.locIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"km"]];
    [self.contentView addSubview:self.locIcon];
    
    self.distanceLabel = [[UILabel alloc] init];
    self.distanceLabel.textColor = RGB_Color(0xa6, 0xa6, 0xa6);
    self.distanceLabel.font = [UIFont systemFontOfSize:12.f];
    [self.contentView addSubview:self.distanceLabel];
    
    self.cityName = [[UILabel alloc] init];
    self.cityName.font = [UIFont systemFontOfSize:12.f];
    self.cityName.textColor = RGB_Color(0xf5, 0x5d, 0x47);
    [self.contentView addSubview:self.cityName];
    
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(15.f);
        make.left.equalTo(self).offset(12.f);
    }];
    
    [self.caterBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel.mas_right).offset(6.f);
        make.centerY.equalTo(self.titleLabel);
        make.height.equalTo(self.catergortLabel);
    }];
    
    [self.catergortLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.caterBgView).offset(3.f);
        make.right.equalTo(self.caterBgView).offset(-3.f);
        make.centerY.equalTo(self.caterBgView);

    }];
    
    [self.addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(11.f);
        make.right.lessThanOrEqualTo(self.locIcon.mas_left);
    }];
    
    [self.cityName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.addressLabel);
        make.right.equalTo(self).offset(-4.f);
        
    }];
    
    [self.distanceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.cityName.mas_left).offset(-12.f);
        make.centerY.equalTo(self.addressLabel);
    }];
    
    [self.locIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.addressLabel);
        make.right.equalTo(self.distanceLabel.mas_left).offset(-6.f);
    }];
}

- (void)setDataSource:(id)dataSource
{
    self.titleLabel.text = @"老张路透辉石";
    self.catergortLabel.text = @"美食";
    self.addressLabel.text = @"北京上地五金大厦";
    self.distanceLabel.text = @"1000km";
    self.cityName.text = @"北京";
    
//    颜色酒店：#fbb33a    购物：#3bc4ba    观光：#43a2fe    美食：#dc4630
    self.caterBgView.backgroundColor = RGB_Color(0xfb, 0xb3, 0x3a);
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{}


@end

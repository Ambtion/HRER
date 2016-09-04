//
//  HRPoiLocInfoCell.m
//  HRER
//
//  Created by kequ on 16/7/13.
//  Copyright © 2016年 linjunhou. All rights reserved.
//

#import "HRPoiLocInfoCell.h"
#import "HRNavigationTool.h"
#import "HRLocationManager.h"

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
    return 8 + 73.f;
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
        make.bottom.equalTo(self).offset(-8);
    }];
    
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.font = [UIFont systemFontOfSize:16.f];
    self.titleLabel.textColor = RGB_Color(0x4d, 0x4d, 0x4d);
    [self.contentView addSubview:self.titleLabel];
    
    self.caterBgView = [[UIView alloc] init];
    self.caterBgView.layer.cornerRadius = 7.f;
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
        make.right.lessThanOrEqualTo(self.caterBgView.mas_left).offset(-10);

    }];
        
    [self.caterBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-10.f);
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
        make.top.equalTo(self.titleLabel.mas_bottom).offset(9.f);
        make.right.lessThanOrEqualTo(self.locIcon.mas_left);
        make.width.priorityLow();
    }];
    
    [self.cityName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.addressLabel);
        make.right.equalTo(self).offset(-10.f);
        
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

- (void)setDataSource:(HRPOIInfo *)dataSource
{
    self.titleLabel.text = dataSource.title;
    self.catergortLabel.text = dataSource.typeName;
    self.addressLabel.text = dataSource.address;
    
    CLLocation * desLocaiton = [[CLLocation alloc] initWithLatitude:dataSource.lat longitude:dataSource.lng];
    NSString * distance = [HRNavigationTool distanceBetwenOriGps:[[HRLocationManager sharedInstance] curLocation].coordinate desGps:desLocaiton.coordinate];
    self.distanceLabel.text = distance;
    self.cityName.text = dataSource.city_name;
    
    switch (dataSource.type) {
        case 0:
            break;
        case 1:
            self.caterBgView.backgroundColor = UIColorFromRGBA(0xdc4630, 1);
            break;
        case 2:
            self.caterBgView.backgroundColor = UIColorFromRGBA(0x43a2fe, 1);

            break;
        case 3:
            self.caterBgView.backgroundColor = RGB_Color(0x3b, 0xc4, 0xba);
            break;
        case 4:
            self.caterBgView.backgroundColor = RGB_Color(0xfb, 0xb3, 0x3a);
            break;
        default:
            break;
    }
    
//    颜色酒店：#fbb33a    购物：#3bc4ba    观光：#43a2fe    美食：#dc4630
    self.caterBgView.backgroundColor = [self caterColorWithType:dataSource.type];
}


- (UIColor *)caterColorWithType:(NSInteger)type
{
    NSArray * colorArray  = @[
                              RGB_Color(0xdc, 0x46, 0x30),
                              RGB_Color(0x43, 0xa2, 0xf3),
                              RGB_Color(0x3b, 0xc4, 0xba),
                              RGB_Color(0xfb, 0xb3, 0x3a)
                              ];
    if (type >= 0 && type < colorArray.count) {
        return colorArray[type];
    }
    return [UIColor clearColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{}


@end


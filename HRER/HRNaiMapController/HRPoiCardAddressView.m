//
//  HRPoiCardAddressView.m
//  HRER
//
//  Created by quke on 16/7/18.
//  Copyright © 2016年 linjunhou. All rights reserved.
//

#import "HRPoiCardAddressView.h"
#import "HRNavigationTool.h"
#import "HRLocationManager.h"


@interface HRPoiCardAddressView()

@property(nonatomic,strong)UIImageView * bgImageView;

@property(nonatomic,strong)UILabel * addresssLabel;
@property(nonatomic,strong)UIImageView * locIconView;
@property(nonatomic,strong)UILabel * locLabel;

@end

@implementation HRPoiCardAddressView

+ (CGFloat)heightForCardView
{
    return 45.f;
}


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
    self.bgImageView = [[UIImageView alloc] init];
    self.bgImageView.image = [[UIImage imageNamed:@"address_card_bg"] resizableImageWithCapInsets:UIEdgeInsetsMake(20, 20, 20, 20)];
    [self addSubview:self.bgImageView];
    
    self.addresssLabel = [[UILabel alloc] init];
    self.addresssLabel.font = [UIFont systemFontOfSize:14.f];
    self.addresssLabel.textColor = RGB_Color(0x4c, 0x4c, 0x4c);
    [self addSubview:self.addresssLabel];
    
    self.locIconView = [[UIImageView alloc] init];
    self.locIconView.image = [UIImage imageNamed:@"km"];
    [self addSubview:self.locIconView];
    
    self.locLabel = [[UILabel alloc] init];
    self.locLabel.font = [UIFont systemFontOfSize:12.f];
    self.locLabel.textColor = RGB_Color(0xa6, 0xa6, 0xa6);
    [self addSubview:self.locLabel];
 
    [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(10.f);
        make.right.equalTo(self).offset(10.f);
        make.top.height.equalTo(self);
    }];
    
    [self.addresssLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgImageView).offset(10);
        make.height.top.equalTo(self.bgImageView);
        make.right.lessThanOrEqualTo(self.locIconView.mas_left);
    }];
    
    [self.locLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.bgImageView).offset(-10);
        make.top.height.equalTo(self);
    }];
    
    [self.locIconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.locLabel.mas_left).offset(-6);
        make.centerY.equalTo(self.locLabel);
    }];
    
}

- (void)setDataSource:(HRPOIInfo *)data
{
    self.addresssLabel.text = @"上地五接士大夫是方式";
    CLLocation * desLocaiton = [[CLLocation alloc] initWithLatitude:data.lat longitude:data.lng];
    NSString * distance = [HRNavigationTool distanceBetwenOriGps:[[HRLocationManager sharedInstance] curLocation].coordinate desGps:desLocaiton.coordinate];
    NSLog(@"%@",distance);
    self.locLabel.text = @"距离1000km";
}


@end

//
//  HRUserTimeLineHeadView.m
//  HRER
//
//  Created by quke on 16/7/19.
//  Copyright © 2016年 linjunhou. All rights reserved.
//

#import "HRUserTimeLineHeadView.h"

@interface HRUserTimeLineHeadView ()

@property(nonatomic,strong)UIImageView * bgImageView;
@property(nonatomic,strong)UIImageView * foodIcon;
@property(nonatomic,strong)UILabel * foodTitle;
@property(nonatomic,strong)UIImageView * lookIcon;
@property(nonatomic,strong)UILabel * lookTitle;
@property(nonatomic,strong)UIImageView * shopIcon;
@property(nonatomic,strong)UILabel * shopTitle;
@property(nonatomic,strong)UIImageView * hotelIcon;
@property(nonatomic,strong)UILabel * hotelTitle;
@property(nonatomic,strong)UILabel * locCityTitle;

@end

@implementation HRUserTimeLineHeadView

+ (CGFloat)heightForView
{
    CGFloat height = 0;
    height += 10.f;
    height += 49.f;
    height += 6.f;
    return height;
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
    
    self.bgImageView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"userhone_city_bg"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)]];
    [self addSubview:self.bgImageView];
    
    
    self.locCityTitle = [[UILabel alloc] init];
    self.locCityTitle.font = [UIFont boldSystemFontOfSize:18.f];
    self.locCityTitle.textColor = [UIColor whiteColor];
    [self addSubview:self.locCityTitle];
    
    self.foodIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"userhone_city_food"]];
    [self addSubview:self.foodIcon];
    self.foodTitle = [self creteOneCatLabel];
    [self addSubview:self.foodTitle];
    
    self.lookIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"userhone_city_look"]];
    [self addSubview:self.lookIcon];
    self.lookTitle = [self creteOneCatLabel];
    [self addSubview:self.lookTitle];
    
    self.shopIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"userhone_city_shop"]];
    [self addSubview:self.shopIcon];
    self.shopTitle = [self creteOneCatLabel];
    [self addSubview:self.shopTitle];
    
    self.hotelIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"userhone_city_hotel"]];
    [self addSubview:self.hotelIcon];
    self.hotelTitle = [self creteOneCatLabel];
    [self addSubview:self.hotelTitle];
    
    [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(10);
        make.top.equalTo(self).offset(10.f);
        make.right.equalTo(self).offset(-10);
    }];
    
    [self.locCityTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgImageView).offset(18.f);
        make.centerY.equalTo(self.bgImageView);
        make.right.lessThanOrEqualTo(self.foodIcon.mas_left);
    }];
    
    
    //酒店
    [self.hotelTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.bgImageView).offset(-14.f);
        make.centerY.equalTo(self.locCityTitle);
    }];
    [self.hotelIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.hotelTitle.mas_left).offset(-4);
        make.centerY.equalTo(self.locCityTitle);
        make.size.mas_equalTo(CGSizeMake(17, 17));
    }];
    
    
    //购物
    [self.shopTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.hotelIcon.mas_left).offset(-11.f);
        make.centerY.equalTo(self.locCityTitle);
    }];
    [self.shopIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.shopTitle.mas_left).offset(-4);
        make.centerY.equalTo(self.locCityTitle);
        make.size.mas_equalTo(CGSizeMake(17, 17));
    }];

    //观光
    [self.lookTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.shopIcon.mas_left).offset(-11.f);
        make.centerY.equalTo(self.locCityTitle);
    }];
    [self.lookIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.lookTitle.mas_left).offset(-4);
        make.centerY.equalTo(self.locCityTitle);
        make.size.mas_equalTo(CGSizeMake(17, 17));
    }];

    //食物
    [self.foodTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.lookIcon.mas_left).offset(-11.f);
        make.centerY.equalTo(self.locCityTitle);
    }];
    [self.foodIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.foodTitle.mas_left).offset(-4);
        make.centerY.equalTo(self.locCityTitle);
        make.size.mas_equalTo(CGSizeMake(17, 17));
    }];
    
}

- (UILabel *)creteOneCatLabel
{
    UILabel * label = [[UILabel alloc] init];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:14.f];
    label.textColor = [UIColor whiteColor];
    return label;
}

- (void)setDataSource:(id)dataSource
{
    self.locCityTitle.text = @"北京";
    self.foodTitle.text = @"2";
    self.lookTitle.text = @"22";
    self.shopTitle.text = @"2342";
    self.hotelTitle.text = @"2342";
}

@end

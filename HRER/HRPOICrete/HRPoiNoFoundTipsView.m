//
//  HRPOINoFoodTipsView.m
//  HRER
//
//  Created by quke on 16/7/20.
//  Copyright © 2016年 linjunhou. All rights reserved.
//

#import "HRPoiNoFoundTipsView.h"

@interface HRPoiNoFoundTipsView()
@property(nonatomic,strong)UILabel * titleLabel;
@end

@implementation HRPoiNoFoundTipsView
+ (CGFloat)heightForView
{
    CGFloat height = 5.f;
    height += 58.f;
    height += 5;
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
    self.backgroundColor = RGB_Color(0xec, 0xec, 0xec);
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.backgroundColor = [UIColor whiteColor];
    self.titleLabel.font = [UIFont systemFontOfSize:8.f];
    self.titleLabel.textColor = RGB_Color(0x4c, 0x4c, 0x4c);
    self.titleLabel.text = @"没有找到想推荐的点? 去地图扎店";
    [self addSubview:self.titleLabel];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.width.equalTo(self);
        make.top.equalTo(self).offset(5.f);
        make.bottom.equalTo(self).offset(-5.f);
    }];
}
@end

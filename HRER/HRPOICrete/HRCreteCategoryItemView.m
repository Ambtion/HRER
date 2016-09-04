//
//  HRCreteCategoryItemView.m
//  HRER
//
//  Created by kequ on 16/7/20.
//  Copyright © 2016年 linjunhou. All rights reserved.
//

#import "HRCreteCategoryItemView.h"

@implementation HRCreteCategoryItemView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initUI];
        [self setSeleted:NO];
    }
    return self;
}

- (void)initUI
{
    self.bgView = [[UIImageView alloc] init];
    self.bgView.layer.cornerRadius = 15.f;
    [self addSubview:self.bgView];
    
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.font = [UIFont systemFontOfSize:14.f];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.titleLabel];
    
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
    }];
}

- (void)setSeleted:(BOOL)isSeleted
{
    _seleted = isSeleted;
    if(_seleted){
        self.bgView.backgroundColor = [self caterColorWithType:self.tag + 1];
        self.titleLabel.textColor = [UIColor whiteColor];
    }else{
        self.titleLabel.textColor = self.textColor;
        self.bgView.backgroundColor = [UIColor whiteColor];
    }
}

- (UIColor *)caterColorWithType:(NSInteger)type
{
    NSArray * colorArray  = @[
                              RGB_Color(0xdc, 0x46, 0x30),
                              RGB_Color(0x43, 0xa2, 0xf3),
                              RGB_Color(0x3b, 0xc4, 0xba),
                              RGB_Color(0xfb, 0xb3, 0x3a)
                              ];
    if (type -1 >= 0 && type -1 < colorArray.count) {
        return colorArray[type -1];
    }
    return [UIColor clearColor];
}

@end

//
//  HRScrollItemView.m
//  HRER
//
//  Created by kequ on 16/6/9.
//  Copyright © 2016年 linjunhou. All rights reserved.
//

#import "HRCatergoryItemView.h"

@interface HRCatergoryItemView()

@property(nonatomic,strong)UIImageView * imageView;
@property(nonatomic,strong)UILabel * label;

@end

@implementation HRCatergoryItemView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initUI];
    }
    return self;
}

- (void)initUI
{
    self.imageView = [[UIImageView alloc] init];
    [self addSubview:self.imageView];
    
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.left.equalTo(self);
        make.width.equalTo(self);
        make.height.equalTo(self.imageView.mas_width);
    }];
    
    self.label = [[UILabel alloc] init];
    self.label.font = [UIFont systemFontOfSize:14.f];
    self.label.textColor = RGBA_Color(0xff, 0xff, 0xff, 0.8);
    self.label.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.label];
    
    [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.imageView.mas_bottom).offset(8.f);
        make.width.equalTo(self);
        make.left.equalTo(self);
    }];
}

- (void)setCategoryImage:(UIImage *)image categoryNumber:(NSInteger)count
{
    self.imageView.image = image;
    self.label.text = [NSString stringWithFormat:@"%ld",(long)count];
}

@end

//
//  HRInPutView.m
//  HRER
//
//  Created by kequ on 16/7/6.
//  Copyright © 2016年 linjunhou. All rights reserved.
//

#import "HRInPutView.h"

@interface HRInPutView()
@property(nonatomic,strong)UIImageView * imageView;
@end



@implementation HRInPutView

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
    self.imageView.image = [UIImage imageNamed:@"Input-box"];
    [self addSubview:self.imageView];

    self.textField = [[UITextField alloc] init];
    [self addSubview:self.textField];
    
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(self);
        make.top.left.equalTo(@(0));
        make.centerY.equalTo(self);
    }];
    
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(20.f);
        make.right.equalTo(self).offset(-20);
        make.height.equalTo(self);
        make.centerY.equalTo(self);
    }];
    
//    self.backgroundColor = [UIColor redColor];
//    self.textField.backgroundColor = [UIColor greenColor];
}

@end

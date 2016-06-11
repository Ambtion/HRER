//
//  HRScrollItemView.m
//  HRER
//
//  Created by kequ on 16/6/9.
//  Copyright © 2016年 linjunhou. All rights reserved.
//

#import "HRScrollItemView.h"

@interface HRScrollItemView()

@property(nonatomic,strong)UIImageView * imageView;
@property(nonatomic,strong)UILabel * label;

@end

@implementation HRScrollItemView

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
}
@end

//
//  PhotoFrameView.m
//  HRER
//
//  Created by kequ on 16/6/12.
//  Copyright © 2016年 linjunhou. All rights reserved.
//

#import "PhotoFrameView.h"

@implementation PhotoFrameView
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setUserInteractionEnabled:YES];
        [self initUI];
      
    }
    return self;
}

- (void)initUI
{
    self.bgImageView = [[UIImageView alloc] init];
    [self addSubview:self.bgImageView];
    
    [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    self.imageView = [[UIImageView alloc] init];
    [self addSubview:self.imageView];
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.width.equalTo(self);
        make.height.equalTo(self);
        make.bottom.equalTo(self);
    }];
    
}
@end

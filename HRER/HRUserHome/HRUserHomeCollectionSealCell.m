//
//  HRUserHomeCollectionSealCell.m
//  HRER
//
//  Created by kequ on 16/9/11.
//  Copyright © 2016年 linjunhou. All rights reserved.
//

#import "HRUserHomeCollectionSealCell.h"

@implementation HRUserHomeCollectionSealCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.contentView.backgroundColor = [UIColor clearColor];
        self.imageView = [[PortraitView alloc] init];
        [self.contentView addSubview:self.imageView];
        [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsZero);
        }];
    }
    return self;
}



@end

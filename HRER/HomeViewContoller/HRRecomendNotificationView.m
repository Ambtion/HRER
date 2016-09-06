//
//  HRRecomendNotificationView.m
//  HRER
//
//  Created by kequ on 16/9/5.
//  Copyright © 2016年 linjunhou. All rights reserved.
//

#import "HRRecomendNotificationView.h"


@implementation HRRecomendNotificationView

+ (CGFloat)heightForCell
{
    return 50.f;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initUI];
    }
    return self;
}

- (void)initUI
{
    self.action = [[UIButton alloc] init];
    [self.contentView addSubview:self.action];
    [self.action mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.width.height.equalTo(self);
    }];
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated{}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated{}

@end

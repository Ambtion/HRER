//
//  HRRecomendNotificationView.m
//  HRER
//
//  Created by kequ on 16/9/5.
//  Copyright © 2016年 linjunhou. All rights reserved.
//

#import "HRRecomendNotificationView.h"


@implementation HRRecomendNotificationView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

- (void)initUI
{
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.font = [UIFont systemFontOfSize:12.f];
    self.titleLabel.textColor = [UIColor whiteColor];
    [self addSubview:self.titleLabel];
    
    
}
@end

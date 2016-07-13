//
//  HRPoiCreateInfoCell.m
//  HRER
//
//  Created by kequ on 16/7/13.
//  Copyright © 2016年 linjunhou. All rights reserved.
//

#import "HRPoiCreateInfoCell.h"

@interface HRPoiUserInfo : UIView

@property(nonatomic,strong)UIImageView * porImageView;
@property(nonatomic,strong)UILabel * userName;
@property(nonatomic,strong)UIImageView * iconImageView;
@property(nonatomic,strong)UILabel * recomendLabel;

@end

@implementation HRPoiUserInfo
+ (CGFloat)heightForView
{
    return 0;
}

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
    self.porImageView = [[UIImageView alloc] init];
    [self addSubview:self.porImageView];
    
    self.userName = [[UILabel alloc] init];
    [self addSubview:self.userName];
    
    self.iconImageView = [[UIImageView alloc] init];
    self.iconImageView.image = [UIImage imageNamed:@"tuijian"];
    [self addSubview:self.iconImageView];
    
    self.recomendLabel = [[UILabel alloc] init];
    [self addSubview:self.recomendLabel];
}


@end

@interface HRPoiCreateInfoCell()

@end

@implementation HRPoiCreateInfoCell

+ (CGFloat)cellHeithForData:(id)data
{
    return 0;
}

@end

//
//  HRRecomendNotificationView.m
//  HRER
//
//  Created by kequ on 16/9/5.
//  Copyright © 2016年 linjunhou. All rights reserved.
//

#import "HRRecomendNotificationView.h"


@interface HRRecomendNotificationView()
@property(nonatomic,strong)UIImageView * bgImageView;

@end
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
    
    self.contentView.backgroundColor = UIColorFromRGB(0xebebeb);

    self.bgImageView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"comment"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 20, 0, 20)]];
    [self.contentView addSubview:self.bgImageView];
    [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.width.equalTo(self);
        make.centerY.equalTo(self);
    }];

    self.action = [[UIButton alloc] init];
    [self.contentView addSubview:self.action];
    [self.action mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.width.height.equalTo(self);
    }];
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated{}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated{}

@end

//
//  HRHotCityCell.m
//  HRER
//
//  Created by kequ on 16/7/28.
//  Copyright © 2016年 linjunhou. All rights reserved.
//

#import "HRHotCityCell.h"

@interface HRHotCityCell()

@property(nonatomic,strong)NSMutableArray * hotItems;
@property(nonatomic,strong)UILabel * hotTileLabel;
@property(nonatomic,strong)UIView * lineView;
@end

@implementation HRHotCityCell

+ (CGFloat)heightForCell
{
    CGFloat height = 15.f;
    height += 30.f; //title
    height += (36 * 2 + 10);
    height += 15.f;
    return height;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = RGBA(244, 246, 245, 1);
        [self initUI];
    }
    return self;
}

- (void)initUI
{
    
    self.hotTileLabel = [[UILabel alloc] init];
    self.hotTileLabel.font = [UIFont systemFontOfSize:14.f];
    self.hotTileLabel.text = @"热门城市";
    self.hotTileLabel.textColor = RGBA(0xa6, 0xa6, 0xa6, 1);
    [self.contentView addSubview:self.hotTileLabel];

    [self.hotTileLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(10);
        make.height.equalTo(@(30.f));
    }];
    
    self.lineView = [[UIView alloc] init];
    self.lineView.backgroundColor = RGBA(0xe8, 0xe8, 0xe8, 1);
    [self.contentView addSubview:self.lineView];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.hotTileLabel);
        make.left.equalTo(self.hotTileLabel.mas_right).offset(5);
        make.right.equalTo(self).offset(-10);
        make.height.equalTo(@(0.5));
    }];

    
    self.hotItems = [NSMutableArray arrayWithCapacity:0];
    
    CGFloat width = (([[UIScreen mainScreen] bounds].size.width - 10 - 20) - 16) / 3.f;
    CGFloat height = 36.f;
    CGSize size = CGSizeMake(width, height);
    CGFloat ySapce = 10.f;
    CGFloat xSapce = 8.f;
    for (int i = 0; i < 6; i++) {
        UIButton * button = [self creteOneButton];
        button.tag = i;
        [self.contentView addSubview:button];
        [self.hotItems addObject:button];
        
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(size);
            NSInteger section = i / 3;
            NSInteger row = i % 3 ;
            CGFloat x = 10 + row * (width + xSapce);
            CGFloat y = 45 + section * (height + ySapce);
            make.top.equalTo(@(y));
            make.left.equalTo(@(x));
        }];
    }
}

- (UIButton *)creteOneButton
{
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitleColor:RGBA(0x5c, 0x5b, 0x5b, 1) forState:UIControlStateNormal];
    [button setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateHighlighted];
    button.titleLabel.font = [UIFont systemFontOfSize:16.f];
    button.layer.cornerRadius = 2.f;
    button.layer.borderColor = RGBA(0xd7, 0xd7, 0xd7, 1).CGColor;
    button.layer.borderWidth = 0.5;
    [button setTitle:@"#" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonDidClick:) forControlEvents:UIControlEventTouchUpInside];
    button.backgroundColor = [UIColor whiteColor];
    return button;
}

- (void)setHotArray:(NSArray *)hotArray
{
    if (_hotArray == hotArray) {
        return;
    }
    
    _hotArray = hotArray;
    
    for (NSInteger i = 0; i < MIN(_hotArray.count, 6); i++) {
        NSDictionary * cityInfo = _hotArray[i];
        UIButton * button = self.hotItems[i];
        [button setTitle:[cityInfo objectForKey:@"city_name"] forState:UIControlStateNormal];
    }
}

#pragma mark - Action
- (void)buttonDidClick:(UIButton *)button
{
    if (button.tag < self.hotItems.count) {
        if ([_delegate respondsToSelector:@selector(hotCityCellDidSeletedHotCity:)]) {
            [_delegate hotCityCellDidSeletedHotCity:self.hotArray[button.tag]];
        }
    }
}

#pragma mark
- (void)setSelected:(BOOL)selected animated:(BOOL)animated{}
- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated{}
@end

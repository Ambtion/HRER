//
//  HRCityCell.m
//  HRER
//
//  Created by kequ on 16/7/28.
//  Copyright © 2016年 linjunhou. All rights reserved.
//

#import "HRCityCell.h"

@interface HRCityCell()

@property(nonatomic,strong)UILabel * nameLabel;
@property(nonatomic,strong)UIView * toplineView;
@property(nonatomic,strong)UIView * bottomLineView;

@end

@implementation HRCityCell

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
    self.nameLabel = [[UILabel alloc] init];
    self.nameLabel.font = [UIFont systemFontOfSize:14.f];
    self.nameLabel.textColor = RGBA(0x5c, 0x5b, 0x5b, 1);
    [self.contentView addSubview:self.nameLabel];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(10);
        make.centerY.equalTo(self);
        make.right.equalTo(self).offset(-20);
    }];
    
    self.toplineView = [[UIView alloc] init];
    self.toplineView.backgroundColor = RGBA(0xe2, 0xe2, 0xe2, 1);
    [self.contentView addSubview:self.toplineView];
    
    
    self.bottomLineView = [[UIView alloc] init];
    self.bottomLineView.backgroundColor = RGBA(0xe2, 0xe2, 0xe2, 1);
    [self.contentView addSubview:self.bottomLineView];

    [self.toplineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(10));
        make.right.equalTo(self).offset(-10);
        make.height.equalTo(@(0.5));
    }];
    
    [self.bottomLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(10));
        make.right.equalTo(self).offset(-10);
        make.bottom.equalTo(self);
        make.height.equalTo(@(0.5));
    }];

}

- (void)setCityInfo:(NSDictionary *)cityInfo
{
    if (_cityInfo == cityInfo) {
        return;
    }
    _cityInfo = cityInfo; 
    self.nameLabel.text = [NSString stringWithFormat:@"%@%@",[_cityInfo objectForKey:@"city_name"],[_cityInfo objectForKey:@"en_name"]];
}

- (void)setCellType:(CellPositionType)type
{
    switch (type) {
        case CellPositionTop:
        {
            [self.toplineView setHidden:NO];
            [self.bottomLineView setHidden:NO];
        }
            break;
        case CellPositionMiddle:
        {
            [self.toplineView setHidden:YES];
            [self.bottomLineView setHidden:NO];
        }
            break;
        case CellPositionBottom:
        {
            [self.toplineView setHidden:YES];
            [self.bottomLineView setHidden:NO];
        }
            break;
        case CellPositionFull:
        {
            [self.toplineView setHidden:NO];
            [self.bottomLineView setHidden:NO];
        }
        default:
            break;
    }
}

@end

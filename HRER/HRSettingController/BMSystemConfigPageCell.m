//
//  BMSystemConfigPageCell.m
//  BaiduMapGemini
//
//  Created by Adrain Sun on 7/29/13.
//  Copyright (c) 2013 BaiduLBSMapClient. All rights reserved.
//

#import "BMSystemConfigPageCell.h"
#import "HRSettingUserinfoCell.h"

@interface BMSystemConfigPageCell()
@property(nonatomic,strong)UIView * toplineView;
@property(nonatomic,strong)UIView * bottomLineView;
@property(nonatomic,strong)UIImageView * sperIcon;
@end

@implementation BMSystemConfigPageCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initUI];
    }
    return self;
}

- (void)initUI
{
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.font = [UIFont systemFontOfSize:16.f];
    self.titleLabel.textColor = RGBA(0x5c, 0x5c, 0x5c, 1);
    [self.contentView addSubview:self.titleLabel];
    
    self.subTtileLabel = [[UILabel alloc] init];
    self.subTtileLabel.font = [UIFont systemFontOfSize:14.f];
    self.subTtileLabel.textColor = RGBA(0x99, 0x99, 0x99, 1);
    [self.contentView addSubview:self.subTtileLabel];
    
    self.sperIcon = [[UIImageView alloc] init];
    self.sperIcon.image = [UIImage imageNamed:@"right"];
    [self.contentView addSubview:self.sperIcon];
    
    self.toplineView = [[UIView alloc] init];
    self.toplineView.backgroundColor = RGBA(0xe2, 0xe2, 0xe2, 1);
    [self.contentView addSubview:self.toplineView];
    
    
    self.bottomLineView = [[UIView alloc] init];
    self.bottomLineView.backgroundColor = RGBA(0xe2, 0xe2, 0xe2, 1);
    [self.contentView addSubview:self.bottomLineView];

    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(16.f);
        make.centerY.equalTo(self);
    }];
    
    [self.sperIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-18.f);
        make.centerY.equalTo(self);
    }];
    
    [self.subTtileLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.sperIcon.mas_left).offset(-11.f);
        make.centerY.equalTo(self);
    }];
    
    [self.toplineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.top.equalTo(self);
        make.width.equalTo(self);
        make.height.equalTo(@(0.5));
    }];
    
    [self.bottomLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel);
        make.right.equalTo(self.sperIcon);
        make.bottom.equalTo(self);
        make.height.equalTo(@(0.5));
    }];
}

- (void)setCellType:(CellPositionType)type
{
    
    [self.bottomLineView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel);
        make.right.equalTo(self.sperIcon);
        make.bottom.equalTo(self);
        make.height.equalTo(@(0.5));
    }];

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
            
            [self.bottomLineView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self);
                make.right.equalTo(self);
                make.bottom.equalTo(self);
                make.height.equalTo(@(0.5));
            }];

        }
            break;
        case CellPositionFull:
        {
            [self.toplineView setHidden:NO];
            [self.bottomLineView setHidden:NO];
            [self.bottomLineView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self);
                make.right.equalTo(self);
                make.bottom.equalTo(self);
                make.height.equalTo(@(0.5));
            }];

        }
        default:
            break;
    }
}

@end

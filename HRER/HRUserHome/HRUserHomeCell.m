//
//  HRUserHomeCell.m
//  HRER
//
//  Created by kequ on 16/7/19.
//  Copyright © 2016年 linjunhou. All rights reserved.
//

#import "HRUserHomeCell.h"

@interface HRUserHomeCell()

@property(nonatomic,strong)UILabel * mouthLabel;
@property(nonatomic,strong)UIImageView * mouthLine;
@property(nonatomic,strong)UIView * lineView;
@property(nonatomic,strong)UILabel * dayLabel;

@property(nonatomic,strong)UIImageView * contentBgView;
@property(nonatomic,strong)UIImageView * iconImageView;
@property(nonatomic,strong)UILabel * titleLabel;
@property(nonatomic,strong)UILabel * subTitle;

@property(nonatomic,strong)UIView * caterBgView;
@property(nonatomic,strong)UILabel * catergortLabel;


@end

@implementation HRUserHomeCell

+ (CGFloat)heightForView
{
    CGFloat height = 0;
    height += 10.f;
    height += 70.f;
    height += 10.f;
    return height;
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
    self.mouthLabel = [[UILabel alloc] init];
    self.mouthLabel.font = [UIFont boldSystemFontOfSize:16.f];
    self.mouthLabel.textAlignment = NSTextAlignmentCenter;
    self.mouthLabel.textColor = RGB_Color(0x4c, 0x4c, 0x4c);
    [self.contentView addSubview:self.mouthLabel];
    
    self.mouthLine = [[UIImageView alloc] init];
    self.mouthLine.image = [UIImage imageNamed:@"day_fengexian"];
    [self.contentView addSubview:self.mouthLine];
    
    self.lineView = [[UIView alloc] init];
    self.lineView.backgroundColor = RGB_Color(0xe9, 0xe9, 0xe9);
    [self.contentView addSubview:self.lineView];
    
    self.dayLabel = [[UILabel alloc] init];
    self.dayLabel.textColor = [UIColor whiteColor];
    self.dayLabel.backgroundColor = RGB_Color(0xe4, 0x5f, 0x40);
    self.dayLabel.layer.cornerRadius = 10.5;
    self.dayLabel.textAlignment = NSTextAlignmentCenter;
    self.dayLabel.font = [UIFont systemFontOfSize:11.f];
    self.dayLabel.clipsToBounds = YES;
    [self.contentView addSubview:self.dayLabel];
    
    self.contentBgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"day_bg"]];
    [self.contentView addSubview:self.contentBgView];
    
    
    self.iconImageView = [[UIImageView alloc] init];
    [self.contentView addSubview:self.iconImageView];
    
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.font = [UIFont systemFontOfSize:15.f];
    self.titleLabel.textColor = RGB_Color(0x4c, 0x4c, 0x4c);
    [self.contentView addSubview:self.titleLabel];
    
    self.subTitle = [[UILabel alloc] init];
    self.subTitle.font = [UIFont systemFontOfSize:13.f];
    self.subTitle.textColor = RGB_Color(0xa6, 0xa6, 0xa6);
    [self.contentView addSubview:self.subTitle];
    
    self.caterBgView = [[UIView alloc] init];
    self.caterBgView.layer.cornerRadius = 4.f;
    self.caterBgView.clipsToBounds = YES;
    [self.contentView addSubview:self.caterBgView];

    
    self.catergortLabel = [[UILabel alloc] init];
    self.catergortLabel.textColor = [UIColor whiteColor];
    self.catergortLabel.font = [UIFont systemFontOfSize:12.f];
    [self.contentView addSubview:self.catergortLabel];

    [self.contentBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(47.f);
        make.top.equalTo(self).offset(10);
        make.right.equalTo(self).offset(-10);
        make.bottom.equalTo(self).offset(-10);
    }];
    
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentBgView).offset(12.f);
        make.size.mas_equalTo(CGSizeMake(50.f, 50.f));
        make.centerY.equalTo(self.contentBgView);
    }];
    
    
    [self.caterBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentBgView).offset(-10.f);
        make.centerY.equalTo(self.titleLabel);
        make.height.equalTo(self.catergortLabel);
    }];
    
    [self.catergortLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.caterBgView).offset(3.f);
        make.right.equalTo(self.caterBgView).offset(-3.f);
        make.centerY.equalTo(self.caterBgView);
    }];

    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImageView.mas_right).offset(8.f);
        make.top.equalTo(self.iconImageView);
        make.right.lessThanOrEqualTo(self.caterBgView.mas_left).offset(-10);
    }];

    [self.subTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(7.f);
        make.right.equalTo(self.caterBgView).offset(-3.f);
    }];
    
    //左边线
    [self.mouthLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.left.equalTo(@(7.f));
        make.width.equalTo(@(50.f));
        make.height.equalTo(@(20));
    }];
    
    [self.dayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(21, 21.f));
        make.centerX.equalTo(self.mouthLabel);
    }];
    
    [self.mouthLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mouthLabel.mas_bottom);
        make.centerX.equalTo(self.mouthLabel);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mouthLine.mas_bottom);
        make.width.equalTo(@(0.5));
        make.centerX.equalTo(self.mouthLabel);
        make.bottom.equalTo(self);
    }];
    
}

- (void)setDatsSource:(id)datsSource
{
    
    self.mouthLabel.text = @"06";
    self.dayLabel.text = @"22";
    self.iconImageView.backgroundColor = [UIColor greenColor];
    self.titleLabel.text = @"CJ推荐了 张家驴肉火烧";
    self.subTitle.text = @"火烧都是现在做的，驴肉都都特别棒";
    self.catergortLabel.text = @"美食";
    
    //    颜色酒店：#fbb33a    购物：#3bc4ba    观光：#43a2fe    美食：#dc4630
    self.caterBgView.backgroundColor = RGB_Color(0xfb, 0xb3, 0x3a);

}

- (void)setCellStation:(KCellStation)station
{
    switch (station) {
        case KCellstationTop:
        {
            [self.mouthLabel setHidden:NO];
            [self.mouthLine setHidden:NO];
            [self.lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.mouthLine.mas_bottom);
                make.width.equalTo(@(0.5));
                make.centerX.equalTo(self.mouthLabel);
                make.bottom.equalTo(self);
            }];

        }
            break;
        case KCellstationMiddle:
        {
            [self.mouthLabel setHidden:YES];
            [self.mouthLine setHidden:YES];
            [self.lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self);
                make.width.equalTo(@(0.5));
                make.centerX.equalTo(self.mouthLabel);
                make.bottom.equalTo(self);
            }];
        }
            break;

        case KCellstationBottom:
        {
            {
                [self.mouthLabel setHidden:YES];
                [self.mouthLine setHidden:YES];
                [self.lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(self);
                    make.width.equalTo(@(0.5));
                    make.centerX.equalTo(self.mouthLabel);
                    make.bottom.equalTo(self.dayLabel.mas_centerY);
                }];
            }

        }
            break;
        case KCellstationFull:
        {
            {
                [self.mouthLabel setHidden:NO];
                [self.mouthLine setHidden:NO];
                [self.lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(self.mouthLine.mas_bottom);
                    make.width.equalTo(@(0.5));
                    make.centerX.equalTo(self.mouthLabel);
                    make.bottom.equalTo(self.dayLabel.mas_centerY);
                }];
            }

        }
            break;
        default:
            break;
    }
}

- (void)onClickDetail:(id)sender
{
    if ([_delegate respondsToSelector:@selector(userHomeCellDidClickDetalInfo:)]) {
        [_delegate userHomeCellDidClickDetalInfo:self];
    }
}

#pragma mark 
- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated{}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated{}
@end

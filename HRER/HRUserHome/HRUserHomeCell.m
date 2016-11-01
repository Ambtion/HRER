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
    self.caterBgView.layer.cornerRadius = 7.f;
    self.caterBgView.clipsToBounds = YES;
    [self.contentView addSubview:self.caterBgView];

    
    self.catergortLabel = [[UILabel alloc] init];
    self.catergortLabel.textColor = [UIColor whiteColor];
    self.catergortLabel.font = [UIFont systemFontOfSize:12.f];
    [self.contentView addSubview:self.catergortLabel];

    [self.contentBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(47.f);
        make.top.equalTo(self.contentView).offset(10);
        make.right.equalTo(self.contentView).offset(-10);
        make.bottom.equalTo(self.contentView).offset(-10);
    }];
    
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentBgView).offset(18.f);
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
        make.width.priorityLow();
    }];

    [self.subTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(7.f);
        make.right.equalTo(self.caterBgView).offset(-3.f);
    }];
    
    //左边线
    [self.mouthLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView);
        make.left.equalTo(@(7.f));
        make.width.equalTo(@(50.f));
        make.height.equalTo(@(20));
    }];
    
    [self.dayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
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
        make.bottom.equalTo(self.contentView);
    }];
    
}

- (void)setDataSource:(HRPOIInfo *)dataSource
{
    
    if (_dataSource == dataSource) {
        return;
    }
    _dataSource = dataSource;
    if (dataSource.ctimeStr.length) {
        NSArray * array = [dataSource.ctimeStr componentsSeparatedByString:@"-"];
        if (array.count == 3) {
            self.mouthLabel.text = [array objectAtIndex:1];
            self.dayLabel.text = [array objectAtIndex:2];
        }
    }
    self.titleLabel.text = dataSource.title;
    self.subTitle.text = dataSource.intro;
    self.catergortLabel.text = dataSource.typeName;
    
    switch (dataSource.type) {
        case 0:
            break;
        case 1:
            self.caterBgView.backgroundColor = UIColorFromRGBA(0xdc4630, 1);
            break;
        case 2:
            self.caterBgView.backgroundColor = UIColorFromRGBA(0x43a2fe, 1);
            
            break;
        case 3:
            self.caterBgView.backgroundColor = RGB_Color(0x3b, 0xc4, 0xba);
            break;
        case 4:
            self.caterBgView.backgroundColor = RGB_Color(0xfb, 0xb3, 0x3a);
            break;
        default:
            break;
    }
    
    //    颜色酒店：#fbb33a    购物：#3bc4ba    观光：#43a2fe    美食：#dc4630
    self.caterBgView.backgroundColor = [self caterColorWithType:dataSource.type];

    if (_dataSource.photos.count) {
        HRPotoInfo * photo = [_dataSource.photos firstObject];
        [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:photo.url] placeholderImage:[self imageForType:_dataSource.type]];
    }else{
        self.iconImageView.image = [self imageForType:_dataSource.type];
    }
}

- (UIImage *)imageForType:(NSInteger)type
{
    switch (type) {
        case 1:
            return [UIImage imageNamed:@"not_loaded_food"];
            break;
        case 2:
            return [UIImage imageNamed:@"not_loaded_lookShop"];
        case 3:
            return [UIImage imageNamed:@"not_loaded_yule"];
        case 4:
            return [UIImage imageNamed:@"not_loaded_hotel"];
        default:
            break;
    }
    return [UIImage imageNamed:@"not_loaded"];
}



- (UIColor *)caterColorWithType:(NSInteger)type
{
    NSArray * colorArray  = @[
                              RGB_Color(0xdc, 0x46, 0x30),
                              RGB_Color(0x43, 0xa2, 0xf3),
                              RGB_Color(0x3b, 0xc4, 0xba),
                              RGB_Color(0xfb, 0xb3, 0x3a)
                              ];
    if (type -1 >= 0 && type -1 < colorArray.count) {
        return colorArray[type -1];
    }
    return [UIColor clearColor];
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
    if ([_adelegate respondsToSelector:@selector(userHomeCellDidClickDetalInfo:)]) {
        [_adelegate userHomeCellDidClickDetalInfo:self];
    }
}

- (void)rightButtonAction
{

}

#pragma mark 
- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated{}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated{}
@end

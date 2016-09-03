//
//  PoiRecomendCell.m
//  HRER
//
//  Created by quke on 16/7/26.
//  Copyright © 2016年 linjunhou. All rights reserved.
//

#import "PoiRecomendCell.h"

@interface PoiRecomendCell()

@property(nonatomic,strong)UIView * bgView;
@property(nonatomic,strong)UIImageView * porImageView;
@property(nonatomic,strong)UILabel * nameLabel;
@property(nonatomic,strong)UILabel * recomendLabel;
@property(nonatomic,strong)UILabel * timeLabel;
@property(nonatomic,strong)UILabel * poiTitleLabel;

@property(nonatomic,strong)UIImageView * locIconView;
@property(nonatomic,strong)UILabel * locLabel;

@end

@implementation PoiRecomendCell

+ (CGFloat)heightForCell
{
    CGFloat heigth =  94.f;
    heigth += 8;
    return heigth;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self  initUI];
    }
    return self;
}

- (void)initUI
{
    
    self.contentView.backgroundColor = RGB_Color(0xec, 0xec, 0xec);
    
    self.bgView = [[UIView alloc] init];
    self.bgView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:self.bgView];
    
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView);
        make.width.equalTo(self.contentView);
        make.bottom.equalTo(self.contentView).offset(-8.f);
        make.top.equalTo(self.contentView);
    }];
    
    
    self.porImageView = [[UIImageView alloc] init];
    self.porImageView.layer.cornerRadius = 25.f;
    self.porImageView.layer.masksToBounds = YES;
    [self.bgView addSubview:self.porImageView];
    
    self.nameLabel = [[UILabel alloc] init];
    self.nameLabel.font = [UIFont systemFontOfSize:16.f];
    self.nameLabel.textColor = RGB_Color(0x4e, 0x4e, 0x4e);
    [self.bgView addSubview:self.nameLabel];
    
    
    self.poiTitleLabel = [[UILabel alloc] init];
    self.poiTitleLabel.font = [UIFont systemFontOfSize:14.f];
    self.poiTitleLabel.textColor = RGB_Color(0xf8, 0x61, 0x36);
    self.poiTitleLabel.textAlignment = NSTextAlignmentRight;
    [self.bgView addSubview:self.poiTitleLabel];
    
    self.recomendLabel = [[UILabel alloc] init];
    self.recomendLabel.font = [UIFont systemFontOfSize:12.f];
    self.recomendLabel.textColor = RGB_Color(0x5c, 0x5c, 0x5c);
    [self.bgView addSubview:self.recomendLabel];
    
    self.timeLabel = [[UILabel alloc] init];
    self.timeLabel.font = [UIFont systemFontOfSize:10.f];
    self.timeLabel.textColor  = RGB_Color(0xb5, 0xb5, 0xb5);
    [self.bgView addSubview:self.timeLabel];
    
    self.locIconView = [[UIImageView alloc] init];
    self.locIconView.image = [UIImage imageNamed:@"km"];
    [self addSubview:self.locIconView];
    
    self.locLabel = [[UILabel alloc] init];
    self.locLabel.font = [UIFont systemFontOfSize:12.f];
    self.locLabel.textColor = RGB_Color(0xb5, 0xb5, 0xb5);
    [self addSubview:self.locLabel];
    
    [self.porImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bgView).offset(16.f);
        make.left.equalTo(self.bgView).offset(11.f);
        make.size.mas_equalTo(CGSizeMake(50, 50));
    }];

    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.porImageView.mas_right).offset(15.f);
        make.top.equalTo(self.bgView).offset(20.f);
        make.height.equalTo(@(14.f));
        make.right.lessThanOrEqualTo(self.poiTitleLabel.mas_left);
    }];
    
    [self.poiTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.bgView).offset(-11);
        make.centerY.equalTo(self.nameLabel);
    }];
    
    [self.recomendLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel);
        make.height.equalTo(@(12.f));
        make.top.equalTo(self.nameLabel.mas_bottom).offset(12.f);
        make.right.lessThanOrEqualTo(self.locIconView.mas_left);
    }];
    
    [self.locLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.poiTitleLabel);
        make.centerY.equalTo(self.recomendLabel);
        make.height.equalTo(@(12.f));
    }];
    
    [self.locIconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.locLabel.mas_left).offset(-5);
        make.centerY.equalTo(self.locLabel);
        make.size.mas_equalTo(CGSizeMake(12 * 0.8, 15 * 0.8));
    }];

    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.recomendLabel.mas_bottom).offset(10.f);
        make.left.equalTo(self.recomendLabel);
        make.height.equalTo(@(10.f));
    }];

    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(fullViewTap:)];
    [self addGestureRecognizer:tap];
    
    tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userPortDidClick:)];
    [self.porImageView setUserInteractionEnabled:YES];
    [self.porImageView addGestureRecognizer:tap];
    
}

- (void)setDataSource:(HRRecomendDetail *)dataSource
{
    if (_dataSource == dataSource) {
        return;
    }
    _dataSource = dataSource;
    [self.porImageView sd_setImageWithURL:[NSURL URLWithString:dataSource.portrait] placeholderImage:[UIImage imageNamed:@"man"]];
    self.nameLabel.text = dataSource.user_name;
    self.poiTitleLabel.text = dataSource.title;
    self.recomendLabel.text = dataSource.content;
    self.timeLabel.text = dataSource.time;
    self.locLabel.text = dataSource.city_name;
}

#pragma mark - Action
- (void)fullViewTap:(UITapGestureRecognizer *)tap
{
    if ([_delegate respondsToSelector:@selector(poiRecomendCellDidClickDetailPage:)]) {
        [_delegate poiRecomendCellDidClickDetailPage:self];
    }
}


- (void)userPortDidClick:(id)sender
{
    if ([_delegate respondsToSelector:@selector(poiRecomendCellDidClickPortrait:)]) {
        [_delegate poiRecomendCellDidClickPortrait:self];
    }
}


#pragma mark -
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {}
- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated{}
@end

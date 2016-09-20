//
//  HomeHeadView.m
//  HRER
//
//  Created by kequ on 16/6/9.
//  Copyright © 2016年 linjunhou. All rights reserved.
//

#import "HomeHeadView.h"
#import "HRCatergoryScrollView.h"


@interface HomeHeadView()<HRCatergoryScrollViewDelegate>

@property(nonatomic,strong)HRCatergoryScrollView * catergoryView;
@property(nonatomic,strong)UIImageView * iconImageView;
@property(nonatomic,strong)UIImageView * subBgView;

@end

@implementation HomeHeadView

+ (CGFloat)heightForHeadCell
{
    return 236;
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
    
    self.subBgView = [[UIImageView alloc] init];
    self.subBgView.image = [UIImage imageNamed:@"poi_sub_bg"];
    [self.contentView addSubview:self.subBgView];
    
    self.bgImageView = [[UIImageView alloc] init];
    [self.contentView addSubview:self.bgImageView];
    
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.font = [UIFont systemFontOfSize:24.f];
    self.titleLabel.textColor = [UIColor whiteColor];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;

    [self.contentView addSubview:self.titleLabel];
    
//    self.iconImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"home_head_down"]];
//    [self.contentView addSubview:self.iconImageView];
    
    self.mainLabel = [[UILabel alloc] init];
    self.mainLabel.font = [UIFont systemFontOfSize:30.f];
    self.mainLabel.textColor = RGBA_Color(0xff, 0xff, 0xff, 0.2);
    self.mainLabel.textAlignment = NSTextAlignmentCenter;

    [self.contentView addSubview:self.mainLabel];
    
    
    self.totalCountLabel = [[UILabel alloc] init];
    self.totalCountLabel.font = [UIFont boldSystemFontOfSize:35.f];
    self.totalCountLabel.textColor = [UIColor whiteColor];
    self.totalCountLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:self.totalCountLabel];
    
    self.catergoryView = [[HRCatergoryScrollView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, 67)];
    self.catergoryView.delegate = self;
    [self.contentView addSubview:self.catergoryView];

    [self.catergoryView setButtonSeletedAtIndex:0];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.subBgView.frame = self.bounds;
    self.bgImageView.frame = self.bounds;
    
    
    [self.titleLabel sizeToFit];
//    [self.iconImageView sizeToFit];
    self.titleLabel.frame = CGRectMake((self.width - self.titleLabel.width)/2.f, 32, self.titleLabel.width, 26);
//    self.iconImageView.frame = CGRectMake(self.titleLabel.right + 5, 0, self.iconImageView.width, self.iconImageView.height);
//    self.iconImageView.centerY = self.titleLabel.centerY;
    
    self.mainLabel.frame = CGRectMake(0, 72, self.width, 30);
    self.totalCountLabel.frame = CGRectMake(0, self.mainLabel.bottom + 6, self.width, 35);
    self.catergoryView.frame = CGRectMake(0, self.bottom - 10 - self.catergoryView.height, self.catergoryView.width, self.catergoryView.height);
}

- (void)setcatergortCount:(NSArray *)countArray
{
    for (int i = 0; i < countArray.count; i++) {
        [self.catergoryView setCount:[countArray[i] intValue] atIndex:i];
    }
}

- (void)hrCatergoryScrollViewDidCancelSeleted:(HRCatergoryScrollView *)view
{
    if ([_delegate respondsToSelector:@selector(homeHeadViewDidCancelSeleted:)]) {
        [_delegate homeHeadViewDidCancelSeleted:self];
    }
}

- (void)hrCatergoryScrollView:(HRCatergoryScrollView *)view DidSeletedIndex:(NSInteger)index
{
    if ([_delegate respondsToSelector:@selector(homeHeadView:DidSeletedIndex:)]) {
        [_delegate homeHeadView:self DidSeletedIndex:index];
    }
}

- (void)setButtonSeletedAtIndex:(NSInteger)index
{
    [self.catergoryView setButtonSeletedAtIndex:index];
}
@end

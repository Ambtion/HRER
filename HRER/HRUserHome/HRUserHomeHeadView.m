//
//  HRUserHomeHeadView.m
//  HRER
//
//  Created by kequ on 16/7/18.
//  Copyright © 2016年 linjunhou. All rights reserved.
//

#import "HRUserHomeHeadView.h"
#import "HRUserHomeInfoCardView.h"
#import "HRUserHomeCaterInfoView.h"

@interface HRUserHomeHeadView()<HRUserHomeInfoCardViewDelegate,HRUserHomeCaterInfoViewDelegate>

@property(nonatomic,strong)UIImageView * bgImageView;

@property(nonatomic,strong)HRUserHomeInfoCardView * carView;
@property(nonatomic,strong)HRUserHomeCaterInfoView * caterInfoView;

@end

@implementation HRUserHomeHeadView

+ (CGFloat)heightForView
{
    return 523.f;
    
    CGFloat height = 0.f;
    height += [HRUserHomeInfoCardView heightForView];
    height += [HRUserHomeCaterInfoView heigthForView];
    return height;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUserInteractionEnabled:YES];
        [self initUI];
    }
    return self;
}

- (void)initUI
{
    
    self.image = [UIImage imageNamed:@"home_bg.jpg"];
    
    self.bgImageView = [[UIImageView alloc] init];
    self.bgImageView.image = [UIImage imageNamed:@"image_bg"];
    [self addSubview:self.bgImageView];
    
    
    [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(15.f);
        make.left.equalTo(self).offset(10.f);
        make.right.equalTo(self).offset(-10.f);
    }];
    
    self.carView = [[HRUserHomeInfoCardView alloc] init];
    self.carView.delegate = self;
    [self addSubview:self.carView];
    
    [self.carView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.width.equalTo(self.bgImageView);
        make.top.equalTo(self.bgImageView).offset(30.f);
        make.height.equalTo(@([HRUserHomeInfoCardView heightForView]));
    }];
    
    self.caterInfoView = [[HRUserHomeCaterInfoView alloc] init];
    self.caterInfoView.delegate = self;
    [self addSubview:self.caterInfoView];
    [self.caterInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.width.equalTo(self);
        make.top.equalTo(self.carView.mas_bottom);
        make.height.equalTo(@([HRUserHomeCaterInfoView heigthForView]));
    }];
    
}

- (void)setDataSource:(HRUserHomeInfo *)dataSource
{
    if (_dataSource == dataSource) {
        return;
    }
    _dataSource = dataSource;
    [self.carView setDataSource:dataSource];
    [self.caterInfoView setDataSource:dataSource];
}

- (void)setSeltedAtIndex:(NSInteger)index
{
    [self.caterInfoView setSeletedAtIndex:index];
}

- (NSInteger)seltedIndex
{
    return [self.caterInfoView seletedIndex];
}

#pragma mark Action
- (void)userHomeInfoCardViewDidClickRightButton:(UIButton *)button
{
    if ([_delegate respondsToSelector:@selector(userHomeHeadView:DidClickRightButton:)]) {
        [_delegate userHomeHeadView:self DidClickRightButton:button];
    }
}

- (void)userHomeInfoCardViewDidClickDetail:(HRUserHomeInfoCardView *)view
{
    if ([_delegate respondsToSelector:@selector(userHomeHeadViewDidClickDetail:)]) {
        [_delegate userHomeHeadViewDidClickDetail:self];
    }
}

- (void)userHomeCaterSwithButtonDidClick:(HRUserHomeCaterInfoView *)view
{
    if ([_delegate respondsToSelector:@selector(userHomeHeadViewDidClickSwitchButton:)]) {
        [_delegate userHomeHeadViewDidClickSwitchButton:self];
    }
}

- (void)userHomeCaterInfoViewDidSeletedIndex:(NSInteger)index
{
    if ([_delegate respondsToSelector:@selector(userHomeHeadView:DidClickCateAtIndex:)]) {
        [_delegate userHomeHeadView:self DidClickCateAtIndex:index];
    }
}

- (void)userHomeCaterInfoViewDidCancelSeleted:(HRUserHomeCaterInfoView *)view
{
    if ([_delegate respondsToSelector:@selector(userHomeHeadViewDidCancelSeletedButton:)]) {
        [_delegate userHomeHeadViewDidCancelSeletedButton:self];
    }
}

@end

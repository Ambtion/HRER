//
//  HRUserHomeHeadView.m
//  HRER
//
//  Created by kequ on 16/7/18.
//  Copyright © 2016年 linjunhou. All rights reserved.
//

#import "HRUserHomeMapHeadView.h"
#import "HRUserHomeMapInfoCardView.h"
#import "HRUserHomeMapCaterInfoView.h"

@interface HRUserHomeMapHeadView()<HRUserHomeMapInfoCardViewDelegate,HRUserHomeMapCaterInfoMapViewDelegate>


@property(nonatomic,strong)UIImageView * bgImageView;

@property(nonatomic,strong)HRUserHomeMapInfoCardView * carView;
@property(nonatomic,strong)HRUserHomeMapCaterInfoView * caterInfoView;

@end

@implementation HRUserHomeMapHeadView

+ (CGFloat)heightForView
{
    CGFloat height = 0.f;
    height += [HRUserHomeMapInfoCardView heightForView];
    height += [HRUserHomeMapCaterInfoView heigthForView];
    return height;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initUI];
    }
    return self;
}

- (void)initUI
{
    self.bgImageView = [[UIImageView alloc] init];
    self.bgImageView.image = [UIImage imageNamed:@"image_bg"];
    [self addSubview:self.bgImageView];
    
    self.carView = [[HRUserHomeMapInfoCardView alloc] init];
    self.carView.delegate = self;
    [self addSubview:self.carView];
    
    self.caterInfoView = [[HRUserHomeMapCaterInfoView alloc] init];
    self.caterInfoView.delegate = self;
    [self addSubview:self.caterInfoView];
    
    [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self);
        make.left.right.equalTo(self);
    }];
    
    [self.carView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.width.equalTo(self);
        make.top.equalTo(self);
        make.height.equalTo(@([HRUserHomeMapInfoCardView heightForView]));
    }];
    
    [self.caterInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.width.equalTo(self);
        make.bottom.equalTo(self);
        make.height.equalTo(@([HRUserHomeMapCaterInfoView heigthForView]));
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

- (void)userHomeInfoCardViewDidClickDetail:(HRUserHomeMapInfoCardView *)view
{
    if ([_delegate respondsToSelector:@selector(userHomeHeadViewDidClickDetail:)]) {
        [_delegate userHomeHeadViewDidClickDetail:self];
    }
}

- (void)userHomeCaterSwithButtonDidClick:(HRUserHomeMapCaterInfoView *)view
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

- (void)userHomeCaterInfoViewDidCancelSeleted:(HRUserHomeMapCaterInfoView *)view
{
    if ([_delegate respondsToSelector:@selector(userHomeHeadViewDidCancelSeletedButton:)]) {
        [_delegate userHomeHeadViewDidCancelSeletedButton:self];
    }
}

@end

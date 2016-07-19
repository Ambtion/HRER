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

@interface HRUserHomeHeadView()


@property(nonatomic,strong)UIImageView * bgImageView;

@property(nonatomic,strong)HRUserHomeInfoCardView * carView;
@property(nonatomic,strong)HRUserHomeCaterInfoView * caterInfoView;

@end

@implementation HRUserHomeHeadView

+ (CGFloat)heightForView
{
    CGFloat height = 20.f;
    height += [HRUserHomeInfoCardView heightForView];
    height += [HRUserHomeCaterInfoView heigthForView];
    return height;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor blackColor];
        [self initUI];
    }
    return self;
}

- (void)initUI
{
    self.bgImageView = [[UIImageView alloc] init];
    [self addSubview:self.bgImageView];
    
    self.carView = [[HRUserHomeInfoCardView alloc] init];
    [self addSubview:self.carView];
    
    self.caterInfoView = [[HRUserHomeCaterInfoView alloc] init];
    [self addSubview:self.caterInfoView];
    
    [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self);
        make.left.right.equalTo(self);
    }];
    
    [self.carView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.width.equalTo(self);
        make.top.equalTo(self).offset(20.f);
        make.height.equalTo(@([HRUserHomeInfoCardView heightForView]));
    }];
    
    [self.caterInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.width.equalTo(self);
        make.bottom.equalTo(self);
        make.height.equalTo(@([HRUserHomeCaterInfoView heigthForView]));
    }];
    
}

- (void)setDataSource:(id)dataSource
{
    [self.carView setDataSource:nil];
    [self.caterInfoView setDataSource:nil];
}

@end

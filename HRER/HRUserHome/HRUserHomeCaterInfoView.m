//
//  HRUserHomeCaterInfoView.m
//  HRER
//
//  Created by quke on 16/7/19.
//  Copyright © 2016年 linjunhou. All rights reserved.
//

#import "HRUserHomeCaterInfoView.h"
#import "HRUserHomeInfoCardView.h"

@interface HRCategoryItemView : UIView
@property(nonatomic,strong)UILabel * valueLabel;
@property(nonatomic,strong)UILabel * titleLabel;
@property(nonatomic,assign,getter=isSeleted)BOOL seleted;
@end

@implementation HRCategoryItemView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.clipsToBounds = YES;
        [self initUI];
    }
    return self;
}

- (void)initUI
{
    self.valueLabel = [[UILabel alloc] init];
    self.valueLabel.font = [UIFont boldSystemFontOfSize:16.f];
    self.valueLabel.textAlignment = NSTextAlignmentCenter;
    self.valueLabel.textColor = [UIColor whiteColor];
    [self addSubview:self.valueLabel];
    
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.font = [UIFont systemFontOfSize:12.f];
    self.titleLabel.textColor = RGB_Color(0xcc, 0xcc, 0xcc);
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.titleLabel];
    
    [self.valueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.left.equalTo(self);
        make.width.equalTo(self);
        make.height.equalTo(@(16.f));
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.width.equalTo(self);
        make.height.equalTo(@(12.f));
        make.bottom.equalTo(self);
    }];
    
//    self.titleLabel.backgroundColor = [UIColor greenColor];
//    self.valueLabel.backgroundColor = [UIColor greenColor];
//    self.backgroundColor = [UIColor redColor];
}

- (void)setSeleted:(BOOL)isSeleted
{
    _seleted = isSeleted;
    
}

@end

@interface HRUserHomeCaterInfoView()
@property(nonatomic,strong)UIImageView * cityImageBgView;

@property(nonatomic,strong)HRUserHomeInfoCardView * cardView;
@property(nonatomic,strong)HRCategoryItemView * cityItemView;
@property(nonatomic,strong)NSArray * caterItemArray;

@property(nonatomic,strong)UIButton * switchButton;

@end

@implementation HRUserHomeCaterInfoView

+ (CGFloat)heigthForView
{
    CGFloat heigth = 50.f;
    return heigth;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initUI];
    }
    return self;
}

- (void)initUI
{
    self.cityImageBgView = [[UIImageView alloc] init];
    self.cityImageBgView.image = [UIImage imageNamed:@"userHome_city"];
    [self addSubview:self.cityImageBgView];
    
    [self.cityImageBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(16.f);
        make.top.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(38, 46.f));
    }];
    
    self.cityItemView = [[HRCategoryItemView alloc] init];
    self.cityItemView.titleLabel.text = @"城市";
    self.cityItemView.valueLabel.text = @"0";
    [self addSubview:self.cityItemView];
    
    [self.cityItemView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.cityImageBgView).offset(5);
        make.width.left.equalTo(self.cityImageBgView);
        make.height.equalTo(@(32));
    }];
    
    self.switchButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.switchButton setImage:[UIImage imageNamed:@"user_home_switch_change"] forState:UIControlStateNormal];
    [self.switchButton addTarget:self action:@selector(switchButtonDidClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.switchButton];
    
    [self.switchButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-10.f);
        make.centerY.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(25, 30.f));
    }];
        
    NSArray * array = @[
                        @"美食",
                        @"观光",
                        @"购物",
                        @"酒店"
                        ];
    
    CGFloat totalWidth = [[UIScreen mainScreen] bounds].size.width - 16 - 38 - 25 - 10;
    CGFloat itemWidth =  30.f;
    CGFloat itemHeight = 34.f;
    CGFloat xSpacing = (totalWidth - itemWidth * 4 ) /  5.f;
    
    UIView  * lastView = self.cityImageBgView;
    
    NSMutableArray * mArray = [NSMutableArray arrayWithCapacity:0];
    for (int i = 0; i < array.count; i++) {
        HRCategoryItemView * categoryView = [[HRCategoryItemView alloc] init];
        categoryView.titleLabel.text = array[i];
        categoryView.valueLabel.text = @"0";
        [self addSubview:categoryView];
        [mArray addObject:categoryView];
        
        [categoryView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(lastView.mas_right).offset(xSpacing);
            make.width.equalTo(@(itemWidth));
            make.height.equalTo(@(itemHeight));
            make.centerY.equalTo(self);

        }];
        
        lastView = categoryView;

    }
    self.caterItemArray = mArray;
  
}

- (void)setDataSource:(id)dataSource
{
    self.cityItemView.valueLabel.text = @"20";
    
}

- (void)setCatergoryCount:(NSInteger)count atIndex:(NSInteger)index
{
    HRCategoryItemView * view = self.caterItemArray[index];
    view.valueLabel.text = [NSString stringWithFormat:@"%ld",(long)count];
}

- (void)switchButtonDidClick:(UIButton *)button
{
    
}
@end

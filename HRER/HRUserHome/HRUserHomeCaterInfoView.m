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
    self.valueLabel.font = [UIFont boldSystemFontOfSize:15.f];
    self.valueLabel.textAlignment = NSTextAlignmentCenter;
    self.valueLabel.textColor = [UIColor whiteColor];
    [self addSubview:self.valueLabel];
    
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.font = [UIFont systemFontOfSize:11.f];
    self.titleLabel.textColor = RGB_Color(0xcc, 0xcc, 0xcc);
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.titleLabel];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.width.equalTo(self);
        make.height.equalTo(@(11.f));
        make.top.equalTo(self);
    }];
    
    [self.valueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self);
        make.left.equalTo(self);
        make.width.equalTo(self);
        make.height.equalTo(@(15.f));
    }];
    
 
    
//    self.titleLabel.backgroundColor = [UIColor greenColor];
//    self.valueLabel.backgroundColor = [UIColor greenColor];
//    self.backgroundColor = [UIColor redColor];
}

//- (void)setSeleted:(BOOL)isSeleted
//{
//    _seleted = isSeleted;
//    if(_seleted){
//        self.titleLabel.textColor = RGB_Color(0xd7, 0x47, 0x2a);
//        self.valueLabel.textColor = RGB_Color(0xd7, 0x47, 0x2a);
//    }else{
//        self.titleLabel.textColor = UIColorFromRGB(0xdb4d30);
//        self.valueLabel.textColor = UIColorFromRGB(0x4c4c4c);
//    }
//}

@end

@interface HRUserHomeCaterInfoView()

@property(nonatomic,strong)HRUserHomeInfoCardView * cardView;
@property(nonatomic,strong)HRCategoryItemView * cityItemView;
@property(nonatomic,strong)NSArray * caterItemArray;

@property(nonatomic,strong)UIButton * switchButton;

@end

@implementation HRUserHomeCaterInfoView

+ (CGFloat)heigthForView
{
    CGFloat heigth = 34.f;
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
    
    self.cityItemView = [[HRCategoryItemView alloc] init];
    self.cityItemView.titleLabel.text = @"城市";
    self.cityItemView.valueLabel.text = @"0";
    self.cityItemView.titleLabel.textColor = UIColorFromRGB(0x4c4c4c);
    self.cityItemView.valueLabel.textColor = UIColorFromRGB(0x4c4c4c);
    [self.cityItemView setSeleted:NO];
    [self addSubview:self.cityItemView];
    
    
    self.switchButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.switchButton setImage:[UIImage imageNamed:@"user_home_switch_change"] forState:UIControlStateNormal];
    [self.switchButton addTarget:self action:@selector(switchButtonDidClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.switchButton];
    
    
    NSArray * array = @[
                        @"餐厅美食",
                        @"观光购物",
                        @"休闲娱乐",
                        @"酒店住宿"
                        ];
    
    NSArray * colorArray  = @[
                              RGB_Color(0xdc, 0x46, 0x30),
                              RGB_Color(0x43, 0xa2, 0xf3),
                              RGB_Color(0x3b, 0xc4, 0xba),
                              RGB_Color(0xfb, 0xb3, 0x3a)
                              ];
    
    CGFloat totalWidth = [[UIScreen mainScreen] bounds].size.width - 36 * 2 - 25.f;
    CGFloat itemWidth =  50.f;
    CGFloat itemHeight = 34.f;
    CGFloat xSpacing = (totalWidth - itemWidth * 5 ) /  6.f;
    
    
    [self.cityItemView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.left.equalTo(self).offset(26.f);
        make.width.equalTo(@(itemWidth));
        make.height.equalTo(@([HRUserHomeCaterInfoView heigthForView]));
    }];
    
    [self.switchButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-20.f);
        make.centerY.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(25, 30.f));
    }];

    
    UIView  * lastView = self.cityItemView;
    
    NSMutableArray * mArray = [NSMutableArray arrayWithCapacity:0];
    for (int i = 0; i < array.count; i++) {
        HRCategoryItemView * categoryView = [[HRCategoryItemView alloc] init];
        categoryView.titleLabel.text = array[i];
        categoryView.valueLabel.text = @"0";
        categoryView.titleLabel.textColor = colorArray[i];
        categoryView.valueLabel.textColor = colorArray[i];
        [self addSubview:categoryView];
        [mArray addObject:categoryView];
        
        [categoryView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(lastView.mas_right).offset(xSpacing);
            make.width.equalTo(@(itemWidth));
            make.height.equalTo(@(itemHeight));
            make.centerY.equalTo(self);

        }];
        
        
        lastView = categoryView;

//        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onSeletedIndex:)];
//        [categoryView addGestureRecognizer:tap];
    }
    self.caterItemArray = mArray;
  
}

#pragma mark Data
- (void)setDataSource:(HRUserHomeInfo *)dataSource
{
    
    self.cityItemView.valueLabel.text = [NSString stringWithFormat:@"%ld",(long)dataSource.city_num];
    [self setCatergoryCount:dataSource.food atIndex:0];
    [self setCatergoryCount:dataSource.tour atIndex:1];
    [self setCatergoryCount:dataSource.shop atIndex:2];
    [self setCatergoryCount:dataSource.hotel atIndex:3];
    
}

- (void)setCatergoryCount:(NSInteger)count atIndex:(NSInteger)index
{
    HRCategoryItemView * view = self.caterItemArray[index];
    view.valueLabel.text = [NSString stringWithFormat:@"%ld",(long)count];
}

#pragma mark Action

- (void)onSeletedIndex:(UITapGestureRecognizer *)tap
{
    HRCategoryItemView * itemView = (HRCategoryItemView *)tap.view;

    [self cancelAllSeltedButView:itemView];
    if ([itemView isSeleted]) {
        [itemView setSeleted:NO];
        if ([_delegate respondsToSelector:@selector(userHomeCaterInfoViewDidCancelSeleted:)]) {
            [_delegate userHomeCaterInfoViewDidCancelSeleted:self];
        }
    }else{
        [itemView setSeleted:YES];
        if ([_delegate respondsToSelector:@selector(userHomeCaterInfoViewDidSeletedIndex:)]) {
            [_delegate userHomeCaterInfoViewDidSeletedIndex:[self.caterItemArray indexOfObject:itemView]];
        }

    }
}

- (void)setSeletedAtIndex:(NSInteger)index
{
    
    [self cancelAllSeltedButView:nil];
    if(index >= 0 && index < self.caterItemArray.count){
        HRCategoryItemView * itemView = self.caterItemArray[index];
        [itemView setSeleted:YES];
    }
}

- (NSInteger)seletedIndex
{
    for (HRCategoryItemView * view in self.caterItemArray) {
        if (view.isSeleted) {
            return [self.caterItemArray indexOfObject:view];
        }
    }
    return 0;
}

- (void)cancelAllSeltedButView:(UIView *)view
{
    for (HRCategoryItemView * itemView in self.caterItemArray ) {
        if (view != itemView ) {
            [itemView setSeleted:NO];
        }
    }
}

- (void)switchButtonDidClick:(UIButton *)button
{
    if([_delegate respondsToSelector:@selector(userHomeCaterSwithButtonDidClick:)]){
        [_delegate userHomeCaterSwithButtonDidClick:self];
    }
}
@end

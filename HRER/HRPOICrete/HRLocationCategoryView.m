//
//  HRLocationCategoryView.m
//  HRER
//
//  Created by kequ on 16/7/20.
//  Copyright © 2016年 linjunhou. All rights reserved.
//

#import "HRLocationCategoryView.h"
#import "HRCreteCategoryItemView.h"


@interface HRLocationCategoryView()

@property(nonatomic,strong)UIImageView * iconView;
@property(nonatomic,strong)UILabel * titleLabel;


@property(nonatomic,strong)UIView * lineView;


@property(nonatomic,strong)NSArray * caterItemArray;


@end

@implementation HRLocationCategoryView

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
    
    self.lineView = [[UIView alloc] init];
    self.lineView.backgroundColor = RGB_Color(0xec, 0xec, 0xec);
    [self addSubview:self.lineView];

    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.right.equalTo(self);
        make.bottom.equalTo(self);
        make.height.equalTo(@(0.5));
    }];

    
    NSArray * array = @[
                        @"美食",
                        @"观光",
                        @"购物",
                        @"酒店"
                        ];
    
    //    颜色酒店：#fbb33a    购物：#3bc4ba    观光：#43a2fe    美食：#dc4630
    NSArray * colorArray  = @[
                              RGB_Color(0xdc, 0x46, 0x30),
                              RGB_Color(0x43, 0xa2, 0xf3),
                              RGB_Color(0x3b, 0xc4, 0xba),
                              RGB_Color(0xfb, 0xb3, 0x3a)
                              ];
    
    CGFloat itemWidth =  50.f;
    CGFloat itemHeight = 30.f;
    CGFloat xSpacing = 14.f;
    CGFloat offsetX =  ([[UIScreen mainScreen] bounds].size.width - itemWidth * 4 - xSpacing * 3)/2.f;
    
    UIView  * lastView = nil;
    
    
    
    NSMutableArray * mArray = [NSMutableArray arrayWithCapacity:0];
    for (int i = 0; i < array.count; i++) {
        HRCreteCategoryItemView * categoryView = [[HRCreteCategoryItemView alloc] init];
        categoryView.titleLabel.text = array[i];
        categoryView.textColor = colorArray[i];
        [categoryView setSeleted:NO];
        [self addSubview:categoryView];
        [mArray addObject:categoryView];
        
        [categoryView mas_makeConstraints:^(MASConstraintMaker *make) {
            if (lastView) {
                make.left.equalTo(lastView.mas_right).offset(xSpacing);
            }else{
                make.left.equalTo(@(offsetX));
            }
            make.width.equalTo(@(itemWidth));
            make.height.equalTo(@(itemHeight));
            make.centerY.equalTo(self).offset(-4);
        }];
        
        lastView = categoryView;
        
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onSeletedIndex:)];
        [categoryView addGestureRecognizer:tap];
    }
    self.caterItemArray = mArray;
    
    
//    self.iconView = [[UIImageView alloc] init];
//    [self addSubview:self.iconView];
//    
//    self.titleLabel = [[UILabel alloc] init];
//    self.titleLabel.font = [UIFont boldSystemFontOfSize:16.f];
//    self.titleLabel.textColor = RGB_Color(0x4d, 0x4d, 0x4d);
//    [self addSubview:self.titleLabel];
//
//    
//    CGFloat offset = 20;
//    [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self).offset(offset);
//        make.centerY.equalTo(self);
//        make.size.mas_equalTo(CGSizeMake(14, 14));
//    }];
//    
//    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.iconView.mas_right).offset(7.f);
//        make.top.height.equalTo(self);
//        make.width.equalTo(@(70));
//    }];
//
//
//    
//    NSArray * array = @[
//                        @"美食",
//                        @"观光",
//                        @"购物",
//                        @"酒店"
//                        ];
//    
//    //    颜色酒店：#fbb33a    购物：#3bc4ba    观光：#43a2fe    美食：#dc4630
//    NSArray * colorArray  = @[
//                              RGB_Color(0xdc, 0x46, 0x30),
//                              RGB_Color(0x43, 0xa2, 0xf3),
//                              RGB_Color(0x3b, 0xc4, 0xba),
//                              RGB_Color(0xfb, 0xb3, 0x3a)
//                              ];
//    
//    CGFloat itemWidth =  50.f;
//    CGFloat itemHeight = 30.f;
//    CGFloat offsetX =  10.f;
//    
//    CGFloat xSpacing = ([[UIScreen mainScreen] bounds].size.width - 110 - 10 - 20 - itemWidth * 4)/3.f;
//    
//    UIView  * lastView = nil;
//    
//    NSMutableArray * mArray = [NSMutableArray arrayWithCapacity:0];
//    for (int i = 0; i < array.count; i++) {
//        HRCreteCategoryItemView * categoryView = [[HRCreteCategoryItemView alloc] init];
//        categoryView.titleLabel.text = array[i];
//        categoryView.textColor = colorArray[i];
//        [categoryView setSeleted:NO];
//        [self addSubview:categoryView];
//        [mArray addObject:categoryView];
//        
//        [categoryView mas_makeConstraints:^(MASConstraintMaker *make) {
//            if (lastView) {
//                make.left.equalTo(lastView.mas_right).offset(xSpacing);
//            }else{
//                make.left.equalTo(self.titleLabel.mas_right).offset(offsetX);
//            }
//            make.width.equalTo(@(itemWidth));
//            make.height.equalTo(@(itemHeight));
//            make.centerY.equalTo(self).offset(-4);
//        }];
//        
//        lastView = categoryView;
//        
//        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onSeletedIndex:)];
//        [categoryView addGestureRecognizer:tap];
//    }
//    self.caterItemArray = mArray;
    
    
}

- (void)onSeletedIndex:(UITapGestureRecognizer *)tap
{
    [self cancelAllSelted];
    HRCreteCategoryItemView * itemView = (HRCreteCategoryItemView *)tap.view;
    [itemView setSeleted:YES];
    if ([_delegate respondsToSelector:@selector(locationCategoryViewDidSeletedIndex:)]) {
        [_delegate locationCategoryViewDidSeletedIndex:[self.caterItemArray indexOfObject:itemView]];
    }
}

- (void)setSeletedAtIndex:(NSInteger)index
{
    HRCreteCategoryItemView * itemView = self.caterItemArray[index];
    [self cancelAllSelted];
    [itemView setSeleted:YES];
}

- (NSInteger)seletedIndex
{
    for (HRCreteCategoryItemView * view in self.caterItemArray) {
        if (view.isSeleted) {
            return [self.caterItemArray indexOfObject:view];
        }
    }
    return 0;
}

- (void)cancelAllSelted
{
    for (HRCreteCategoryItemView * imtemView in self.caterItemArray ) {
        [imtemView setSeleted:NO];
    }
}


@end

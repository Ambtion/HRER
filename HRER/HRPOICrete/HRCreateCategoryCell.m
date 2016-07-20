//
//  HRCreateCategoryCell.m
//  HRER
//
//  Created by quke on 16/7/20.
//  Copyright © 2016年 linjunhou. All rights reserved.
//

#import "HRCreateCategoryCell.h"

@interface HRCreteCategoryItemView : UIView
@property(nonatomic,strong)UIImageView * bgView;
@property(nonatomic,strong)UILabel * titleLabel;
@property(nonatomic,strong)UIColor * textColor;
@property(nonatomic,assign,getter=isSeleted)BOOL seleted;
@end

@implementation HRCreteCategoryItemView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initUI];
        [self setSeleted:NO];
    }
    return self;
}

- (void)initUI
{
    self.bgView = [[UIImageView alloc] init];
    self.bgView.layer.cornerRadius = 15.f;
    [self addSubview:self.bgView];
    
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.font = [UIFont systemFontOfSize:14.f];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.titleLabel];
    
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
    }];
}

- (void)setSeleted:(BOOL)isSeleted
{
    _seleted = isSeleted;
    if(_seleted){
        self.bgView.backgroundColor = RGB_Color(0xdc, 0x46, 0x30);
        self.titleLabel.textColor = [UIColor whiteColor];
    }else{
        self.titleLabel.textColor = self.textColor;
        self.bgView.backgroundColor = [UIColor whiteColor];
    }
}


@end

@interface HRCreateCategoryCell()

@property(nonatomic,strong)NSArray * caterItemArray;

@end

@implementation HRCreateCategoryCell

+ (CGFloat)heightForCell
{
    return 50.f;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style  reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor =  RGB_Color(0xec, 0xec, 0xec);
        [self initUI];
    }
    return self;
}

- (void)initUI
{
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
}




- (void)onSeletedIndex:(UITapGestureRecognizer *)tap
{
    [self cancelAllSelted];
    HRCreteCategoryItemView * itemView = (HRCreteCategoryItemView *)tap.view;
    [itemView setSeleted:YES];
    if ([_delegate respondsToSelector:@selector(createCategoryCellDidSeletedIndex:)]) {
        [_delegate createCategoryCellDidSeletedIndex:[self.caterItemArray indexOfObject:itemView]];
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

#pragma mark - 
- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated{}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated{}
@end

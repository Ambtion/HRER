//
//  HRCreateCategoryCell.m
//  HRER
//
//  Created by quke on 16/7/20.
//  Copyright © 2016年 linjunhou. All rights reserved.
//

#import "HRCreateCategoryCell.h"
#import "HRCreteCategoryItemView.h"

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
                        @"餐厅美食",
                        @"观光购物",
                        @"休闲娱乐",
                        @"酒店住宿"
                        ];
//    颜色酒店：#fbb33a    购物：#3bc4ba    观光：#43a2fe    美食：#dc4630
    NSArray * colorArray  = @[
                              RGB_Color(0xdc, 0x46, 0x30),
                              RGB_Color(0x43, 0xa2, 0xf3),
                              RGB_Color(0x3b, 0xc4, 0xba),
                              RGB_Color(0xfb, 0xb3, 0x3a)
                              ];
    
    CGFloat itemWidth =  70.f;
    CGFloat itemHeight = 30.f;
    CGFloat xSpacing = 14.f;
    CGFloat offsetX =  ([[UIScreen mainScreen] bounds].size.width - itemWidth * 4 - xSpacing * 3)/2.f;

    UIView  * lastView = nil;
    
    
    
    NSMutableArray * mArray = [NSMutableArray arrayWithCapacity:0];
    for (int i = 0; i < array.count; i++) {
        HRCreteCategoryItemView * categoryView = [[HRCreteCategoryItemView alloc] init];
        categoryView.titleLabel.text = array[i];
        categoryView.tag = i;
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
    if(index < 0 || index > self.caterItemArray.count) return;
    
    HRCreteCategoryItemView * itemView = self.caterItemArray[index];
    [self cancelAllSelted];
    [itemView setSeleted:YES];
}

- (NSInteger)seletedIndex
{
    for (HRCreteCategoryItemView * view in self.caterItemArray) {
        if (view.seleted) {
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

//
//  HRCatergoryScrollView.m
//  HRER
//
//  Created by quke on 16/6/12.
//  Copyright © 2016年 linjunhou. All rights reserved.
//

#import "HRCatergoryScrollView.h"
#import "HRCatergoryItemView.h"

@interface HRCatergoryScrollView()

@property(nonatomic,strong)UIScrollView * scrollView;
@property(nonatomic,strong)NSMutableArray * itemArrays;

@end

@implementation HRCatergoryScrollView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initScrollView];
    }
    return self;
}


- (void)initScrollView
{
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    self.scrollView.showsHorizontalScrollIndicator = NO;
    [self addSubview:self.scrollView];

    
    UIImage * food = [UIImage imageNamed:@"food"];
    UIImage * foods = [UIImage imageNamed:@"food_select"];
    
    UIImage * look = [UIImage imageNamed:@"look"];
    UIImage * looks = [UIImage imageNamed:@"look_select"];
    
    UIImage * shopp = [UIImage imageNamed:@"shopping"];
    UIImage * shopps = [UIImage imageNamed:@"shopping_select"];
    
    UIImage * hotel = [UIImage imageNamed:@"hotel"];
    UIImage * hotels = [UIImage imageNamed:@"hotel_select"];
    
    UIImage * goWhere = [UIImage imageNamed:@"food"];
    UIImage * goWheres = [UIImage imageNamed:@"food_select"];
    
    
    NSArray * nImages = @[
                          food,
                          look,
                          shopp,
                          hotel,
                          goWhere
                          ];
    
    NSArray * hImages = @[
                          foods,
                          looks,
                          shopps,
                          hotels,
                          goWheres
                          ];
    
    self.itemArrays = [NSMutableArray arrayWithCapacity:5];
    
    CGFloat offsetX = 18.f;
    CGFloat spacingX = (self.width - 4 * 50 - offsetX * 2) / 3.f;
    CGFloat rightbouds = 0;
    for (int i = 0; i < 5; i ++) {
        
        HRCatergoryItemView * itemView = [[HRCatergoryItemView alloc] initWithFrame:CGRectMake(offsetX + (50 + spacingX) * i, 0, 50, self.height)];
        [itemView setCategoryImage:nImages[i] seletedImage:hImages[i] target:self seletor:@selector(buttonClick:) categoryNumber:0];
        itemView.imageButton.tag = i;
        [itemView.label setHidden:YES];
        [self.scrollView addSubview:itemView];
        [self.itemArrays addObject:itemView];
        rightbouds = itemView.right;
    }
    
    self.scrollView.contentSize = CGSizeMake(rightbouds + offsetX, self.scrollView.height);
}

- (void)setButtonSeletedAtIndex:(NSInteger)index
{
    for (HRCatergoryItemView * itemView in self.itemArrays) {
        [itemView.imageButton setSelected:NO];
    }
    
    if (index < self.itemArrays.count && index >= 0) {
        HRCatergoryItemView * itemView = (HRCatergoryItemView *)self.itemArrays[index];
        [itemView.imageButton setSelected:YES];
    }
}

- (void)buttonClick:(UIButton *)button
{
    
    for (HRCatergoryItemView * itemView in self.itemArrays) {
        if(button != itemView.imageButton)
            [itemView.imageButton setSelected:NO];
    }
    if(button.isSelected){
        if ([_delegate respondsToSelector:@selector(hrCatergoryScrollViewDidCancelSeleted:)]) {
            [_delegate hrCatergoryScrollViewDidCancelSeleted:self];
        }
    }else{
        [button setSelected:YES];
        if ([_delegate respondsToSelector:@selector(hrCatergoryScrollView:DidSeletedIndex:)]) {
            [_delegate hrCatergoryScrollView:self DidSeletedIndex:button.tag];
        }

    }
}

- (void)setCount:(NSInteger)count atIndex:(NSInteger)index
{
    if (index < self.itemArrays.count && index >= 0) {
        HRCatergoryItemView * itemView = (HRCatergoryItemView *)self.itemArrays[index];
        itemView.label.text = [NSString stringWithFormat:@"%ld",(long)count];
    }    
}

@end

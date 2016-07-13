//
//  HRPhotoScrollView.m
//  HRER
//
//  Created by kequ on 16/7/13.
//  Copyright © 2016年 linjunhou. All rights reserved.
//

#import "HRPhotoScrollView.h"

@interface HRPhotoScrollView()<UIScrollViewDelegate>

@property(nonatomic,strong)UIScrollView * scrollView;

@property(nonatomic,strong)UILabel * idLabel;

@property(nonatomic,strong)NSArray * imageArray;
@property(nonatomic,strong)NSArray * dataSource;

@end

@implementation HRPhotoScrollView
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
    self.scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    self.scrollView.pagingEnabled = YES;
    [self.scrollView setShowsHorizontalScrollIndicator:NO];
    self.scrollView.delegate = self;
    [self addSubview:self.scrollView];
    
    self.idLabel = [[UILabel alloc] init];
    self.idLabel.textColor = RGB_Color(0xc8, 0xc8, 0xc6);
    self.idLabel.font = [UIFont systemFontOfSize:12.f];
    self.idLabel.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
    self.idLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.idLabel];
    
//    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.size.equalTo(self);
//        make.top.left.equalTo(@(0));
//    }];
//    
//    [self.idLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.bottom.equalTo(self).offset(-15);
//    }];
    
}

- (void)setDataImages:(NSArray *)array
{
    [[self.scrollView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    self.dataSource = array;
    
    NSInteger count = array.count;
    count = 6;
    NSMutableArray * imagemArray = [NSMutableArray arrayWithCapacity:0];
    for (int i =0 ; i < count; i++) {
        UIImageView * imageView = [[UIImageView alloc] init];
        [self.scrollView addSubview:imageView];
        
        [imageView sd_setImageWithURL:[NSURL URLWithString:@"http://b.hiphotos.baidu.com/zhidao/pic/item/f636afc379310a5562bec3ceb64543a982261075.jpg"] placeholderImage:[UIImage imageNamed:@""]];
        [imagemArray addObject:imageView];
    }
    self.imageArray = imagemArray;
    self.idLabel.text = [NSString stringWithFormat:@"1/6"];

    [self setNeedsLayout];
}

- (void)layoutSubviews
{
    self.scrollView.frame = self.bounds;
    for (int i = 0; i < self.imageArray.count; i++) {
        UIImageView * imageView = self.imageArray[i];
        imageView.frame = CGRectMake(self.scrollView.width * i, 0, self.scrollView.width, self.scrollView.height);
    }
    [self.scrollView setContentSize:CGSizeMake(self.scrollView.width * self.imageArray.count, self.scrollView.height)];
    
    [self.idLabel sizeToFit];
    self.idLabel.width = self.idLabel.width + 20;
    self.idLabel.height = self.idLabel.height + 5;
    self.idLabel.layer.cornerRadius = self.idLabel.height /2.f;
    self.idLabel.clipsToBounds = YES;
    self.idLabel.frame = CGRectMake(self.width - self.idLabel.width - 10, self.height - self.idLabel.height - 10, self.idLabel.width, self.idLabel.height);
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSInteger curPage = floorf(([_scrollView contentOffset].x+ 161) / _scrollView.bounds.size.width);
    self.idLabel.text = [NSString stringWithFormat:@"%ld/%d",(long)curPage + 1,6];
}

@end

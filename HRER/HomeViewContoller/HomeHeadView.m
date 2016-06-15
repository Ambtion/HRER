//
//  HomeHeadView.m
//  HRER
//
//  Created by kequ on 16/6/9.
//  Copyright © 2016年 linjunhou. All rights reserved.
//

#import "HomeHeadView.h"
#import "HRCatergoryScrollView.h"


@interface HomeHeadView()<HRCatergoryScrollViewDelegate>

@property(nonatomic,strong)HRCatergoryScrollView * catergoryView;


@end

@implementation HomeHeadView

+ (CGFloat)heightForHeadCell
{
    return 236;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initUI];
    }
    return self;
}

- (void)initUI
{
    self.bgImageView = [[UIImageView alloc] init];
    [self.contentView addSubview:self.bgImageView];
    
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.font = [UIFont systemFontOfSize:24.f];
    self.titleLabel.textColor = [UIColor whiteColor];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;

    [self.contentView addSubview:self.titleLabel];
    
    self.mainLabel = [[UILabel alloc] init];
    self.mainLabel.font = [UIFont systemFontOfSize:30.f];
    self.mainLabel.textColor = RGBA_Color(0xff, 0xff, 0xff, 0.2);
    self.mainLabel.textAlignment = NSTextAlignmentCenter;

    [self.contentView addSubview:self.mainLabel];
    
    
    self.totalCountLabel = [[UILabel alloc] init];
    self.totalCountLabel.font = [UIFont boldSystemFontOfSize:35.f];
    self.totalCountLabel.textColor = [UIColor whiteColor];
    self.totalCountLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:self.totalCountLabel];
    
    self.catergoryView = [[HRCatergoryScrollView alloc] initWithFrame:CGRectMake(0, 0, self.width, 67)];
    self.catergoryView.delegate = self;
    [self.contentView addSubview:self.catergoryView];

    [self.catergoryView setButtonSeletedAtIndex:0];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.bgImageView.frame = self.bounds;
    
    self.titleLabel.frame = CGRectMake(0, 32, self.width, 26);
    self.mainLabel.frame = CGRectMake(0, 72, self.width, 30);
    self.totalCountLabel.frame = CGRectMake(0, self.mainLabel.bottom + 6, self.width, 35);
    self.catergoryView.frame = CGRectMake(0, self.bottom - 10 - self.catergoryView.height, self.catergoryView.width, self.catergoryView.height);
}

- (void)setcatergortCount:(NSArray *)countArray
{
    for (int i = 0; i < countArray.count; i++) {
        [self.catergoryView setCount:[countArray[i] intValue] atIndex:i];
    }
}

- (void)hrCatergoryScrollView:(HRCatergoryScrollView *)view DidSeletedIndex:(NSInteger)index
{
    if ([_delegate respondsToSelector:@selector(homeHeadView:DidSeletedIndex:)]) {
        [_delegate homeHeadView:self DidSeletedIndex:index];
    }
}

- (void)setButtonSeletedAtIndex:(NSInteger)index
{
    [self.catergoryView setButtonSeletedAtIndex:index];
}
@end

//
//  HRCatergoryScrollView.m
//  HRER
//
//  Created by quke on 16/6/12.
//  Copyright © 2016年 linjunhou. All rights reserved.
//

#import "HRCatergoryScrollView.h"

@interface HRCatergoryScrollView()
@property(nonatomic,strong)UIScrollView * scrollView;
@end

@implementation HRCatergoryScrollView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}


- (void)initScrollView
{
    self.scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;    
    [self addSubview:self.scrollView];

}


@end

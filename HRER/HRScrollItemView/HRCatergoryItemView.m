//
//  HRScrollItemView.m
//  HRER
//
//  Created by kequ on 16/6/9.
//  Copyright © 2016年 linjunhou. All rights reserved.
//

#import "HRCatergoryItemView.h"

@interface HRCatergoryItemView()



@end

@implementation HRCatergoryItemView

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
    self.imageButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.width, self.width)];
    [self addSubview:self.imageButton];
  
    self.label = [[UILabel alloc] initWithFrame:CGRectMake(0, self.imageButton.bottom + 6, self.width, self.height - self.imageButton.bottom - 6)];
    self.label.font = [UIFont systemFontOfSize:14.f];
    self.label.textColor = RGBA_Color(0xff, 0xff, 0xff, 0.8);
    self.label.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.label];
    
 
}

- (void)setCategoryImage:(UIImage *)image
            seletedImage:(UIImage *)simage
                  target:(id)target
                 seletor:(SEL)seletor
          categoryNumber:(NSInteger)count
{
    [self.imageButton setImage:image forState:UIControlStateNormal];
    [self.imageButton setImage:simage forState:UIControlStateSelected];
    [self.imageButton addTarget:target action:seletor forControlEvents:UIControlEventTouchUpInside];
    self.label.text = [NSString stringWithFormat:@"%ld",(long)count];
}

@end

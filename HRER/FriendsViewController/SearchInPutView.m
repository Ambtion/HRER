//
//  SearchInPutView.m
//  JewelryApp
//
//  Created by kequ on 15/5/3.
//  Copyright (c) 2015年 jewelry. All rights reserved.
//

#import "SearchInPutView.h"

@interface SearchInPutView()
@property(nonatomic,strong)UIView * borderbgView;
@property(nonatomic,strong)UIImageView * searchIconView;
@end

@implementation SearchInPutView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.clipsToBounds = YES;
//        self.layer.cornerRadius = 4.f;
//        self.layer.borderColor = [UIColor colorWithRed:222/255.f green:222/255.f blue:222/255.f alpha:1].CGColor;
//        self.layer.borderWidth = .5f;
        [self initSubViews];
    }
    return self;
}

- (void)initSubViews
{
    self.backgroundColor = RGB_Color(0xec, 0xec, 0xec);
    self.borderbgView = [[UIView alloc] init];
    self.borderbgView.backgroundColor = [UIColor whiteColor];
    self.borderbgView.clipsToBounds = YES;
    [self addSubview:self.borderbgView];
        
    self.textFiled = [[UITextField alloc] init];
    self.textFiled.backgroundColor = [UIColor clearColor];
    self.textFiled.textColor = [UIColor colorWithRed:0x31/255.f green:0x32/255.f blue:0x33/255.f alpha:1];
    self.textFiled.font = [UIFont systemFontOfSize:15.f];
    self.textFiled.returnKeyType = UIReturnKeyDone;
    self.textFiled.textAlignment = NSTextAlignmentLeft;
    
    NSMutableAttributedString * str = [[NSMutableAttributedString alloc] initWithString:@"查找朋友  输入朋友昵称或这里护照号"];
    
    UIFont * font1 = [UIFont systemFontOfSize:14.f];
    UIColor * color1 = RGB_Color(0x59, 0x59, 0x59);
    UIFont * font2 = [UIFont systemFontOfSize:12.f];
    UIColor * color2 = RGB_Color(0xb9, 0xb9, 0xb9);
    
    [str addAttribute:NSFontAttributeName value:font1 range:NSMakeRange(0, 4)];
    [str addAttribute:NSForegroundColorAttributeName value:color1 range:NSMakeRange(0, 4)];
    
    [str addAttribute:NSFontAttributeName value:font2 range:NSMakeRange(4, str.length - 4)];
    [str addAttribute:NSForegroundColorAttributeName value:color2 range:NSMakeRange(4, str.length - 4)];
    
    self.textFiled.attributedPlaceholder = str;
    [self.borderbgView addSubview:self.textFiled];
    
    self.textButton = [[UIButton alloc] init];
    self.textButton.backgroundColor = [UIColor clearColor];
    [self addSubview:self.textButton];
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    self.borderbgView.frame = CGRectMake(8, 8, self.width - 16, self.height - 16);
    self.borderbgView.layer.cornerRadius = 4.f;
    self.textFiled.frame = CGRectMake(6, 0, self.borderbgView.width - 12, self.borderbgView.height);
    self.textButton.frame = self.borderbgView.frame;
    
}

- (BOOL)textBecomeFirstResponder
{
    [self.textButton setUserInteractionEnabled:NO];
    return [self.textFiled becomeFirstResponder];
}

- (BOOL)textResignFirstResponder
{
    [self.textButton setUserInteractionEnabled:YES];
    return [self.textFiled resignFirstResponder];
}


@end

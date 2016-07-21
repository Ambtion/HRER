//
//  BaseAlertView.m
//  BaiduMapPad
//
//  Created by quke on 14-6-23.
//  Copyright (c) 2014年 Baidu. All rights reserved.
//

#import "BaseAlertView.h"

@interface BaseAlertView()

@property(nonatomic,strong)UIView * backGroudView;

@end

@implementation BaseAlertView


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if(self){
        
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self.backgroundColor = [UIColor clearColor];
        
        self.backGroudView = [[UIView alloc] initWithFrame:self.bounds];
        self.backGroudView.backgroundColor  = [[UIColor blackColor] colorWithAlphaComponent:0.4];
        self.backGroudView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self addSubview:self.backGroudView];
        
        
        self.contentView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.bounds) /2.f - 270, 64, 540, 628)];
        [self.contentView setUserInteractionEnabled:YES];
        self.contentView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
        
        self.contentView.backgroundColor = [UIColor colorWithRed:238.f/255 green:238.f/255 blue:238.f/255 alpha:1.f];
        self.contentView.layer.shadowColor = [[UIColor blackColor] CGColor];
        self.contentView.layer.cornerRadius = 5.f;
        self.contentView.clipsToBounds = YES;
        [self addSubview:self.contentView];
        
                
    }
    return self;
}

#pragma mark appear | disAppear

- (void)showInView:(UIView *)view completion:(void (^)(BOOL finished))completion
{
    
    self.contentView.frame = CGRectOffset(self.contentView.frame, 0, CGRectGetHeight(self.bounds));
    self.backGroudView.alpha = 0.f;
    [view addSubview:self];
    
    [UIView animateWithDuration:0.4 animations:^{
        self.contentView.frame = CGRectOffset(self.contentView.frame, 0, -CGRectGetHeight(self.bounds));
        self.backGroudView.alpha = 1.f;
    } completion:completion];
    
}

- (void)disAppear
{
    [UIView animateWithDuration:0.3  delay:0.f options:UIViewAnimationCurveEaseInOut animations:^{
        self.backGroudView.alpha = 0.f;
        self.contentView.frame = CGRectOffset(self.contentView.frame, 0, CGRectGetHeight(self.bounds));
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

@end

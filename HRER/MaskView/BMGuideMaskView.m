//
//  BMRouteHomeMaskView.m
//  basicmap
//
//  Created by quke on 16/1/13.
//  Copyright © 2016年 baidu. All rights reserved.
//

#import "BMGuideMaskView.h"

#define CONFIG_ROUTE_MASK_SHOWED     @"__CONFIG_ROUTE_MASK_SHOWED__"


@interface BMGuideMaskView()
@property(nonatomic,strong)UIImageView * imageView;
@property(nonatomic,assign)CGRect orinalRect;
@end

@implementation BMGuideMaskView

+(void)configShowOneceWithKey:(NSString *)key
{
    NSString * configKey = [NSString stringWithFormat:@"%@_%@",CONFIG_ROUTE_MASK_SHOWED,key];
    [[NSUserDefaults standardUserDefaults] setValue:@(1) forKey:configKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(BOOL)isAlreadyShowedWithKey:(NSString *)key
{
    NSString * configKey = [NSString stringWithFormat:@"%@_%@",CONFIG_ROUTE_MASK_SHOWED,key];
    return [[[NSUserDefaults standardUserDefaults] objectForKey:configKey] boolValue];
}

+ (void)showMaskViewWithKey:(NSString *)key  containerView:(UIView *)view image:(UIImage *)image imageViewRect:(CGRect)rect
{
    
    if ([self isAlreadyShowedWithKey:key]) {
        return;
    }
    if ([self isShowingInView:view]) {
        return;
    }
    if (CGRectEqualToRect(rect, CGRectZero)) {
        return ;
    }
    
    NSArray * arryView = [view subviews];
    UIView  * guideView = nil;
    for (UIView * subView in arryView) {
        if ([subView isKindOfClass:[BMGuideMaskView class]]) {
            guideView = subView;
            break;
        }
    }
    if (guideView) {
        [view bringSubviewToFront:guideView];
    }else{
        BMGuideMaskView * maskView = [[BMGuideMaskView alloc] initWithFrame:view.bounds];
        maskView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.8];
        maskView.orinalRect = rect;
        maskView.maskView.frame = view.bounds;
        maskView.imageView.frame = rect;
        maskView.imageView.image = image;
        [view addSubview:maskView];
        [self configShowOneceWithKey:key];
    }

}

+ (BOOL)isShowingInView:(UIView *)supverView
{
    for (UIView * view in supverView.subviews) {
        if ([view isKindOfClass:[self class]]) {
            return YES;
        }
    }
    return NO;
}

#pragma mark - touch
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [UIView animateWithDuration:0.3  delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}


#pragma mark - getMethod
- (UIImageView *)maskView
{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        _imageView.backgroundColor = [UIColor clearColor];
        [self addSubview:_imageView];
    }
    return _imageView;
}

@end

//
//  BMJWNagationController.m
//  JewelryApp
//
//  Created by kequ on 15/6/7.
//  Copyright (c) 2015年 jewelry. All rights reserved.
//

#import "HRNagationController.h"
#import "HRLoginViewController.h"

@interface HRNagationController()<UINavigationControllerDelegate,UIGestureRecognizerDelegate>
@property(nonatomic,assign)BOOL isAnimaiton;
@end

@implementation HRNagationController

- (id)initWithRootViewController:(UIViewController *)rootViewController
{
    self = [super initWithRootViewController:rootViewController];
    if (self) {
        
        [self.navigationBar setBarTintColor:[UIColor clearColor]];
        NSDictionary *textAttributes1 = @{NSFontAttributeName: [UIFont systemFontOfSize:16.f],
                                          NSForegroundColorAttributeName: [UIColor whiteColor]
                                          };
        [self.navigationBar setTitleTextAttributes:textAttributes1];
        [self.navigationBar setBackgroundImage:[UIImage imageNamed:@"NavigationBarBG"] forBarMetrics:UIBarMetricsDefault];
        [self.navigationBar setShadowImage:[UIImage imageNamed:@"NavigationBarBG"]];

        self.delegate = self;
        self.interactivePopGestureRecognizer.delegate = self;
        self.isAnimaiton = NO;
    }
    return self;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldBeRequiredToFailByGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if(self.isAnimaiton){
        return;
    }
    @try {
        if (self.viewControllers.count && ![viewController isKindOfClass:[HRLoginViewController class]]) {
            viewController.hidesBottomBarWhenPushed = YES;
        }
        [super pushViewController:viewController animated:animated];
        [viewController.navigationItem setHidesBackButton:YES];
        if (viewController.navigationItem.leftBarButtonItem == nil && [self.viewControllers count] >= 2)
            
        {
            viewController.navigationItem.leftBarButtonItems = @[[self barSpaingItem],[self createBackButton]];
        }
    }
    @catch (NSException *exception) {
        
    }
    @finally {
    }
}

- (UIViewController *)popViewControllerAnimated:(BOOL)animated
{
    if(self.isAnimaiton){
        return nil;
    }
    @try {
        UIViewController * controller = [super popViewControllerAnimated:animated];
        [controller.navigationItem setHidesBackButton:YES];
        return controller;
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
}

- (BOOL)isAnimaiton
{
    return _isAnimaiton;
}

- (NSArray *)popToRootViewControllerAnimated:(BOOL)animated
{
    if(self.isAnimaiton){
        return nil;
    }
    if ([[self topViewController] isKindOfClass:[HRLoginViewController class]]) {
        return nil;
    }
    return [super popToRootViewControllerAnimated:animated];
}

-(void)popself
{
    [self popViewControllerAnimated:YES];
}

-(UIBarButtonItem*) createBackButton
{
    CGRect backframe= CGRectMake(0, 0, 28, 28);
    UIButton* backButton= [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = backframe;
    [backButton setImage:[UIImage imageNamed:@"return"] forState:UIControlStateNormal];
    [backButton setImage:[UIImage imageNamed:@"return"] forState:UIControlStateHighlighted];
    [backButton addTarget:self action:@selector(popself) forControlEvents:UIControlEventTouchUpInside];
    //定制自己的风格的  UIBarButtonItem
    UIBarButtonItem* someBarButtonItem= [[UIBarButtonItem alloc] initWithCustomView:backButton];
    return someBarButtonItem;
    
}

- (UIBarButtonItem*)barSpaingItem
{
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                       
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       
                                       target:nil action:nil];
    negativeSpacer.width = -12;
    return negativeSpacer;
}


#pragma mark - 
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if(animated)
        self.isAnimaiton = YES;
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    self.isAnimaiton = NO;
}

@end

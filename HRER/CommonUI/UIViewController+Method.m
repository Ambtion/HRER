//
//  UIViewController+DivideAssett.m
//  SohuPhotoAlbum
//
//  Created by sohu on 13-4-27.
//  Copyright (c) 2013年 Qu. All rights reserved.
//

#import "UIViewController+Method.h"
#import <Accelerate/Accelerate.h>
#import "AppDelegate.h"
#import "UIImageView+WebCache.h"
#import "SDImageCache.h"
#import "ToastAlertView.h"
#import "RefreshTableView.h"
#import "HomeViewController.h"

@implementation UIViewController(Tips)
- (MBProgressHUD *)waitForMomentsWithTitle:(NSString*)str withView:(UIView *)view
{
    if (!view) {
        view = [[[UIApplication sharedApplication] delegate] window];
    }
    MBProgressHUD * progressView = [[MBProgressHUD alloc] initWithView:view];
    progressView.animationType = MBProgressHUDAnimationZoomOut;
    progressView.label.text = str;
    [view addSubview:progressView];
    [progressView showAnimated:YES];
    return progressView;
}

-(void)stopWaitProgressView:(MBProgressHUD *)view
{
    if (view){
        [view removeFromSuperview];
    }
    else{
        for (UIView * view in self.view.subviews) {
            if ([view isKindOfClass:[MBProgressHUD class]]) {
                [view removeFromSuperview];
            }
        }
        for (UIView * view in [[[UIApplication sharedApplication] delegate] window].subviews) {
            if ([view isKindOfClass:[MBProgressHUD class]]) {
                [view removeFromSuperview];
            }
        }
    }
        
}

- (void)showPopAlerViewWithMes:(NSString *)message withDelegate:(id<UIAlertViewDelegate>)delegate cancelButton:(NSString *)cancelTitle otherButtonTitles:(NSString *)otherButtonTitles, ...
{
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    UIAlertView * popA = [[UIAlertView alloc] initWithTitle:nil message:message delegate:delegate cancelButtonTitle:cancelTitle otherButtonTitles:otherButtonTitles, nil];
    [popA show];
#pragma clang disgnostic pop

}

- (void)showTotasViewWithMes:(NSString *)message
{
    if(!message || ![message isKindOfClass:[NSString class]] || ![message length]) return;
    ToastAlertView * alertView = [[ToastAlertView alloc] initWithTitle:message controller:self];
    [alertView show];
}

- (void)showPopAlerViewWithMes:(NSString *)message
{
    [self showPopAlerViewWithMes:message withDelegate:nil cancelButton:@"确定" otherButtonTitles:nil];
}

@end


@implementation UIView(Tips)

- (void)showTotasViewWithMes:(NSString *)message
{
    if(!message || ![message isKindOfClass:[NSString class]] || ![message length]) return;
    ToastAlertView * alertView = [[ToastAlertView alloc] initWithTitle:message view:self];
    [alertView show];

}
@end

@implementation UIViewController(Nav)

- (NSArray*)createBackButtonWithTarget:(id)target seletor:(SEL)seletor
{
    return @[[self barSpaingItem],[self backButtonTarget:target seletor:seletor]];
}

-(UIBarButtonItem*)backButtonTarget:(id)target seletor:(SEL)seletor
{
    CGRect backframe = CGRectMake(0, 0, 28, 28);
    UIButton* backButton= [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = backframe;
    [backButton setImage:[UIImage imageNamed:@"return"] forState:UIControlStateNormal];
    [backButton setImage:[UIImage imageNamed:@"return"] forState:UIControlStateHighlighted];
    [backButton addTarget:target action:seletor forControlEvents:UIControlEventTouchUpInside];
    
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

- (UINavigationItem *)myNavigationItem
{
    return self.navigationItem;
}

- (UINavigationController *)myNavController
{
    return self.navigationController;
}

@end


@implementation UIViewController(NetWork)
- (void)dealErrorResponseWithTableView:(RefreshTableView *)tableview info:(NSDictionary *)dic
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [self showTotasViewWithMes:[[dic objectForKey:@"response"] objectForKey:@"errorText"]];
    [tableview.refreshHeader endRefreshing];
    [tableview.refreshFooter endRefreshing];
}

- (void)netErrorWithTableView:(RefreshTableView*)tableView
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [self showTotasViewWithMes:@"网络异常，稍后重试"];
    [tableView.refreshHeader endRefreshing];
    [tableView.refreshFooter endRefreshing];
}

@end


@implementation NSObject(HomePage)

- (UITabBarController *)myTabBarcontroller
{
    UITabBarController * tabBar = (UITabBarController *)[[[[UIApplication sharedApplication] delegate] window] rootViewController];
    return tabBar;
}

- (void)jumpToHomePageWithQuary:(BOOL)quary
{
    UITabBarController * tabBar = (UITabBarController *)[[[[UIApplication sharedApplication] delegate] window] rootViewController];
    [tabBar setSelectedIndex:0];
    UINavigationController * nav = [[tabBar viewControllers] objectAtIndex:0];
    [nav popToRootViewControllerAnimated:NO];
    HomeViewController * homeC = (HomeViewController *)[nav topViewController];
    if (quary) {
        [homeC quaryData];
    }
}

@end

@implementation UIViewController(TopTableView)

- (UIView *)footView
{
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 80)];
    return view;
}

@end

@implementation UIViewController(Hot)

- (void)showMessCountInTabBar:(NSInteger)mesCount
{
    AppDelegate * appdelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    UITabBarController * tabController = (UITabBarController *)[[appdelegate window] rootViewController];
    [tabController.tabBar showBadgeOnItemIndex:3 withMessageCount:mesCount];
}

- (void)hiddenMessCountInTabBar
{
    AppDelegate * appdelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    UITabBarController * tabController = (UITabBarController *)[[appdelegate window] rootViewController];
    [tabController.tabBar hideBadgeOnItemIndex:3];
}

@end

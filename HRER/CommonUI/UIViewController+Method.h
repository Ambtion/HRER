//
//  UIViewController+DivideAssett.h
//  SohuPhotoAlbum
//
//  Created by sohu on 13-4-27.
//  Copyright (c) 2013年 Qu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "AppDelegate.h"
#import "UITabBar+RedHot.h"

#define WRITEIMAGE @"WriteImage"

@class RefreshTableView;

@interface UIViewController (Tips)
- (MBProgressHUD *)waitForMomentsWithTitle:(NSString*)str withView:(UIView *)view;
- (void)stopWaitProgressView:(MBProgressHUD *)view;
- (void)showPopAlerViewWithMes:(NSString *)message withDelegate:(id<UIAlertViewDelegate>)delegate cancelButton:(NSString *)cancelTitle otherButtonTitles:(NSString *)otherButtonTitles, ...;
- (void)showTotasViewWithMes:(NSString *)message;
- (void)showPopAlerViewWithMes:(NSString *)message;
@end

@interface UIView(Tips)
- (void)showTotasViewWithMes:(NSString *)message;
@end

@interface UIViewController(Nav)
- (NSArray*)createBackButtonWithTarget:(id)target seletor:(SEL)seletor;
- (UIBarButtonItem*)barSpaingItem;
- (UINavigationItem *)myNavigationItem;
- (UINavigationController *)myNavController;
@end


@interface UIViewController(NetWork)
- (void)dealErrorResponseWithTableView:(RefreshTableView *)tableview info:(NSDictionary *)dic;
- (void)netErrorWithTableView:(RefreshTableView*)tableView;
@end


@interface NSObject(HomePage)
- (UITabBarController *)myTabBarcontroller;
- (void)jumpToHomePageWithQuary:(BOOL)quary;
@end

@interface UIViewController(TopTableView)
- (UIView *)footView;
@end

@interface UIViewController(Hot)
- (void)showMessCountInTabBar:(NSInteger)mesCount;
- (void)hiddenMessCountInTabBar;
@end
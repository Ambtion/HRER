//
//  HRLoginManager.m
//  HRER
//
//  Created by kequ on 16/5/30.
//  Copyright © 2016年 linjunhou. All rights reserved.
//

#import "HRLoginManager.h"
#import "AppDelegate.h"
#import "HRLoginViewController.h"
#import "HRNagationController.h"

@implementation HRLoginManager

+ (void)showLoginView
{
    UIViewController * rtVC = [[[UIApplication sharedApplication] delegate] window].rootViewController;
    HRNagationController * nav = [[HRNagationController alloc] initWithRootViewController:[[HRLoginViewController alloc] init]];
    [rtVC presentViewController:nav animated:YES completion:^{
        
    }];
}

+ (void)showLoginViewWithNavgation:(UINavigationController *)nav
{
    [nav pushViewController:[[HRLoginViewController alloc] init] animated:NO];
}
@end

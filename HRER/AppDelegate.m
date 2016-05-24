//
//  AppDelegate.m
//  HRER
//
//  Created by quke on 16/5/20.
//  Copyright © 2016年 linjunhou. All rights reserved.
//

#import "AppDelegate.h"
#import "RootViewController.h"
#import "HRLocationManager.h"
#import "HRWeChatManager.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    
    [self initAllComCore];
    
    RootViewController * vc = [[RootViewController alloc] init];
    self.window.rootViewController = vc;
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)initAllComCore
{
    //注册微信
    [[HRWeChatManager shareInstance] registerWeixin];
    
    //启动定位模块
    [[HRLocationManager sharedInstance] startLocaiton];
    
}




@end

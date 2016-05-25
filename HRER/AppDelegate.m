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
#import "HRWeCatManager.h"
#import "AFNetworkActivityLogger.h"
#import "HRQQManager.h"

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
    [[HRWeCatManager shareInstance] registerWeixin];
    
    //注册QQ
    [[HRQQManager shareInstance] registerQQ];
    
    //启动定位模块
    [[HRLocationManager sharedInstance] startLocaiton];
    
    //开启AFNetWork
    [[AFNetworkActivityLogger sharedLogger] startLogging];
}


#pragma mark AppDelegate FOR SSO

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    if ([[HRWeCatManager shareInstance] isWeixinssoReturn:url]) {
        return [[HRWeCatManager shareInstance] handdleOpneUrl:url];
    }
    
    if ([[HRQQManager shareInstance] isQQssoReturn:url]) {
        return [[HRQQManager shareInstance] handdleOpneUrl:url];
    }
    return YES;
}
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    if ([[HRWeCatManager shareInstance] isWeixinssoReturn:url]) {
        return [[HRWeCatManager shareInstance] handdleOpneUrl:url];
    }
    
    if ([[HRQQManager shareInstance] isQQssoReturn:url]) {
        return [[HRQQManager shareInstance] handdleOpneUrl:url];
    }
    
    return YES;
}


@end

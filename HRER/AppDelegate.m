//
//  AppDelegate.m
//  HRER
//
//  Created by quke on 16/5/20.
//  Copyright © 2016年 linjunhou. All rights reserved.
//

#import "AppDelegate.h"
#import "HRLocationManager.h"
#import "HRWeCatManager.h"
#import "AFNetworkActivityLogger.h"
#import "HRQQManager.h"
#import "HRNagationController.h"
#import "HomeViewController.h"
#import "FindCityViewController.h"
#import "HereViewController.h"
#import "FriendsViewController.h"
#import "MyViewController.h"
#import "MainTabBarController.h"
#import "HRAddressBookManager.h"

@interface AppDelegate ()

@property(nonatomic,strong)HRNagationController * navController;

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    
    [self initAllComCore];
    
    [self setDefoultNavBarStyle];
    
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.navController = [[HRNagationController alloc] initWithRootViewController:[self getMainTabController]];
    self.window.rootViewController = self.navController;
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (MainTabBarController *)getMainTabController
{
    HomeViewController * homeC = [[HomeViewController alloc] init];
    FindCityViewController * findC = [[FindCityViewController alloc] init];
    HereViewController * hVC = [[HereViewController alloc] init];
    FriendsViewController * fVC = [[FriendsViewController alloc] init];
    MyViewController * fView = [[MyViewController alloc] init];
    
    UIImage * nHome = [UIImage imageNamed:@"tab_explore"];
    UIImage * hHome = [UIImage imageNamed:@"tab_explore_press"];
    UIImage * nFind = [UIImage imageNamed:@"tab_feed"];
    UIImage * hFind = [UIImage imageNamed:@"tab_feed_press"];
    UIImage * nHere = [UIImage imageNamed:@"btn_card"];
    UIImage * hHere = [UIImage imageNamed:@"btn_card"];
    UIImage * nFriend = [UIImage imageNamed:@"tab_setting"];
    UIImage * hFriend = [UIImage imageNamed:@"tab_setting_press"];
    UIImage * nMy = [UIImage imageNamed:@"tab_upload_shopping"];
    UIImage * hMy = [UIImage imageNamed:@"tab_upload_shopping_h"];
    
    return [self getTabWithTitleArray:@[@"主页",@"发现城市",@"这里",@"朋友",@"我的"]
                   nimagesArray:@[nHome,nFind,nHere,nFriend,nMy]
                        himages:@[hHome,hFind,hHere,hFriend,hMy]
                 andControllers:@[homeC,findC,hVC,fVC,fView]];
}

- (MainTabBarController *)getTabWithTitleArray:(NSArray *)item nimagesArray:(NSArray *)nImages
                                     himages:(NSArray *)himages
                              andControllers:(NSArray*)controllers
{
    MainTabBarController *tabBarController = [[MainTabBarController alloc] init];
    for (int i =0; i < controllers.count;i++) {
        UIViewController * controller = [controllers objectAtIndex:i];
        UIImage * nimage = [nImages[i] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        UIImage * himage = [himages[i] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        NSString * title = item[i];
        if(i == 2){
            title = nil;
        }
        UITabBarItem * tabItem = [[UITabBarItem alloc] initWithTitle:title image:nimage selectedImage:himage];
        tabItem.tag = i;
//        if(i == 2){
//            tabItem.imageInsets = UIEdgeInsetsMake(-8, 0, 8, 0);
//        }
        controller.tabBarItem = tabItem;
    }
    
    [tabBarController setViewControllers:controllers];
    [tabBarController setHidesBottomBarWhenPushed:YES];
    return tabBarController;
}

#pragma mark - Init

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

- (void)setDefoultNavBarStyle
{
    
//    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:0 green:172/255.f blue:87/255.f alpha:1]];
    NSDictionary *textAttributes1 = @{NSFontAttributeName: [UIFont systemFontOfSize:18.f],
                                      NSForegroundColorAttributeName: [UIColor whiteColor]
                                      };
    
    [[UINavigationBar appearance] setTitleTextAttributes:textAttributes1];
    
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

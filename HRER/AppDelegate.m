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
#import "FriendsViewController.h"
#import "MainTabBarController.h"
#import "HRAddressBookManager.h"
#import "MobClick.h"
#import "LoginStateManager.h"
#import "NetWorkEntity.h"
#import "HRUserHomeController.h"
#import "HRCreteLocationController.h"
#import "LJException.h"
#import <AMapFoundationKit/AMapFoundationKit.h>


@interface AppDelegate ()<UITabBarControllerDelegate>
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    
    [self initAllComCore];
    
    [self setDefoultNavBarStyle];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    MainTabBarController * mainTab = [self getMainTabController];
    mainTab.automaticallyAdjustsScrollViewInsets = NO;
    self.window.rootViewController = mainTab;
    [self.window makeKeyAndVisible];
        
    return YES;
}

- (MainTabBarController *)getMainTabController
{
    HomeViewController * homeC = [[HomeViewController alloc] init];
    FindCityViewController * findC = [[FindCityViewController alloc] init];
    HRCreteLocationController * creteC = [[HRCreteLocationController alloc] init];
    FriendsViewController * fVC = [[FriendsViewController alloc] init];
    HRUserHomeController * fuserHome = [[HRUserHomeController alloc] initWithUserID:[[[LoginStateManager getInstance] userLoginInfo] user_id]];
    
    UIImage * nHome = [UIImage imageNamed:@"home"];
    UIImage * hHome = [UIImage imageNamed:@"home_select"];
    UIImage * nFind = [UIImage imageNamed:@"find"];
    UIImage * hFind = [UIImage imageNamed:@"find_select"];
    UIImage * nHere = [UIImage imageNamed:@"add"];
    UIImage * hHere = [UIImage imageNamed:@"add"];
    UIImage * nFriend = [UIImage imageNamed:@"friend"];
    UIImage * hFriend = [UIImage imageNamed:@"friend_select"];
    UIImage * nMy = [UIImage imageNamed:@"me"];
    UIImage * hMy = [UIImage imageNamed:@"me_select"];
    
    
    HRNagationController * navHc = [[HRNagationController alloc] initWithRootViewController:homeC];
    HRNagationController * navfc = [[HRNagationController alloc] initWithRootViewController:findC];
    HRNagationController * navcrete = [[HRNagationController alloc] initWithRootViewController:creteC];
    HRNagationController * navFriend = [[HRNagationController alloc] initWithRootViewController:fVC];
    HRNagationController * navUser = [[HRNagationController alloc] initWithRootViewController:fuserHome];
    return [self getTabWithTitleArray:@[@"推荐",@"发现城市",@"",@"朋友",@"PASSPORT"]
                   nimagesArray:@[nHome,nFind,nHere,nFriend,nMy]
                        himages:@[hHome,hFind,hHere,hFriend,hMy]
                 andControllers:@[navHc,navfc,navcrete,navFriend,navUser]];
}

- (MainTabBarController *)getTabWithTitleArray:(NSArray *)item nimagesArray:(NSArray *)nImages
                                     himages:(NSArray *)himages
                              andControllers:(NSArray*)controllers
{
    MainTabBarController *tabBarController = [[MainTabBarController alloc] init];
    tabBarController.delegate = self;
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
        if(i == 2){
            tabItem.imageInsets = UIEdgeInsetsMake(-8, 0, 8, 0);
        }
        controller.tabBarItem = tabItem;
    }
    
    [tabBarController setViewControllers:controllers];
    [tabBarController setHidesBottomBarWhenPushed:YES];
    return tabBarController;
}


- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    if ([[[(UINavigationController *)viewController viewControllers] firstObject] respondsToSelector:@selector(showLoginPage)]) {
        [[[(UINavigationController *)viewController viewControllers] firstObject] performSelector:@selector(showLoginPage)];
    }
    if([[[(UINavigationController *)viewController viewControllers] firstObject] isKindOfClass:[FriendsViewController class]]){
        [viewController hiddenMessCountInTabBar];
    }
    
//    if([[[(UINavigationController *)viewController viewControllers] firstObject] isKindOfClass:[HRCreteLocationController class]]){
//        [(HRCreteLocationController *)[[(UINavigationController *)viewController viewControllers] firstObject] quaryData];
//    }

}

#pragma mark - Init

- (void)initAllComCore
{
    
    [LJException startExtern];
    
    //注册微信
    [[HRWeCatManager shareInstance] registerWeixin];
    
    //注册QQ
    [[HRQQManager shareInstance] registerQQ];

    //高德SDK
    [AMapServices sharedServices].apiKey =@"de9d2ca33d97ac9eebc98b70162bd366";

    
    //启动定位模块
    [[HRLocationManager sharedInstance] startLocaiton];
    
    //开启AFNetWork
    [[AFNetworkActivityLogger sharedLogger] setLevel:AFLoggerLevelDebug];
    [[AFNetworkActivityLogger sharedLogger] startLogging];
 
    UMConfigInstance.appKey = @"5797013767e58ea5d9000e99";
    UMConfigInstance.channelId = @"App Store";
    [MobClick startWithConfigure:UMConfigInstance];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        //访问通讯录
        [HRAddressBookManager readAllPersonAddressWithCallBack:^(NSArray *resultList, ABAuthorizationStatus status) {
            
            if (resultList.count && [[LoginStateManager getInstance] userLoginInfo]) {
                //用户登录方法
                [NetWorkEntity sendPhotoNumberWithPhotoNumber:resultList success:^(AFHTTPRequestOperation *operation, id responseObject) {
                    if ([[responseObject objectForKey:@"result"] isEqualToString:@"OK"]) {
                        NSDictionary * response = [responseObject objectForKey:@"response"];
                        if ([[response objectForKey:@"newFriend"] boolValue]) {
                            [self.window.rootViewController showMessCountInTabBar:0];
                        }else{
                            [self.window.rootViewController hiddenMessCountInTabBar];
                        }
                    }
                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    
                }];
            }
        }];
    });
//    [self startCheckNewFriend];
}

- (void)setDefoultNavBarStyle
{
    
//    [[UINavigationBar appearance] setBarTintColor:[UIColor clearColor]];
//     NSDictionary *textAttributes1 = @{NSFontAttributeName: [UIFont systemFontOfSize:16.f],
//                                      NSForegroundColorAttributeName: [UIColor whiteColor]
//                                      };
//    [[UINavigationBar appearance] setTitleTextAttributes:textAttributes1];
//    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"NavigationBarBG"] forBarMetrics:UIBarMetricsDefault];
//    [[UINavigationBar appearance] setShadowImage:[UIImage imageNamed:@"NavigationBarBG"]];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];

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


//#pragma mark - NewFirend
//- (void)startCheckNewFriend
//{
//    [NetWorkEntity quaryNewFriendTipsSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        
//    }];
//}
//
@end

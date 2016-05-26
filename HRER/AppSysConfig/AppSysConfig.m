//
//  AppSysConfig.m
//  basicmap
//
//  Created by quke on 16/4/26.
//  Copyright © 2016年 baidu. All rights reserved.
//

#import "AppSysConfig.h"

@implementation AppSysConfig
+ (BOOL)isAllowedRemoteNotification
{
    UIApplication *application = [UIApplication sharedApplication];
    BOOL  enabled = [application isRegisteredForRemoteNotifications];

//    
//    if ([application respondsToSelector:@selector(isRegisteredForRemoteNotifications)])
//    {
//        enabled = [application isRegisteredForRemoteNotifications];
//    }
//    else
//    {
//        UIUserNotificationType types = [application enabledRemoteNotificationTypes];
//        enabled = types & UIRemoteNotificationTypeAlert;
//    }
    return enabled;
}

+ (void)jumpToSetRemoteNotification
{
    NSURL * url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
    if([[UIApplication sharedApplication] canOpenURL:url]) {
        [[UIApplication sharedApplication] openURL:url];
    }
}

@end


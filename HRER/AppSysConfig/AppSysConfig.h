//
//  AppSysConfig.h
//  basicmap
//
//  Created by quke on 16/4/26.
//  Copyright © 2016年 baidu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppSysConfig : NSObject

/**
 *  用户是否关闭远程推送
 */
+ (BOOL)isAllowedRemoteNotification;


/**
 *  跳转到推送设置页面
 */
+ (void)jumpToSetRemoteNotification;
@end

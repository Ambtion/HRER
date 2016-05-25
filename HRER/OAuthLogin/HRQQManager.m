//
//  HRQQManager.m
//  HRER
//
//  Created by quke on 16/5/25.
//  Copyright © 2016年 linjunhou. All rights reserved.
//

#import "HRQQManager.h"

#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/TencentOAuthObject.h>
#import <TencentOpenAPI/TencentApiInterface.h>


#define TencentAppKey  @"100506074"


static HRQQManager *gInstance = nil;


@interface HRQQManager()<TencentSessionDelegate>

@property (nonatomic, retain)TencentOAuth *oauth;

@end

@implementation HRQQManager

+ (HRQQManager *)shareInstance
{
    if(gInstance == nil) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            gInstance = [[HRQQManager alloc] init];
        });
    }
    return gInstance;
}

#pragma mark - Register
- (void)registerQQ
{
    _oauth = [[TencentOAuth alloc] initWithAppId:TencentAppKey
                                     andDelegate:self];

}

//QQ回调
- (BOOL)isQQssoReturn:(NSURL *)url
{
    return [[url absoluteString] rangeOfString:@"tencent"].location != NSNotFound;
}

- (BOOL)handdleOpneUrl:(NSURL *)url
{
   return [TencentApiInterface handleOpenURL:url delegate:self];
}



#pragma mark - Login
- (BOOL)iphoneQQSupportSSOLogin
{
    return [TencentOAuth iphoneQQSupportSSOLogin];
}

- (void)loginWithLoginCallBack:(LoginCallBack)callback
{
    self.loginCallBack = callback;
    
    NSArray * qqPermissions = [NSArray arrayWithObjects:
                               kOPEN_PERMISSION_GET_SIMPLE_USER_INFO,
                               kOPEN_PERMISSION_ADD_SHARE,  /** 同步分享到QQ空间、腾讯微博 */
                               nil];
    [_oauth authorize:qqPermissions inSafari:NO];
}

- (void)tencentDidLogin
{
    if (self.loginCallBack) {
        self.loginCallBack(YES,NO);
        self.loginCallBack = nil;
    }
}

- (void)tencentDidNotLogin:(BOOL)cancelled
{
    if (self.loginCallBack) {
        self.loginCallBack(NO,cancelled);
        self.loginCallBack = nil;
    }
}

- (void)tencentDidNotNetWork
{
    if (self.loginCallBack) {
        self.loginCallBack(NO,NO);
        self.loginCallBack = nil;
    }
}

- (NSArray *)getAuthorizedPermissions:(NSArray *)permissions withExtraParams:(NSDictionary *)extraParams
{
    return nil;
}

- (BOOL)tencentNeedPerformIncrAuth:(TencentOAuth *)tencentOAuth withPermissions:(NSArray *)permissions
{
    return YES;
}


- (BOOL)tencentNeedPerformReAuth:(TencentOAuth *)tencentOAuth
{
    return YES;
}

#pragma mark Get UserInfo

- (void)getUserInfoResponse:(APIResponse*) response
{
    if (self.reqCallBack) {
        self.reqCallBack(response);
        self.reqCallBack = nil;
    }
}

@end


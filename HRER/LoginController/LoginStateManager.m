//
//  SCPLoginPridictive.m
//  SohuCloudPics
//
//  Created by sohu on 12-9-26.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "LoginStateManager.h"

#define USER_ID             [NSString stringWithFormat:@"__USER_ID__%@",[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]]

#define DEVICE_TOKEN        @"__device_token__"
#define LASTUSERNAME        @"__last_usrName__"
#define USER_TOKEN          @"__USER_TOKEN__"
#define USER_NIKE           @"__USER_NIKE__"

#define REFRESH_TOKEN       @"__REFRESH_TOKEN__"
#define DEVICEDID           @"__DEVICEDID__"
#define BAIDUDEVICEDID      @"__BAIDUDEVICEDID__"
#define SINA_TOKEN          @"__SINA_TOKEN__"
#define RENREN_TOKEN        @"__RENREN_TOKEN__"
#define QQ_TOKEN            @"__QQ_TOKEN__"


@implementation LoginStateManager (private)

+ (void)storeData:(id)data forKey:(NSString *)key
{
    NSUserDefaults *defults = [NSUserDefaults standardUserDefaults];
    [defults setObject:data forKey:key];
    [defults synchronize];
}

+ (id)dataForKey:(NSString *)key
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString * data = [defaults objectForKey:key];
    return data;
}
+ (void)removeDataForKey:(NSString *)key
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:key];
    [defaults synchronize];
}
@end

@interface LoginStateManager()

@property(nonatomic,strong)HRUserLoginInfo * userLoginInfo;

@end

@implementation LoginStateManager

+ (LoginStateManager *)getInstance
{
    static dispatch_once_t onceToken;
    static LoginStateManager * loginStateManager;
    dispatch_once(&onceToken, ^{
        loginStateManager = [[LoginStateManager alloc] init];
    });
    return loginStateManager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.userLoginInfo = [self readUserInfoFromCache];
    }
    return self;
}


- (void)saveUserInfoInCache:(HRUserLoginInfo *)userLoginInfo
{
    NSData * data = [NSKeyedArchiver archivedDataWithRootObject:userLoginInfo];
    [[self class] storeData:data forKey:USER_ID];
}

- (HRUserLoginInfo *)readUserInfoFromCache
{
    NSData * data = [[self class] dataForKey:USER_ID];
    if (data) {
        id object =  [NSKeyedUnarchiver unarchiveObjectWithData:data];
        if ([object isKindOfClass:[HRUserLoginInfo class]]) {
            return object;
        }
    }
    return nil;
}

- (HRUserLoginInfo *)userLoginInfo
{
    return _userLoginInfo;
}

#pragma mark Login | Logout
- (void)LoginWithUserLoginInfo:(HRUserLoginInfo *)userLoginInfo
{
    if (userLoginInfo) {
        [[NSNotificationCenter defaultCenter] postNotificationName:LOGIN_IN object:nil];
        self.userLoginInfo = userLoginInfo;
        [self saveUserInfoInCache:userLoginInfo];
    }
}

- (void)logout
{
    self.userLoginInfo = nil;
    [[self class] removeDataForKey:USER_ID];
    [[NSNotificationCenter defaultCenter] postNotificationName:LOGIN_OUT object:nil];

}

@end

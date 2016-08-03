//
//  SCPLoginPridictive.h
//  SohuCloudPics
//
//  Created by sohu on 12-9-26.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#define LOGIN_IN            @"__LOGIN_IN__"
#define LOGIN_OUT           @"__LOGIN_OUT__"

@interface LoginStateManager : NSObject

+ (LoginStateManager *)getInstance;

- (void)LoginWithUserLoginInfo:(HRUserLoginInfo *)userLoginInfo;

- (void)updateUserInfo:(HRUserLoginInfo *)userLoginInfo;

- (HRUserLoginInfo *)userLoginInfo;

- (void)logout;


@end

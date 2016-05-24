//
//  BMWeChatManager.h
//  HRER
//
//  Created by quke on 16/5/24.
//  Copyright © 2016年 linjunhou. All rights reserved.
//

#import "WXApi.h"



@interface HRWeChatManager : NSObject <WXApiDelegate>

@property (nonatomic, copy) void(^reqCallBack)(BaseResp *resp);


+ (HRWeChatManager *)shareInstance;

//注册微信
- (void)registerWeixin;

//微信回调
- (BOOL)isWeixinssoReturn:(NSURL *)url;
- (BOOL)handdleOpneUrl:(NSURL *)url;

//微信是否安装
- (BOOL)isWXAppInstalled;


- (BOOL)sendReq:(BaseReq *)req callBack:(void(^)(BaseResp *resp))callBack;

@end

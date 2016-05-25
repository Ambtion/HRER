//
//  HRQQManager.h
//  HRER
//
//  Created by quke on 16/5/25.
//  Copyright © 2016年 linjunhou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <TencentOpenAPI/sdkdef.h>


typedef void(^LoginCallBack)(BOOL isSucess,BOOL isCanceled);
typedef void(^ReqCallBack)(APIResponse * response);


@interface HRQQManager : NSObject

@property (nonatomic, copy)LoginCallBack loginCallBack;
@property (nonatomic, copy)ReqCallBack reqCallBack;

+ (HRQQManager *)shareInstance;

//注册QQSDK
- (void)registerQQ;

//QQ回调
- (BOOL)isQQssoReturn:(NSURL *)url;
- (BOOL)handdleOpneUrl:(NSURL *)url;


//QQ登录
- (void)loginWithLoginCallBack:(LoginCallBack)callback;
- (BOOL)iphoneQQSupportSSOLogin;


//QQ分享
/**
 *  纯文本分享
 */
- (void)shareWithTitle:(NSString *)title WithCallBack:(ReqCallBack)callback;



@end

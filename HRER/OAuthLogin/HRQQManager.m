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
#import <TencentOpenAPI/QQApiInterfaceObject.h>


#define TencentAppKey  @"100506074"


static HRQQManager *gInstance = nil;


@interface HRQQManager()<TencentSessionDelegate,QQApiInterfaceDelegate>

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
   return [QQApiInterface handleOpenURL:url delegate:self];
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

#pragma mark Share
- (void)shareWithTitle:(NSString *)title WithCallBack:(ReqCallBack)callback;
{
    self.reqCallBack = callback;
    QQApiTextObject *txtObj = [QQApiTextObject objectWithText:title];
    SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:txtObj];
    [QQApiInterface sendReq:req];
    
}


- (void)shareImageToQQWithThumbImage:(UIImage *)thumbImage orignalImage:(UIImage *)oImage title:(NSString *)title withDes:(NSString *)des WithCallBack:(ReqCallBack)callback;
{
    
    NSData * tData = UIImageJPEGRepresentation(thumbImage, 0.8);
    NSData * oData = UIImageJPEGRepresentation(oImage, 0.8);
    
    QQApiImageObject *imgObj = [QQApiImageObject objectWithData:oData
                                               previewImageData:tData
                                                          title:title
                                                   description :des];
    
    SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:imgObj];
    
    [QQApiInterface sendReq:req];
}

- (void)shareNewsWithImage:(UIImage*)image  title:(NSString *)title Des:(NSString *)des link:(NSString *)urlStr WithCallBack:(ReqCallBack)callback
{
    NSURL * url = [NSURL URLWithString:urlStr];
    
    QQApiNewsObject* img = [QQApiNewsObject objectWithURL:url title:title description:des previewImageData:UIImageJPEGRepresentation(image, 0.8)];
    SendMessageToQQReq* req = [SendMessageToQQReq reqWithContent:img];
    [QQApiInterface sendReq:req];
}
#pragma mark - CallBack
- (void)onResp:(QQBaseResp *)resp
{
    if(self.reqCallBack){
        self.reqCallBack(resp);
        self.reqCallBack = nil;
    }
}

- (void)onReq:(QQBaseReq *)req
{}

- (void)isOnlineResponse:(NSDictionary *)response
{}

@end


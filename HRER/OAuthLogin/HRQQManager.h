//
//  HRQQManager.h
//  HRER
//
//  Created by quke on 16/5/25.
//  Copyright © 2016年 linjunhou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <TencentOpenAPI/sdkdef.h>
#import <TencentOpenAPI/QQApiInterface.h>

typedef void(^LoginCallBack)(BOOL isSucess,BOOL isCanceled);
typedef void(^ReqCallBack)(QQBaseResp * response);


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
- (void)shareWithTitle:(NSString *)title
          WithCallBack:(ReqCallBack)callback;

/**
 *  纯图片分享
 *
 *  @param thumbImage 预览图片 <预览图像，最大1M字节
 *  @param oImage     原始图片 <具体数据内容，必填，最大5M字节
 *  @param title      图片Title
 *  @param des        图片描述
 */
- (void)shareImageToQQWithThumbImage:(UIImage *)thumbImage
                        orignalImage:(UIImage *)oImage
                               title:(NSString *)title
                             withDes:(NSString *)des
                        WithCallBack:(ReqCallBack)callback;

/**
 *  分享新闻消息
 *
 *  @param image    新闻图片
 *  @param title    新闻标题
 *  @param des      新闻描述
 *  @param urlStr   新闻link
 */
- (void)shareNewsWithImage:(UIImage*)image
                     title:(NSString *)title
                       Des:(NSString *)des
                      link:(NSString *)urlStr
              WithCallBack:(ReqCallBack)callback;


@end

//
//  NetWorkEntiry.h
//  JewelryApp
//
//  Created by kequ on 15/5/12.
//  Copyright (c) 2015年 jewelry. All rights reserved.
//

#import "AFNetworking.h"

#define  KNETBASEURL           @"http://58.135.93.4:8089"

@interface NetWorkEntiry : NSObject

/*
 登陆模块
===================================================================================================================
*/


/*
 *  注册
 */

+ (void)regisWithPhotoNumber:(NSString *)PhotoNumber
                 password:(NSString *)password
                 nickName:(NSString *)nickName
                  verCode:(NSString *)verCode
                  success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                  failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

/**
 *  发送验证码
 */
+ (void)sendVerCodeWithPhoneNumber:(NSString *)photoNumber
                           success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                           failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

/*
 * 登陆
 */

+ (void)loginWithUserName:(NSString *)userName
                 password:(NSString *)password
                  success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                  failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

/**
 *  重置密码
 */

+ (void)resetPassNumber:(NSString *)photoNumber
                verCode:(NSString *)verCode
               password:(NSString *)password
                success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

/**
 *  微信登陆
 *  https://open.weixin.qq.com/cgi-bin/showdocument?action=dir_list&t=resource/res_list&verify=1&id=open1419317851&token=&lang=zh_CN
 */

+ (void)loginWithWebCatAccess_token:(NSString *)accessToken refresh_token:(NSString *)refreshToken
                         success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                         failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;


/**
 *  绑定手机
 */

+ (void)bindPhoneWithThirdId:(NSString *)thridID
                    verCode:(NSString *)verCode
                     success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                     failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;


/**
 *  修改密码
 */

+ (void)mofifyPassWord:(NSString *)pasWord
               success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
               failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;


/*
 POI列表
 ===================================================================================================================
 */


/**
 *  获取主页POIList或者城市List
 *
 *  @param cityID  城市ID
 *  @param start   起始
 *  @param count   获取数目
 */

+ (void)getPoiListWithUserId:(NSString *)userId
                      cityID:(NSString *)cityID
                       start:(NSInteger)start
                       count:(NSInteger)count
                     success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                     failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
@end

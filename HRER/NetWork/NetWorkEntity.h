//
//  NetWorkEntiry.h
//  JewelryApp
//
//  Created by kequ on 15/5/12.
//  Copyright (c) 2015年 jewelry. All rights reserved.
//

#import "AFNetworking.h"
#import "ModelDefine.h"

#define  KNETBASEURL           @"http://58.135.93.4:8089"

@interface NetWorkEntity : NSObject

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

+ (void)loginWithWebCatAccess_token:(NSString *)accessToken
                            success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                            failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;


/**
 *  绑定手机
 */

+ (void)bindPhoneNumber:(NSString *)photoNumber
                VerCode:(NSString *)verCode
                     success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                     failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;


/**
 *  修改密码
 */

+ (void)mofifyPassWord:(NSString *)pasWord
               success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
               failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;


/**
 *  获取老朋友列表
 */

+ (void)quaryFriendsListWithFillter:(NSString *)filler
                          success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                          failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;



/**
 *  上传通讯录
 */
+ (void)sendPhotoNumberWithPhotoNumber:(NSArray *)photoNumbers
                         success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                         failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

/**
 *  关注/取消关注
 */
+ (void)favFriends:(NSString *)userId
             isFav:(BOOL)isFav
           success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
           failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
/*
 POI列表
 ===================================================================================================================
 */


/**
 *  获取城市ID
 */
+ (void)quaryCityInfoWithCityName:(NSString *)cityName lat:(CGFloat)lat lng:(CGFloat)lng
                          success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                          failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

//获取热门城市
+ (void)quaryHotCityListSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                        failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

/**
 *  获取城市各个分类的count
 */

+ (void)quaryCityTypeCount:(NSInteger)cityId
                   success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                   failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

/**
 *  获取附近城市推荐列表
 *  catergory 1=>"美食", 2=>"观光", 3=>"休闲", 4=>"酒店"
 */
+ (void)quartCityNearByWithCityId:(NSInteger)cityId
                        catergory:(NSInteger)catergory
                          success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                          failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;


/**
 *  获取个人和朋友创建的POI
 */
+ (void)quaryFreindsCretePoiListWithCityId:(NSInteger)cityId
                                  catergory:(NSInteger)catergory
                                    success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                    failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
/**
 *  获取所欲混合的POI集合
 */

+ (void)quaryAllMixedPoiListWithCityId:(NSInteger)cityId
                     catergory:(NSInteger)catergory
                       success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                       failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

///**
// *  获取个人和朋友创建的POI集合
// */
//
//+ (void)quaryFreindsCretePoiSetListWithCityId:(NSInteger)cityId
//                                    catergory:(NSInteger)catergory
//                                      success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
//                                      failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
//
///**
// *  获取编辑创建的POI集合
// */
//+ (void)quaryEditorCretePoiSetListWithCityId:(NSInteger)cityId
//                                    catergory:(NSInteger)catergory
//                                      success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
//                                      failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
//
//
///**
// *  获取编辑创建的POI
// */
//+ (void)quaryEditCretePoiListWithCityId:(NSInteger)cityId
//                                 catergory:(NSInteger)catergory
//                                   success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
//                                   failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;


/**
 *  获取POISet详情信息
 *
 *  @param cretetype 因外服务端没有建索引，所以客户端处理这个逻辑
 *  @param cityId    城市ID
 *  @param catergory 行业类型
 *  @param userId    用户ID
 */
+ (void)quaryPoiSetDetailListWithCreteType:(KPoiSetsCreteType)cretetype
                                    cityId:(NSInteger)cityId
                                catergory:(NSInteger)catergory
                               creteUserId:(NSString *)userId
                                   success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                   failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;



/*
 创建列表
 ===================================================================================================================
 */
/**
 *  https://developers.google.com/places/web-service/search
 *
 *  @param poiType  0 -> 美食 1 ->观光 2->购物 3->酒店
 */
+ (void)quaryPoiListWith:(BOOL)isUseGoogleSearve
                 keyWord:(NSString *)keyWord
                 poiType:(NSInteger)poiType
                countyId:(NSInteger)countyId
                     lat:(CGFloat)lat
                     loc:(CGFloat)lng
                 success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                 failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;


/**
 *  POI详情页面
 ===================================================================================================================
 */

/**
 *  POI详情
 */

+ (void)quaryPoiDetailInfoWithPoiId:(NSString *)poiId
                            success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                            failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;


+ (void)quaryWantTogoPoidetailWithPoiId:(NSString *)poiId
                               wantTogo:(BOOL)wantTogo
                                success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;


/**
 评论
 ===================================================================================================================
 */

/**
 *  评论 or 回复评论
 *
 *  @param poiId   poi ID
 *  @param recId   回复的评论ID，如果没有着表示不是回复评论
 *  @param content 评论内容
 */

+ (void)recomendPoiWithPoiId:(NSString *)poiId
                    cmtToRec:(NSString *)recId
                     content:(NSString *)content
                     success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                     failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;


/**
 *  删除评论
 */

+ (void)deleteRecomendWithCmtId:(NSString *)cmtId
                        success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                        failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;


/**
 *  获取个人信息
 *
 *  @param userId  用户ID
 *
 */

+ (void)quaryUserInfoWithUserId:(NSString *)userId
                        success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                        failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

+ (void)quaryUserHomePoiListWithUserId:(NSString *)userId
                             catergory:(NSInteger)catergory
                               success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                               failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

/**
 *  创建POI
 *  ===================================================================================================================
 */
+ (void)uploadPoiWithTitle:(NSString *)title
                       des:(NSString *)PoiDes
                      type:(NSInteger)type
                     price:(CGFloat)price
                    locDes:(NSString *)locDes
                    cityID:(NSInteger)cityId
                       lat:(CGFloat)lat
                       loc:(CGFloat)lng
                    images:(NSArray *)images
                   success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                   failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;


/**
 *  修改用户信息
 */

+ (void)updateUserName:(NSString *)nickName
              password:(NSString *)password
                 image:(UIImage *)image
            bindweixin:(NSInteger)bindWeixin
               success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
               failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;


@end



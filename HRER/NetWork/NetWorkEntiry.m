//
//  NetWorkEntiry.m
//  JewelryApp
//
//  Created by kequ on 15/5/12.
//  Copyright (c) 2015年 jewelry. All rights reserved.
//

#import "NetWorkEntiry.h"
#import "LoginStateManager.h"

@implementation NetWorkEntiry


+ (void)regisWithPhotoNumber:(NSString *)photoNumber
                    password:(NSString *)password
                    nickName:(NSString *)nickName
                     verCode:(NSString *)verCode
                     success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                     failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    
    if (!photoNumber.length ||
        !password.length ||
        !nickName.length ||
        !verCode.length) {
        return [self missParagramercallBackFailure:failure];
    }
    
    NSDictionary * dic = @{@"phone":photoNumber,
                           @"password":password,
                           @"name":nickName,
                           @"verificationCode":verCode
                           };
    
    NSString * urlStr = [NSString stringWithFormat:@"%@/register",KNETBASEURL];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:urlStr parameters:dic success:success failure:failure];
}

+ (void)sendVerCodeWithPhoneNumber:(NSString *)photoNumber
                           success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                           failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSDictionary * dic = @{@"phone":photoNumber};
    NSString * urlStr = [NSString stringWithFormat:@"%@/sendCode",KNETBASEURL];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:urlStr parameters:dic success:success failure:failure];
}

+ (void)loginWithUserName:(NSString *)userName password:(NSString *)password
                   success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                   failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    
    NSDictionary * dic = @{@"phone":userName,@"password":password};
    NSString * urlStr = [NSString stringWithFormat:@"%@/login",KNETBASEURL];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:urlStr parameters:dic success:success failure:failure];
    
}

+ (void)resetPassNumber:(NSString *)photoNumber
                verCode:(NSString *)verCode
               password:(NSString *)password
                success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSDictionary * dic = @{@"phone":photoNumber,
                           @"password":password,
                           @"verificationCode":verCode};
    NSString * urlStr = [NSString stringWithFormat:@"%@/findPassword",KNETBASEURL];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:urlStr parameters:dic success:success failure:failure];
    
}

+ (void)loginWithWebCatAccess_token:(NSString *)accessToken
                         success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                         failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    
    NSDictionary * dic = @{@"code":accessToken};
    //等待协议
    NSString * urlStr = [NSString stringWithFormat:@"%@/loginWeixin",KNETBASEURL];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:urlStr parameters:dic success:success failure:failure];
}

+ (void)bindPhoneNumber:(NSString *)photoNumber
                VerCode:(NSString *)verCode
                success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    
    NSMutableDictionary * dic = [self commonComonPar];
    [dic setValue:photoNumber forKey:@"phone"];
    [dic setValue:verCode forKey:@"verificationCode"];
    //等待协议
    NSString * urlStr = [NSString stringWithFormat:@"%@/bindPhone",KNETBASEURL];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:urlStr parameters:dic success:success failure:failure];
}

+ (void)mofifyPassWord:(NSString *)pasWord
               success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
               failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSMutableDictionary * dic = [self commonComonPar];
    NSString * urlStr = [NSString stringWithFormat:@"%@/user/change_password",KNETBASEURL];
    dic[@"password"] = pasWord;
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:urlStr parameters:dic success:success failure:failure];
}


/**
 *  获取老朋友列表
 */

+ (void)quaryFriendsListWithFillter:(NSString *)filler
                          success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                          failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSMutableDictionary * dic = [self commonComonPar];
    NSString * urlStr = [NSString stringWithFormat:@"%@/getFriends",KNETBASEURL];
    if (filler.length) {
        dic[@"content"] = filler;
    }
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:urlStr parameters:dic success:success failure:failure];
}

+ (NSString *)strOfPhoto:(NSDictionary *)dic
{
    NSString * name = [dic objectForKey:@"name"];
    NSString * photoNumber = @"";
    if (name.length) {
        NSArray * array = [dic objectForKey:@"photoList"];
        for (int i = 0; i < array.count; i++) {
            photoNumber = [photoNumber stringByAppendingFormat:@"%@:%@",name,array[i]];
            if (i != array.count - 1) {
                photoNumber = [photoNumber stringByAppendingString:@"|"];
            }
            
        }
    }
    return photoNumber;
}


+ (void)sendPhotoNumberWithPhotoNumber:(NSArray *)photoNumbers
                         success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                         failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSMutableDictionary * dic = [self commonComonPar];
    NSString * urlStr = [NSString stringWithFormat:@"%@/addressbook",KNETBASEURL];
    NSString * str = @"";
    NSInteger totalCout = photoNumbers.count;
    totalCout = 2;
    for (int i = 0; i < totalCout; i++) {
        NSString * pnum = [self strOfPhoto:photoNumbers[i]];
        if (pnum.length) {
            str = [str stringByAppendingString:pnum];
            if (i != totalCout - 1) {
                str = [str stringByAppendingString:@"|"];
            }
        }
    }
    if (str.length) {
        dic[@"addressbook"] = str;
    }
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:urlStr parameters:dic success:success failure:failure];
}

+ (void)favFriends:(NSString *)userId
             isFav:(BOOL)isFav
           success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
           failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSMutableDictionary * dic = [self commonComonPar];
    NSString * urlStr = [NSString stringWithFormat:@"%@/follow",KNETBASEURL];
    dic[@"id"] = userId;
    dic[@"isFollow"] = @(isFav);
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:urlStr parameters:dic success:success failure:failure];
}

/*
 POI列表
 ===================================================================================================================
 */

/**
 *  获取城市ID
 */
+ (void)quaryCityInfoWithCityName:(NSString *)cityName lat:(CGFloat)lat lng:(CGFloat)lng
                          success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                          failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSMutableDictionary * dic = [self commonComonPar];
    [dic setValue:cityName forKey:@"city_name"];
    [dic setValue:@(lat) forKey:@"lat"];
    [dic setValue:@(lng) forKey:@"lng"];
    NSString * urlStr = [NSString stringWithFormat:@"%@/get_city_id",KNETBASEURL];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:urlStr parameters:dic success:success failure:failure];

}

/**
 *  获取城市各个分类的count
 */

+ (void)quaryCityTypeCount:(NSInteger)cityId
                   success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                   failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSMutableDictionary * dic = [self commonComonPar];
    [dic setValue:@(cityId) forKey:@"city_id"];
    NSString * urlStr = [NSString stringWithFormat:@"%@/poi_summary",KNETBASEURL];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:urlStr parameters:dic success:success failure:failure];
}



/**
 *  获取附近城市推荐列表
 */
+ (void)quartCityNearByWithCityId:(NSInteger)cityId
                              lat:(CGFloat)lat
                              lng:(CGFloat)lng
                        catergory:(NSInteger)catergory
                          success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                          failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSMutableDictionary * dic = [self commonComonPar];
    [dic setValue:@(cityId) forKey:@"city_id"];
    [dic setValue:@(lat) forKey:@"lat"];
    [dic setValue:@(lng) forKey:@"lng"];
    [dic setValue:@(catergory) forKey:@"type"];
    NSString * urlStr = [NSString stringWithFormat:@"%@/near_poi_search",KNETBASEURL];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:urlStr parameters:dic success:success failure:failure];
}


/**
 *  获取个人和朋友创建的POI | 获取个人和朋友想去的POI
 */
+ (void)quaryFreindsCretePoiListWithCityId:(NSInteger)cityId
                                        lat:(CGFloat)lat
                                        lng:(CGFloat)lng
                                  catergory:(NSInteger)catergory
                                    success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                    failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSMutableDictionary * dic = [self commonComonPar];
    [dic setValue:@(cityId) forKey:@"city_id"];
    [dic setValue:@(lat) forKey:@"lat"];
    [dic setValue:@(lng) forKey:@"lng"];
    [dic setValue:@(catergory) forKey:@"type"];
    NSString * urlStr = [NSString stringWithFormat:@"%@/single_poi",KNETBASEURL];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:urlStr parameters:dic success:success failure:failure];

}

/**
 *  获取个人和朋友创建的POI集合
 */

+ (void)quaryFreindsCretePoiSetListWithCityId:(NSInteger)cityId
                                          lat:(CGFloat)lat
                                          lng:(CGFloat)lng
                                    catergory:(NSInteger)catergory
                                      success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                      failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSMutableDictionary * dic = [self commonComonPar];
    [dic setValue:@(cityId) forKey:@"city_id"];
    [dic setValue:@(lat) forKey:@"lat"];
    [dic setValue:@(lng) forKey:@"lng"];
    [dic setValue:@(catergory) forKey:@"type"];
    NSString * urlStr = [NSString stringWithFormat:@"%@/poi_set",KNETBASEURL];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:urlStr parameters:dic success:success failure:failure];
}


/**
 *  获取编辑创建的POI集合
 */
+ (void)quaryEditorCretePoiSetListWithCityId:(NSInteger)cityId
                                         lat:(CGFloat)lat
                                         lng:(CGFloat)lng
                                   catergory:(NSInteger)catergory
                                     success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                     failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSMutableDictionary * dic = [self commonComonPar];
    [dic setValue:@(cityId) forKey:@"city_id"];
    [dic setValue:@(lat) forKey:@"lat"];
    [dic setValue:@(lng) forKey:@"lng"];
    [dic setValue:@(catergory) forKey:@"type"];
    NSString * urlStr = [NSString stringWithFormat:@"%@/editor_sets",KNETBASEURL];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:urlStr parameters:dic success:success failure:failure];

}

/**
 *  获取边距创建的POI
 */
+ (void)quaryEditCretePoiListWithCityId:(NSInteger)cityId
                                    lat:(CGFloat)lat
                                    lng:(CGFloat)lng
                              catergory:(NSInteger)catergory
                                success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSMutableDictionary * dic = [self commonComonPar];
    [dic setValue:@(cityId) forKey:@"city_id"];
    [dic setValue:@(lat) forKey:@"lat"];
    [dic setValue:@(lng) forKey:@"lng"];
    [dic setValue:@(catergory) forKey:@"type"];
    NSString * urlStr = [NSString stringWithFormat:@"%@/editor_single",KNETBASEURL];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:urlStr parameters:dic success:success failure:failure];
}

#pragma mark - Common
+ (NSMutableDictionary *)commonComonPar
{
    NSMutableDictionary  * paragramer = [NSMutableDictionary dictionaryWithCapacity:0];
    if ([[LoginStateManager getInstance] userLoginInfo].token)
        [paragramer setValue:[[LoginStateManager getInstance] userLoginInfo].token forKey:@"token"];
    return paragramer;
}

+ (void)missParagramercallBackFailure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSError * error = [NSError errorWithDomain:@"Deomin" code:0
                                      userInfo:@{@"error":@"缺少参数"}];
    failure(nil,error);
}
@end

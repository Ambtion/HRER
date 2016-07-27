//
//  NetWorkEntiry.m
//  JewelryApp
//
//  Created by kequ on 15/5/12.
//  Copyright (c) 2015年 jewelry. All rights reserved.
//

#import "NetWorkEntity.h"
#import "LoginStateManager.h"
#import "HRLocationManager.h"

@implementation NetWorkEntity


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
#pragma warning
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
                        catergory:(NSInteger)catergory
                          success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                          failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSMutableDictionary * dic = [self commonComonPar];
    [dic setValue:@(cityId) forKey:@"city_id"];
    [dic setValue:@([[[HRLocationManager sharedInstance] curLocation] coordinate].latitude) forKey:@"lat"];
    [dic setValue:@([[[HRLocationManager sharedInstance] curLocation] coordinate].longitude) forKey:@"lng"];
    [dic setValue:@(catergory) forKey:@"type"];
    NSString * urlStr = [NSString stringWithFormat:@"%@/near_poi_search",KNETBASEURL];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:urlStr parameters:dic success:success failure:failure];
}


/**
 *  获取个人和朋友创建的POI | 获取个人和朋友想去的POI
 */
+ (void)quaryFreindsCretePoiListWithCityId:(NSInteger)cityId
                                  catergory:(NSInteger)catergory
                                    success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                    failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSMutableDictionary * dic = [self commonComonPar];
    [dic setValue:@(cityId) forKey:@"city_id"];
    [dic setValue:@([[[HRLocationManager sharedInstance] curLocation] coordinate].latitude) forKey:@"lat"];
    [dic setValue:@([[[HRLocationManager sharedInstance] curLocation] coordinate].longitude) forKey:@"lng"];
    [dic setValue:@(catergory) forKey:@"type"];
    NSString * urlStr = [NSString stringWithFormat:@"%@/single_poi",KNETBASEURL];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:urlStr parameters:dic success:success failure:failure];

}

/**
 *  获取个人和朋友创建的POI集合
 */

+ (void)quaryFreindsCretePoiSetListWithCityId:(NSInteger)cityId
                                    catergory:(NSInteger)catergory
                                      success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                      failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSMutableDictionary * dic = [self commonComonPar];
    [dic setValue:@(cityId) forKey:@"city_id"];
    [dic setValue:@([[[HRLocationManager sharedInstance] curLocation] coordinate].latitude) forKey:@"lat"];
    [dic setValue:@([[[HRLocationManager sharedInstance] curLocation] coordinate].longitude) forKey:@"lng"];
    [dic setValue:@(catergory) forKey:@"type"];
    NSString * urlStr = [NSString stringWithFormat:@"%@/poi_set",KNETBASEURL];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:urlStr parameters:dic success:success failure:failure];
}


/**
 *  获取编辑创建的POI集合
 */
+ (void)quaryEditorCretePoiSetListWithCityId:(NSInteger)cityId
                                   catergory:(NSInteger)catergory
                                     success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                     failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSMutableDictionary * dic = [self commonComonPar];
    [dic setValue:@(cityId) forKey:@"city_id"];
    [dic setValue:@([[[HRLocationManager sharedInstance] curLocation] coordinate].latitude) forKey:@"lat"];
    [dic setValue:@([[[HRLocationManager sharedInstance] curLocation] coordinate].longitude) forKey:@"lng"];
    [dic setValue:@(catergory) forKey:@"type"];
    NSString * urlStr = [NSString stringWithFormat:@"%@/editor_set",KNETBASEURL];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:urlStr parameters:dic success:success failure:failure];

}

/**
 *  获取编辑创建的POI
 */
+ (void)quaryEditCretePoiListWithCityId:(NSInteger)cityId
                              catergory:(NSInteger)catergory
                                success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSMutableDictionary * dic = [self commonComonPar];
    [dic setValue:@(cityId) forKey:@"city_id"];
    [dic setValue:@([[[HRLocationManager sharedInstance] curLocation] coordinate].latitude) forKey:@"lat"];
    [dic setValue:@([[[HRLocationManager sharedInstance] curLocation] coordinate].longitude) forKey:@"lng"];
    [dic setValue:@(catergory) forKey:@"type"];
    NSString * urlStr = [NSString stringWithFormat:@"%@/editor_single",KNETBASEURL];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:urlStr parameters:dic success:success failure:failure];
}

+ (void)quaryPoiSetDetailListWithCreteType:(KPoiSetsCreteType)cretetype
                                    cityId:(NSInteger)cityId
                                 catergory:(NSInteger)catergory
                               creteUserId:(NSString *)userId
                                   success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                   failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSMutableDictionary * dic = [self commonComonPar];
    [dic setValue:@(cityId) forKey:@"city_id"];
    [dic setValue:@([[[HRLocationManager sharedInstance] curLocation] coordinate].latitude) forKey:@"lat"];
    [dic setValue:@([[[HRLocationManager sharedInstance] curLocation] coordinate].longitude) forKey:@"lng"];
    [dic setValue:@(catergory) forKey:@"type"];
    
    NSString * urlStr = @"";
    switch (cretetype) {
        case KPoiSetsCreteHere:
            urlStr = [NSString stringWithFormat:@"%@/get_poi_by_city",KNETBASEURL];
            break;
        case KPoiSetsCreteUser:
            urlStr = [NSString stringWithFormat:@"%@/get_poi_by_user",KNETBASEURL];
            break;
        case KPoiSetsCreteNearBy:
            urlStr = [NSString stringWithFormat:@"%@/get_poi_nearby",KNETBASEURL];
            break;
        default:
            break;
    }
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:urlStr parameters:dic success:success failure:failure];

}

/*
 创建列表
 ===================================================================================================================
 */
+ (void)quartPoiListWithKeyWord:(NSString *)keyWord
                        poiType:(NSInteger)poiType
                            lat:(CGFloat)lat
                            loc:(CGFloat)lng
                        success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                        failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    
    
    /**
     *  高德
     */
    NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithCapacity:0];
    [dic setValue:@"b5646e547c5bc722d99bdd34795fcf11" forKey:@"key"];
    [dic setValue:keyWord forKey:@"keywords"];
    [dic setValue:[NSString stringWithFormat:@"%.5f,%.5f",lat,lng] forKey:@"location"];
    NSString *  urlStr = @"http://restapi.amap.com/v3/place/around";
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:urlStr parameters:dic success:success failure:failure];
    

    
    
//    /**
//     *  sougou
//     */
//    
//    NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithCapacity:0];
//    [dic setValue:@"city:全国" forKey:@"range"];
//    [dic setValue:[NSString stringWithFormat:@"keyword:%@",keyWord] forKey:@"what"];
//    
//    NSString *  urlStr = @"http://api.go2map.com/engine/api/search/json";
//
//    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    [manager GET:urlStr parameters:dic success:success failure:failure];
//
    
//    /**
//     *  谷歌
//     */
//    
//    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy defaultPolicy];
//    securityPolicy.allowInvalidCertificates = YES;
//    [AFHTTPRequestOperationManager manager].securityPolicy = securityPolicy;
//    
//    NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithCapacity:0];
//    NSString * loc = [NSString stringWithFormat:@"%f,%f",lat,lng];;
//    [dic setValue:loc forKey:@"location"];
//    [dic setValue:@"en" forKey:@"language"];
//    [dic setValue:@(50000) forKey:@"radius"];
//    [dic setValue:@"AIzaSyAFjcj5LmbOxOLPRbums3DvZiMaT38DfVI" forKey:@"key"];
//    
//    
//    [dic setValue:keyWord forKey:@"name"];
//    
//    NSString * keytype = nil;
//    switch (poiType) {
//        case 0:
//            // 美食 food
//            keytype = @"bakery | bar | cafe | food | restaurant";
//            break;
//        case 1:
//            // 观光
//            
//            keytype = @"beauty_salon | bowling_alley | campground | casino | gym | hair_care | movie_rental | movie_theater | night_club | spa";
//            break;
//        case 2:
//            keytype = @"aquarium | art_gallery | bicycle_store | book_store | church|city_hall | clothing_store | embassy|florist | furniture_store | grocery_or_supermarket | hardware_store | home_goods_store | jewelry_store | library | mosque | museum |park | post_office | university | shoe_store | shopping_mall | stadium | train_station | zoo";
//            // 购物 shopping_mall
//            break;
//        case 3:
//            keytype = @"lodging";
//            // 酒店
//            break;
//        default:
//            break;
//    }
//    
//    NSString *  urlStr = @"https://maps.googleapis.com/maps/api/place/nearbysearch/json";
//
//    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    [manager GET:urlStr parameters:dic success:success failure:failure];
//
}


#pragma mark - Common
+ (NSMutableDictionary *)commonComonPar
{
    NSMutableDictionary  * paragramer = [NSMutableDictionary dictionaryWithCapacity:0];
    if ([[LoginStateManager getInstance] userLoginInfo].token){
//    [paragramer setValue:[[LoginStateManager getInstance] userLoginInfo].token forKey:@"token"];
        [paragramer setValue:@"94dc0f74bdcbf9223f225af188be245b" forKey:@"token"];
    }
    
    return paragramer;
}

+ (void)missParagramercallBackFailure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSError * error = [NSError errorWithDomain:@"Deomin" code:0
                                      userInfo:@{@"error":@"缺少参数"}];
    failure(nil,error);
}
@end

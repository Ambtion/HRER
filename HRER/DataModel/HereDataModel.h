//
//  HereDataModel.h
//  HRER
//
//  Created by quke on 16/5/30.
//  Copyright © 2016年 linjunhou. All rights reserved.
//


#import "YYModel.h"
#import "ModelDefine.h"

@interface HRPotoInfo : NSObject<NSCopying,NSCoding>
@property(nonatomic,strong)NSString * url;
@property(nonatomic,assign)CGFloat width;
@property(nonatomic,assign)CGFloat height;
@end

@interface HRUserLoginInfo : NSObject<NSCopying,NSCoding>

@property(nonatomic,strong)NSString * user_id;
@property(nonatomic,strong)NSString * name;
@property(nonatomic,strong)NSString * image;
@property(nonatomic,strong)NSString * phone;
@property(nonatomic,strong)NSString * token;
@property(nonatomic,strong)NSString * passport_num;

@property(nonatomic,assign)BOOL weixin;
@property(nonatomic,assign)BOOL qq;

@end


@interface HRUserHomeInfo :  NSObject<NSCopying,NSCoding>

@property(nonatomic,strong)NSString * user_id;
@property(nonatomic,strong)NSString * cur_user_id;
@property(nonatomic,strong)NSString * name;
@property(nonatomic,strong)NSString * passport_num;
@property(nonatomic,strong)NSString * image;
@property(nonatomic,assign)NSInteger f_num;
@property(nonatomic,assign)NSInteger f_city_num;
@property(nonatomic,assign)NSInteger city_num;

@property(nonatomic,assign)NSInteger food;
@property(nonatomic,assign)NSInteger tour;
@property(nonatomic,assign)NSInteger shop;
@property(nonatomic,assign)NSInteger hotel;

@property(nonatomic,assign)NSInteger is_focus;


@property(nonatomic,strong)NSArray * photos; ///< Array<HRImageInfo>

@end

@interface HRFriendsInfo : NSObject<NSCopying,NSCoding>

@property(nonatomic,strong)NSString * uid;
@property(nonatomic,strong)NSString * name;
@property(nonatomic,strong)NSString * image;
@property(nonatomic,strong)NSString * subName;
@property(nonatomic,strong)NSString * userInfo;
@property(nonatomic,assign)NSInteger isFollow;

@end

@interface HRCatergoryInfo : NSObject
@property(nonatomic,assign)NSInteger food;
@property(nonatomic,assign)NSInteger tour;
@property(nonatomic,assign)NSInteger shop;
@property(nonatomic,assign)NSInteger hotel;
@end

@interface HRPOISetInfo : NSObject<NSCopying,NSCopying>

@property(nonatomic,strong)NSString * creator_id;
@property(nonatomic,strong)NSString * creator_name;
@property(nonatomic,assign)NSInteger city_id;
@property(nonatomic,strong)NSString * city_name;
@property(nonatomic,assign)NSInteger type;

@property(nonatomic,strong)NSString  * portrait;
@property(nonatomic,strong)NSString * title;
@property(nonatomic,strong)NSArray * photos; ///< Array<HRImageInfo>

@property(nonatomic,assign)NSInteger poi_type;
@property(nonatomic,assign)NSInteger poi_num;
@end


@interface HRPOIInfo : NSObject<NSCopying,NSCopying>

@property(nonatomic,assign)NSInteger ctime;
@property(nonatomic,strong)NSString * ctimeStr;

@property(nonatomic,strong)NSString * poi_id;
@property(nonatomic,assign)NSInteger type;
@property(nonatomic,strong)NSString * typeName;
@property(nonatomic,strong)NSString * title;
@property(nonatomic,strong)NSString * address;

@property(nonatomic,strong)NSString * creator_id;
@property(nonatomic,strong)NSString * creator_name;
@property(nonatomic,strong)NSString * portrait;
@property(nonatomic,assign)NSInteger recommand;
@property(nonatomic,strong)NSString * intro;
@property(nonatomic,assign)BOOL intend;

@property(nonatomic,assign)CGFloat lat;
@property(nonatomic,assign)CGFloat lng;

@property(nonatomic,strong)NSString * city_name;
@property(nonatomic,assign)NSInteger city_id;

@property(nonatomic,strong)NSArray * photos; ///< Array<HRImageInfo>
 //想去逻辑
@property(nonatomic,assign)NSInteger single_type;
@property(nonatomic,strong)NSString * userWantTo;

@property(nonatomic,strong)HRPotoInfo * seal;

@end

@interface HRCretePOIInfo : NSObject<NSCopying,NSCopying>

@property(nonatomic,strong)NSString * iconStr;
@property(nonatomic,strong)NSString * location;
@property(nonatomic,strong)NSString * title;
@property(nonatomic,strong)NSString * subTitle;
@property(nonatomic,assign)CGFloat distance;
@end

@interface HRGooglPoiInfo : HRCretePOIInfo

@end


@interface HRRecomend : NSObject<NSCopying,NSCopying>

@property(nonatomic,strong)NSString * cmnt_id; //评论Id
@property(nonatomic,strong)NSString * content;  //评论内容

@property(nonatomic,strong)NSString * user_id;
@property(nonatomic,strong)NSString * user_name;
@property(nonatomic,strong)NSString * portrait;

@property(nonatomic,strong)NSString * reply_id; //回复人
@property(nonatomic,strong)NSString * reply_name;


@end


@interface HRHomePoiInfo : NSObject<NSCopying,NSCopying>

@property(nonatomic,strong)NSString * cityid;
@property(nonatomic,strong)NSString * city_name;

@property(nonatomic,assign)NSInteger food;
@property(nonatomic,assign)NSInteger tour;
@property(nonatomic,assign)NSInteger shop;
@property(nonatomic,assign)NSInteger hotel;

@property(nonatomic,strong)NSArray * cityPoiList;

@end

@interface HRMouthPoiList : NSObject<NSCopying,NSCopying>
@property(nonatomic,strong)NSString * month;
@property(nonatomic,strong)NSArray * timePoiList;
@end

@interface HRRecomendDetail : NSObject<NSCopying,NSCopying>

@property (nonatomic,strong)NSString * poi_id;
@property (nonatomic,strong)NSString * cityid;
@property (nonatomic,strong)NSString * city_name;
@property (nonatomic,strong)NSString * englishname;

@property (nonatomic,assign)NSInteger  type;


@property (nonatomic,strong)NSString * cmt_id;

@property (nonatomic,strong)NSString * user_id;
@property (nonatomic,strong)NSString * user_name;
@property (nonatomic,strong)NSString * portrait;

@property (nonatomic,strong)NSString *  title;
@property (nonatomic,strong)NSString * content;
@property (nonatomic,strong)NSString * time;

@end

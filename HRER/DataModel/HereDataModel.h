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

@property(nonatomic,strong)NSString * creatorId;
@property(nonatomic,strong)NSString * creatorName;
@property(nonatomic,assign)NSInteger type;

@property(nonatomic,strong)NSString * portrait;
@property(nonatomic,strong)NSString * title;
@property(nonatomic,strong)NSArray * photos; ///< Array<HRImageInfo>

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
@property(nonatomic,assign)CGGlyph lng;

@property(nonatomic,strong)NSString * city_name;
@property(nonatomic,assign)NSInteger city_id;

@property(nonatomic,strong)NSArray * photos; ///< Array<HRImageInfo>

@end

@interface HRCretePOIInfo : NSObject<NSCopying,NSCopying>

@property(nonatomic,strong)NSString * iconStr;
@property(nonatomic,strong)NSString * location;
@property(nonatomic,strong)NSString * title;
@property(nonatomic,strong)NSString * subTitle;
@property(nonatomic,assign)NSInteger distance;

@end

@interface HRRecomend : NSObject<NSCopying,NSCopying>

@property(nonatomic,strong)NSString * cmnt_id; //评论Id
@property(nonatomic,strong)NSString * content;  //评论内容

@property(nonatomic,strong)NSString * user_id;
@property(nonatomic,strong)NSString * user_name;

@property(nonatomic,strong)NSString * reply_id; //回复人
@property(nonatomic,strong)NSString * reply_name;

@end


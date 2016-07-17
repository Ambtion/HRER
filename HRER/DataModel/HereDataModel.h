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

@property(nonatomic,strong)NSString * phone;
@property(nonatomic,strong)NSString * token;
@property(nonatomic,strong)NSString * passport_num;
@property(nonatomic,strong)NSString * name;

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

@property(nonatomic,strong)NSString * creator_id;
@property(nonatomic,strong)NSString * creator_name;
@property(nonatomic,strong)NSString * portrait;

@property(nonatomic,strong)NSString * poi_id;
@property(nonatomic,assign)NSInteger type;
@property(nonatomic,strong)NSString * title;
@property(nonatomic,strong)NSString * intro;

@property(nonatomic,assign)CGFloat lat;
@property(nonatomic,assign)CGGlyph lng;

@property(nonatomic,strong)NSString * city_name;
@property(nonatomic,assign)NSInteger city_id;

@property(nonatomic,strong)NSArray * photos; ///< Array<HRImageInfo>

@end


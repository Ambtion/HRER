//
//  HereDataModel.h
//  HRER
//
//  Created by quke on 16/5/30.
//  Copyright © 2016年 linjunhou. All rights reserved.
//


#import "YYModel.h"

@interface HRPotoInfo : NSObject<NSCopying,NSCoding>
//@property(nonatomic,strong)NSString *
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

@interface HRPOISetInfo : NSObject<NSCopying,NSCopying>

@property(nonatomic,strong)NSString * portrait;
@property(nonatomic,strong)NSString * title;
@property(nonatomic,strong)NSArray * photos; ///< Array<HRImageInfo>

@end
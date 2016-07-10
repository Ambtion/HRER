//
//  HereDataModel.h
//  HRER
//
//  Created by quke on 16/5/30.
//  Copyright © 2016年 linjunhou. All rights reserved.
//


#import "YYModel.h"

@interface HRUserLoginInfo : NSObject<NSCopying,NSCoding>

@property(nonatomic,strong)NSString * phone;
@property(nonatomic,strong)NSString * token;
@property(nonatomic,strong)NSString * passport_num;
@property(nonatomic,strong)NSString * name;

@end



@interface HRFriendsInfo : NSObject<NSCopying,NSCoding>

@end
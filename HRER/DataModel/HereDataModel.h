//
//  HereDataModel.h
//  HRER
//
//  Created by quke on 16/5/30.
//  Copyright © 2016年 linjunhou. All rights reserved.
//


#import "YYModel.h"

@interface CityInfo : NSObject<NSCopying,NSCopying>

@property(nonatomic,assign)NSInteger city_id;
@property(nonatomic,strong)NSString * city_name;
@property(nonatomic,assign)CGFloat latitude;
@property(nonatomic,assign)CGFloat longitude;

@end
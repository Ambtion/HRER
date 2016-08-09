//
//  HereDataModel.m
//  HRER
//
//  Created by quke on 16/5/30.
//  Copyright © 2016年 linjunhou. All rights reserved.
//

#import "HereDataModel.h"

#define YYModelSynthCoderAndHash \
- (void)encodeWithCoder:(NSCoder *)aCoder { [self yy_modelEncodeWithCoder:aCoder]; } \
- (id)initWithCoder:(NSCoder *)aDecoder { return [self yy_modelInitWithCoder:aDecoder]; } \
- (id)copyWithZone:(NSZone *)zone { return [self yy_modelCopy]; } \
- (NSUInteger)hash { return [self yy_modelHash]; } \
- (BOOL)isEqual:(id)object { return [self yy_modelIsEqual:object]; }


@implementation HRPotoInfo

YYModelSynthCoderAndHash

@end

@implementation HRUserLoginInfo

YYModelSynthCoderAndHash

@end

@implementation HRUserHomeInfo

YYModelSynthCoderAndHash
@end

@implementation HRFriendsInfo

YYModelSynthCoderAndHash

@end

@implementation HRPOISetInfo

YYModelSynthCoderAndHash

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"photos" : [HRPotoInfo class]};
}

@end

@implementation HRCatergoryInfo

YYModelSynthCoderAndHash

@end

@implementation HRPOIInfo

YYModelSynthCoderAndHash

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"photos" : [HRPotoInfo class]};
}

@end

@implementation HRCretePOIInfo

YYModelSynthCoderAndHash

+ (nullable NSDictionary<NSString *, id> *)modelCustomPropertyMapper
{
    return @{
             @"iconStr" : @"pname",
             @"location": @"location",
             @"title": @"name",
             @"subTitle":@"address"
             };
}


@end

@implementation HRGooglPoiInfo
+ (nullable NSDictionary<NSString *, id> *)modelCustomPropertyMapper
{
    return @{
             @"iconStr" : @"icon",
             @"location": @"location",
             @"title": @"name",
             @"subTitle":@"vicinity"
             };
}
@end

@implementation HRRecomend

YYModelSynthCoderAndHash;

@end

@implementation HRHomePoiInfo

YYModelSynthCoderAndHash;

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"cityPoiList" : [HRMouthPoiList class]};
}
@end

@implementation HRMouthPoiList

YYModelSynthCoderAndHash;

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"timePoiList" : [HRPOIInfo class]};
}


@end

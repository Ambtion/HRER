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
- (NSString *)name
{
    if (_name) {
        return [_name stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    }
    return @"";
}

@end

@implementation HRUserHomeInfo

YYModelSynthCoderAndHash


- (NSString *)name
{
    if (_name) {
        return [_name stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    }
    return @"";
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"photos" : [HRPotoInfo class]};
}


@end

@implementation HRFriendsInfo

YYModelSynthCoderAndHash

- (NSString *)name
{
    if (_name) {
        return [_name stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    }
    return @"";
}

@end

@implementation HRPOISetInfo

YYModelSynthCoderAndHash

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"photos" : [HRPotoInfo class]};
}


- (NSString *)creator_name
{
    if (_creator_name) {
        return [_creator_name stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    }
    return @"";

}

- (NSString *)title
{
    if (_title) {
        return [_title stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    }
    return @"";

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

- (NSString *)title
{
    if (_title) {
        return [_title stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    }
    return @"";
}

- (NSString *)intro
{
    if (_intro) {
        return [_intro stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    }
    return @"";
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

- (NSString *)content
{
    if (_content.length) {
        return [_content stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    }
    return @"";
}



- (NSString *)user_name
{
    if (_user_name) {
        return [_user_name stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    }
    return @"";
    
}


- (NSString *)reply_name
{
    if (_reply_name) {
        return [_reply_name stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    }
    return @"";
    
}

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

@implementation HRRecomendDetail

YYModelSynthCoderAndHash;

- (NSString *)user_name
{
    if (_user_name) {
        return [_user_name stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    }
    return @"";
    
}

- (NSString *)content
{
    if (_content) {
        return [_content stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    }
    return @"";
    
}


@end
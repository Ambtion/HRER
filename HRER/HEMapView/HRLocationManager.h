//
//  HELocationManager.h
//  HRER
//
//  Created by quke on 16/5/20.
//  Copyright © 2016年 linjunhou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>


@class CLLocation;

@interface HRLocationManager : NSObject

@property(nonatomic,strong,readonly)CLLocation * curLocation;
@property(nonatomic,strong,readonly)CLPlacemark * placeMark;

+ (HRLocationManager *)sharedInstance;

- (void)startLocaiton;


@end

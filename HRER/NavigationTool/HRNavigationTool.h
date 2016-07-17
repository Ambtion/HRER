//
//  HRNavigationTool.h
//  HRER
//
//  Created by quke on 16/5/26.
//  Copyright © 2016年 linjunhou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface HRNavigationTool : NSObject

+ (void)actionSheetByController:(UIViewController *)controller
                      TLocaiton:(CLLocationCoordinate2D)toCoordinate
                      UrlScheme:(NSString *)urlScheme
                        appName:(NSString *)appName;

+ (NSString *)distanceBetwenOriGps:(CLLocationCoordinate2D)oriGps desGps:(CLLocationCoordinate2D)desGps;
@end


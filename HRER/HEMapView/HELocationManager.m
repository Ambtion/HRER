//
//  HELocationManager.m
//  HRER
//
//  Created by quke on 16/5/20.
//  Copyright © 2016年 linjunhou. All rights reserved.
//

#import "HELocationManager.h"
#import <UIKit/UIKit.h>

@interface HELocationManager()<CLLocationManagerDelegate>

@property(nonatomic,strong)CLLocationManager * locationManager;
@property(nonatomic,strong)CLLocation * curLocaiton;

@end

@implementation HELocationManager

+ (HELocationManager *)sharedInstance {
    
    static HELocationManager *_sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[HELocationManager alloc] init];
    });
    return _sharedInstance;
}


- (void)startLocaiton
{
    if (!_locationManager) {
        
        _locationManager = [[CLLocationManager alloc] init];
        
        _locationManager.delegate = self;
        
        [_locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
        
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8) {
            [self.locationManager requestAlwaysAuthorization]; //
        }
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 9) {
            _locationManager.allowsBackgroundLocationUpdates = YES;
        }
    }
    [_locationManager startUpdatingLocation];
}

#pragma mark - Locaiton
- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    switch (status) {
        case kCLAuthorizationStatusNotDetermined:
            if ([_locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
                [_locationManager requestWhenInUseAuthorization];
            }
            break;
        default:
            break;
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations
{
    self.curLocaiton = [locations lastObject];
    
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:self.curLocaiton completionHandler:^(NSArray *array, NSError *error) {
        if (array.count > 0) {
            
            CLPlacemark *placemark = [array objectAtIndex:0];
//            MapLocation *annotation = [[MapLocation alloc] init];
//            annotation.streetAddress = placemark.thoroughfare;
//            annotation.city = placemark.locality;
//            annotation.state = placemark.administrativeArea;
//            annotation.zip = placemark.postalCode;
//            annotation.coordinate = coord;
            //将定位的点添加到地图
//            [self.myMap addAnnotation:annotation];
        }
    }];
}

@end


//
//  HELocationManager.m
//  HRER
//
//  Created by quke on 16/5/20.
//  Copyright © 2016年 linjunhou. All rights reserved.
//

#import "HRLocationManager.h"
#import <UIKit/UIKit.h>

@interface HRLocationManager()<CLLocationManagerDelegate>

@property(nonatomic,strong)CLLocationManager * locationManager;
@property(nonatomic,assign)BOOL isFirstGEO;

@property(nonatomic,strong)CLLocation * curLocation;
@property(nonatomic,strong)CLPlacemark * placeMark;

@end

@implementation HRLocationManager

+ (HRLocationManager *)sharedInstance {
    
    static HRLocationManager *_sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[HRLocationManager alloc] init];
    });
    return _sharedInstance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.isFirstGEO = YES;
    }
    return self;
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

    self.curLocation = [locations lastObject];
    if (self.isFirstGEO) {
        CLGeocoder *geocoder = [[CLGeocoder alloc] init];
        [geocoder reverseGeocodeLocation:self.curLocation completionHandler:^(NSArray *array, NSError *error) {
            if (array.count > 0) {
                
                self.isFirstGEO = NO;
                self.placeMark = [array objectAtIndex:0];
            }
        }];
    }
    
}

@end


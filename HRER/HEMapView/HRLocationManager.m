//
//  HELocationManager.m
//  HRER
//
//  Created by quke on 16/5/20.
//  Copyright © 2016年 linjunhou. All rights reserved.
//

#import "HRLocationManager.h"
#import "NetWorkEntity.h"

@interface HRLocationManager(Cache)
- (void)writeCityName:(NSString *)cityName;
- (void)writeCityId:(NSInteger)cityID;
- (void)writeEnname:(NSString *)enName;
- (void)wirteLocation:(CLLocation *)location;
@end

@implementation HRLocationManager(Cache)

- (void)writeCityName:(NSString *)cityName
{
    [[NSUserDefaults standardUserDefaults] setValue:cityName forKey:@"cityName"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
- (void)writeCityId:(NSInteger)cityID
{
    [[NSUserDefaults standardUserDefaults] setValue:@(cityID) forKey:@"cityID"];
    [[NSUserDefaults standardUserDefaults] synchronize];

}
- (void)writeEnname:(NSString *)enName
{
    [[NSUserDefaults standardUserDefaults] setValue:enName forKey:@"enName"];
    [[NSUserDefaults standardUserDefaults] synchronize];

}
- (void)wirteLocation:(CLLocation *)location
{
    [[NSUserDefaults standardUserDefaults] setValue:@(location.coordinate.latitude) forKey:@"latitude"];
    [[NSUserDefaults standardUserDefaults] setValue:@(location.coordinate.longitude) forKey:@"longitude"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    

}

- (NSString *)readCityName
{
    return [[NSUserDefaults standardUserDefaults] valueForKey:@"cityName"];
}

- (NSInteger )readCityId
{
    return [[[NSUserDefaults standardUserDefaults] valueForKey:@"cityID"] integerValue];
}
- (NSString *)readEnname
{
    return [[NSUserDefaults standardUserDefaults] valueForKey:@"enName"];
}
- (CLLocation *)readLocation
{
    CGFloat lat = [[[NSUserDefaults standardUserDefaults] valueForKey:@"latitude"] floatValue];
    CGFloat lng = [[[NSUserDefaults standardUserDefaults] valueForKey:@"longitude"] floatValue];
    return [[CLLocation alloc] initWithLatitude:lat longitude:lng];
}

@end
@interface HRLocationManager()<CLLocationManagerDelegate>
{
    NSInteger  _curCityID;
    NSString * _en_name;
}

@property(nonatomic,assign)BOOL isFirstGEO;

@property(nonatomic,strong)CLLocationManager * locationManager;
@property(nonatomic,strong)CLLocation * curLocation;
@property(nonatomic,strong)NSString * cityName;
//@property(nonatomic,strong)NSString * subCityName;

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
        self.curLocation = [self readLocation];
        _curCityID = [self readCityId];
        _en_name = [self readEnname];
        self.cityName = [self readCityName];
        
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
        
        self.isFirstGEO = NO;
        
        CLGeocoder *geocoder = [[CLGeocoder alloc] init];
        [geocoder reverseGeocodeLocation:self.curLocation completionHandler:^(NSArray *array, NSError *error) {
            if (array.count > 0) {
                CLPlacemark * placeMark = [array objectAtIndex:0];
                if (placeMark) {
                    self.cityName = placeMark.locality;
//                    self.subCityName = placeMark.subLocality;
                    
                    [NetWorkEntity  quaryCityInfoWithCityName:placeMark.locality  lat:self.curLocation.coordinate.latitude lng:self.curLocation.coordinate.longitude success:^(AFHTTPRequestOperation *operation, id responseObject) {
                        if ([[responseObject objectForKey:@"result"] isEqualToString:@"OK"]) {
                            NSDictionary * userInfoDic  = [responseObject objectForKey:@"response"];
                            _curCityID = [[userInfoDic objectForKey:@"city_id"] integerValue];
                            _en_name = [userInfoDic objectForKey:@"en_name"];
                            [self writeData];
                            [[NSNotificationCenter defaultCenter] postNotificationName:LocaitonDidUpdateSucess object:nil];
                        }else{
                            self.isFirstGEO = YES;
                        }
                    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                        self.isFirstGEO = YES;
                    }];
                }
            }else{
                self.isFirstGEO = YES;
            }
        }];
    }
    
}

#pragma mark - Cache
- (void)writeData
{
    [self writeCityId:self.curCityId];
    [self writeCityName:self.cityName];
    [self wirteLocation:self.curLocation];
    [self writeEnname:self.cityEnName];
}


#pragma mark -
- (NSInteger)curCityId
{
    return _curCityID;
}

//- (NSString *)subCityName
//{
//    return self.subCityName;
//}

- (NSString *)cityEnName
{
    return _en_name;
}

@end


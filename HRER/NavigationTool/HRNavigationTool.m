//
//  HRNavigationTool.m
//  HRER
//
//  Created by quke on 16/5/26.
//  Copyright © 2016年 linjunhou. All rights reserved.
//

#import "HRNavigationTool.h"
#import "HRLocationManager.h"


@implementation HRNavigationTool


+ (void)actionSheetByController:(UIViewController *)controller
                      TLocaiton:(CLLocationCoordinate2D)toCoordinate
                      UrlScheme:(NSString *)urlScheme
                        appName:(NSString *)appName

{

    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"选择地图" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    //这个判断其实是不需要的
    if ( [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"http://maps.apple.com/"]])
    {
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"苹果地图" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            
            MKMapItem *fromLocaiton = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:[[HRLocationManager sharedInstance] curLocation].coordinate addressDictionary:nil]];
            MKMapItem *toLocation = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:toCoordinate addressDictionary:nil]];
            
            [MKMapItem openMapsWithItems:@[fromLocaiton, toLocation]
                           launchOptions:@{MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving,MKLaunchOptionsShowsTrafficKey: [NSNumber numberWithBool:YES]}];
        }];

        [alert addAction:action];
    }
    
    if ( [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"baidumap://"]])
    {
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"百度地图" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            
            NSString *urlString = [[NSString stringWithFormat:@"baidumap://map/direction?origin={{我的位置}}&destination=latlng:%f,%f|name=目的地&mode=driving&coord_type=gcj02",toCoordinate.latitude, toCoordinate.longitude] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
            
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
            
        }];
        
        [alert addAction:action];
    }
    
    
    if ( [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"iosamap://"]])
    {
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"高德地图" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            
            NSString *urlString = [[NSString stringWithFormat:@"iosamap://navi?sourceApplication=%@&backScheme=%@&lat=%f&lon=%f&dev=0&style=2",appName,urlScheme,toCoordinate.latitude, toCoordinate.longitude] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
            
        }];
        
        [alert addAction:action];
    }
    
    if ( [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"comgooglemaps://"]])
    {
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"谷歌地图" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            
            NSString *urlString = [[NSString stringWithFormat:@"comgooglemaps://?x-source=%@&x-success=%@&saddr=&daddr=%f,%f&directionsmode=driving",appName,urlScheme,toCoordinate.latitude, toCoordinate.longitude] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
            
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
            
        }];
        
        [alert addAction:action];
    }
    
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:action];
    
    [controller presentViewController:alert animated:YES completion:^{
    }];
}

+ (NSString *)distanceBetwenOriGps:(CLLocationCoordinate2D)oriGps desGps:(CLLocationCoordinate2D)desGps
{
    
    CGFloat distance = [self distancenumberBetwenOriGps:oriGps desGps:desGps];
    return [self distanceStr:distance];
}

+ (NSString *)distanceStr:(CGFloat)distance
{
    if (distance < 1000) {
        return [NSString stringWithFormat:@"%.1fm",(distance)];
    }else{
        CGFloat kmDistance = (distance / 1000.f);
        if (kmDistance > 5000) {
            return @"5000+km";
        }else{
            return [NSString stringWithFormat:@"%.1fkm",kmDistance];
        }
    }
    return @"";

}

+ (CGFloat)distancenumberBetwenOriGps:(CLLocationCoordinate2D)oriGps desGps:(CLLocationCoordinate2D)desGps
{
    CLLocation * location = [[CLLocation alloc] initWithLatitude:oriGps.latitude longitude:oriGps.longitude];
    CLLocation * desLocaiton = [[CLLocation alloc] initWithLatitude:desGps.latitude longitude:desGps.longitude];
    CLLocationDistance distance = [location distanceFromLocation:desLocaiton];

    return distance;
}
@end

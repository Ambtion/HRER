//
//  HRLocationMapController.h
//  HRER
//
//  Created by quke on 16/7/20.
//  Copyright © 2016年 linjunhou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@protocol HRLocationMapControllerDelegate <NSObject>

- (void)locationMapControllerDidChangePoiName:(NSString *)poiName
                                   poiAddress:(NSString *)address
                                      poiType:(NSInteger)poiType
                       CLLocationCoordinate2D:(CLLocationCoordinate2D)coord;

@end

@interface HRLocationMapController : UIViewController

@property(nonatomic,weak)id<HRLocationMapControllerDelegate> delegate;

@end

//
//  HRLocationMapController.h
//  HRER
//
//  Created by quke on 16/7/20.
//  Copyright © 2016年 linjunhou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "HRLocationCategoryView.h"


@interface HRLocationMapController : UIViewController

/**
 *  CityInfo
 */
@property(nonatomic,strong)NSString * cityName;
@property(nonatomic,assign)NSInteger cityId;
@property(nonatomic,assign)CGFloat lat;
@property(nonatomic,assign)CGFloat lng;
@property(nonatomic,assign)NSInteger categoryIndex;

@property(nonatomic,strong)HRLocationCategoryView * categoryView;

- (void)initMapShow;

@end

//
//  HRPoiSetsController.h
//  HRER
//
//  Created by kequ on 16/6/15.
//  Copyright © 2016年 linjunhou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ModelDefine.h"

@interface HRPoiSetsController : UIViewController

- (instancetype)initWithPoiSetCreteType:(KPoiSetsCreteType)creteType
                                creteId:(NSString *)userID
                                city_Id:(NSInteger)cityId
                               cityName:(NSString *)cityName
                              poiNumber:(NSInteger)poiNumber
                                poiName:(NSString *)poiTitle
                          creteUserName:(NSString *)creteUserName
                               category:(NSInteger)categoryType;



@end

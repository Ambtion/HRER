//
//  HRAnomation.m
//  HRER
//
//  Created by quke on 16/5/23.
//  Copyright © 2016年 linjunhou. All rights reserved.
//

#import "HRAnomation.h"

@interface HRAnomation()
@end

@implementation HRAnomation

-(id)initWithCoordinates:(CLLocationCoordinate2D)paramCoordinates
                   title:(NSString *)paramTitle
                subTitle:(NSString *)paramSubitle
{
    self = [super init];
    if(self != nil)
    {
        _coordinate = paramCoordinates;
        _title = paramTitle;
        _subtitle = paramSubitle;
    }
    return self;
}

@end

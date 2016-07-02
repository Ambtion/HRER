//
//  HRAnomation.h
//  HRER
//
//  Created by quke on 16/5/23.
//  Copyright © 2016年 linjunhou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface HRAnomation : NSObject<MKAnnotation>

@property(nonatomic,readonly)CLLocationCoordinate2D coordinate;
@property(nonatomic,copy,readonly)NSString * title;
@property(nonatomic,copy,readonly)NSString * subtitle;
@property(nonatomic,strong)id extData;
@property(nonatomic,assign)NSInteger index;

-(id)initWithCoordinates:(CLLocationCoordinate2D)paramCoordinates
                   title:(NSString *)paramTitle
                subTitle:(NSString *)paramSubitle;

@end

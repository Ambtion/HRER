//
//  HRPinAnnomationView.h
//  HRER
//
//  Created by quke on 16/5/23.
//  Copyright © 2016年 linjunhou. All rights reserved.
//

#import <MapKit/MapKit.h>
#import "HRAnomation.h"


@interface HRPinAnnomationView : MKAnnotationView

@property(nonatomic,strong)HRAnomation* anomationData;

- (instancetype)initWithAnnotation:(id<MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier;

@end

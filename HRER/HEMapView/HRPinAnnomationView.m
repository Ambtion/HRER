//
//  HRPinAnnomationView.m
//  HRER
//
//  Created by quke on 16/5/23.
//  Copyright © 2016年 linjunhou. All rights reserved.
//

#import "HRPinAnnomationView.h"
#import "HereDataModel.h"

@interface HRPinAnnomationView()
@end

@implementation HRPinAnnomationView

- (instancetype)initWithAnnotation:(id<MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if (self) {
        self.annotation = annotation;
    }
    return self;
}

- (void)setAnomationData:(HRAnomation *)anomationData
{
    _anomationData = anomationData;
    if ([self isSelected]) {
        self.image = [self seletedImaeForType:[(HRPOIInfo *)_anomationData.extData type]];
    }else{
        self.image = [self normalImageForType:[(HRPOIInfo *)_anomationData.extData type]];
    }
}

- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    if (selected) {
        self.image = [self seletedImaeForType:[(HRPOIInfo *)_anomationData.extData type]];
    }else{
        self.image = [self normalImageForType:[(HRPOIInfo *)_anomationData.extData type]];
    }

}

// 1=>"美食", 2=>"观光", 3=>"休闲", 4=>"酒店"
- (UIImage *)normalImageForType:(NSInteger)type
{
    switch (type) {
        case 1:
            return [UIImage imageNamed:@"map_food"];
            break;
        case 2:
            return [UIImage imageNamed:@"map_look"];
            break;
        case 3:
            return [UIImage imageNamed:@"shopping"];
        case 4:
            return [UIImage imageNamed:@"map_hotel_click"];
        default:
            break;
    }
    return [UIImage imageNamed:@"map_food"];;
}

- (UIImage *)seletedImaeForType:(NSInteger)type
{
    switch (type) {
        case 1:
            return [UIImage imageNamed:@"map_food_click"];
            break;
        case 2:
            return [UIImage imageNamed:@"map_look_click"];
            break;
        case 3:
            return [UIImage imageNamed:@"shopping_click"];
        case 4:
            return [UIImage imageNamed:@"map_hotel_click_click"];
        default:
            break;
    }
    return [UIImage imageNamed:@"map_food_click"];;
}

@end

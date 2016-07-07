//
//  HRPinAnnomationView.m
//  HRER
//
//  Created by quke on 16/5/23.
//  Copyright © 2016年 linjunhou. All rights reserved.
//

#import "HRPinAnnomationView.h"
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
}

- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    self.image = !selected ? [UIImage imageNamed:@"map_food"] : [UIImage imageNamed:@"map_food_click"];
}
@end

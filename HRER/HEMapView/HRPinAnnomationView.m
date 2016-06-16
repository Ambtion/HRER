//
//  HRPinAnnomationView.m
//  HRER
//
//  Created by quke on 16/5/23.
//  Copyright © 2016年 linjunhou. All rights reserved.
//

#import "HRPinAnnomationView.h"
@interface HRPinAnnomationView()
@property(nonatomic,strong)UIImageView * bgImageView;
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
    self.bgImageView.image = [UIImage imageNamed:@"location"];
}

- (UIImageView *)bgImageView
{
    if (!_bgImageView) {
        _bgImageView = [[UIImageView alloc] initWithFrame:self.bounds];
        [self addSubview:_bgImageView];
    }
    return _bgImageView;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.bgImageView.frame = self.bounds;
}
@end

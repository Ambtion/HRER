//
//  HRPoiUserInfo.h
//  HRER
//
//  Created by kequ on 16/7/14.
//  Copyright © 2016年 linjunhou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HRPoiUserInfo : UIView

@property(nonatomic,strong)UIImageView * porImageView;


+ (CGFloat)heightForView;

- (void)setDtata:(HRPOIInfo *)data;

@end


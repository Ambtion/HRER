//
//  HRUserHomeController.h
//  HRER
//
//  Created by kequ on 16/7/17.
//  Copyright © 2016年 linjunhou. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,KUserHomeControllerState) {
    KUserHomeControllerStateRoot,
    KUserHomeControllerStatePush
};


@interface HRUserHomeController : UIViewController


- (instancetype)initWithUserID:(NSString *)userId controllerState:(KUserHomeControllerState)state;

@end

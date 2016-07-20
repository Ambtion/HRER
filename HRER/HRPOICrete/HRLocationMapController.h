//
//  HRLocationMapController.h
//  HRER
//
//  Created by quke on 16/7/20.
//  Copyright © 2016年 linjunhou. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol HRLocationMapControllerDelegate <NSObject>


@end

@interface HRLocationMapController : UIViewController

@property(nonatomic,weak)id<HRLocationMapControllerDelegate> delegate;

@end

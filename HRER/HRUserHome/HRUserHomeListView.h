//
//  HRUserHomeListView.h
//  HRER
//
//  Created by quke on 16/7/19.
//  Copyright © 2016年 linjunhou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HRUserHomeController.h"

@interface HRUserHomeListView : UIView

@property(nonatomic,weak)HRUserHomeController * controller;

-(void)quaryDataWithVisitUserid:(NSString *)userId;

@end

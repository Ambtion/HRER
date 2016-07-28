//
//  FindCityViewController.h
//  HRER
//
//  Created by kequ on 16/5/25.
//  Copyright © 2016年 linjunhou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HRBaseSearchTableViewController.h"


@protocol FindCityViewControllerDelegate <NSObject>

- (void)findCityViewControllerDidSeltedCityInfo:(NSDictionary *)cityInfo;
- (void)findCityViewControllerDidCurCity;
@end

@interface FindCityViewController : HRBaseSearchTableViewController

@property(nonatomic,weak)id<FindCityViewControllerDelegate>delegate;

@end

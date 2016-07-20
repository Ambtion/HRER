//
//  HRLocationCategoryView.h
//  HRER
//
//  Created by kequ on 16/7/20.
//  Copyright © 2016年 linjunhou. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HRLocationCategoryView;
@protocol HRLocationCategoryViewDelegate <NSObject>

- (void)locationCategoryViewDidSeletedIndex:(NSInteger)index;

@end

@interface HRLocationCategoryView : UIView

@property(nonatomic,weak)id<HRLocationCategoryViewDelegate>delegate;

- (void)setSeletedAtIndex:(NSInteger)index;

- (NSInteger)seletedIndex;

@end

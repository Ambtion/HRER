//
//  HRCatergoryScrollView.h
//  HRER
//
//  Created by quke on 16/6/12.
//  Copyright © 2016年 linjunhou. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HRCatergoryScrollView;

@protocol HRCatergoryScrollViewDelegate <NSObject>

- (void)hrCatergoryScrollView:(HRCatergoryScrollView *)view DidSeletedIndex:(NSInteger)index;
- (void)hrCatergoryScrollViewDidCancelSeleted:(HRCatergoryScrollView *)view;

@end

@interface HRCatergoryScrollView : UIView

@property(nonatomic,weak)id<HRCatergoryScrollViewDelegate>delegate;

- (void)setCount:(NSInteger)count atIndex:(NSInteger)index;

- (void)setButtonSeletedAtIndex:(NSInteger)index;

@end

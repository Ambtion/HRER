//
//  HRUserTimeLineHeadView.h
//  HRER
//
//  Created by quke on 16/7/19.
//  Copyright © 2016年 linjunhou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HRUserTimeLineHeadView : UIView

+ (CGFloat)heightForView;

- (void)setDataSource:(HRHomePoiInfo *)dataSource;

@end

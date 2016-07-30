//
//  HRPoiLocInfoCell.h
//  HRER
//
//  Created by kequ on 16/7/13.
//  Copyright © 2016年 linjunhou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HRPoiLocInfoCell : UITableViewCell

+ (CGFloat)heightForCell;

- (void)setDataSource:(HRPOIInfo *)dataSource;

@end

//
//  HRHotCityCell.h
//  HRER
//
//  Created by kequ on 16/7/28.
//  Copyright © 2016年 linjunhou. All rights reserved.
//

#import <UIKit/UIKit.h>


@class HRHotCityCell;
@protocol HRHotCityCellDelegate <NSObject>

- (void)hotCityCellDidSeletedHotCity:(NSDictionary *)cityInfo;

@end

@interface HRHotCityCell : UITableViewCell

@property(nonatomic,weak)id<HRHotCityCellDelegate> delegate;

@property(nonatomic,strong)NSArray * hotArray;

+ (CGFloat)heightForCell;

@end

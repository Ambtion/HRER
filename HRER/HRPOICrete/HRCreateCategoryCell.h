//
//  HRCreateCategoryCell.h
//  HRER
//
//  Created by quke on 16/7/20.
//  Copyright © 2016年 linjunhou. All rights reserved.
//

#import <UIKit/UIKit.h>


@class HRCreateCategoryCell;
@protocol HRCreateCategoryCell <NSObject>
- (void)createCategoryCellDidSeletedIndex:(NSInteger)index;
@end


@interface HRCreateCategoryCell : UITableViewCell

@property(nonatomic,weak)id<HRCreateCategoryCell> delegate;

+ (CGFloat)heightForCell;

- (void)setSeletedAtIndex:(NSInteger)index;

@end

//
//  PoiRecomendCell.h
//  HRER
//
//  Created by quke on 16/7/26.
//  Copyright © 2016年 linjunhou. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PoiRecomendCell;
@protocol PoiRecomendCellDelegate <NSObject>

- (void)poiRecomendCellDidClickDetailPage:(PoiRecomendCell *)cell;
- (void)poiRecomendCellDidClickPortrait:(PoiRecomendCell *)cell;

@end

@interface PoiRecomendCell : UITableViewCell

@property(nonatomic,weak)id<PoiRecomendCellDelegate> delegate;
@property(nonatomic,strong)id dataSource;

+ (CGFloat)heightForCell;


@end

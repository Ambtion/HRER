//
//  HRPoiDetailPhotosCell.h
//  HRER
//
//  Created by kequ on 16/7/13.
//  Copyright © 2016年 linjunhou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HRPhotoScrollView.h"

@class HRPoiDetailPhotosCell;
@protocol HRPoiDetailPhotosCellDelegat <NSObject>

- (void)poiDetailPhotosCellDidClickPhoto:(HRPoiDetailPhotosCell *)cell;

@end

@interface HRPoiDetailPhotosCell : UITableViewCell

@property(nonatomic,strong)HRPhotoScrollView * photosView;

@property(nonatomic,weak)id<HRPoiDetailPhotosCellDelegat> delegate;


+ (CGFloat)heightForCell;

- (void)setDataImages:(NSArray *)array;

- (NSInteger)seletedIndex;

@end

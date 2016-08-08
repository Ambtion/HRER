//
//  HRCretePoiCell.h
//  HRER
//
//  Created by quke on 16/7/20.
//  Copyright © 2016年 linjunhou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HereDataModel.h"

@interface HRCretePoiCell : UITableViewCell

@property(nonatomic,strong)UIImageView * portraitImage;
@property(nonatomic,strong)HRCretePOIInfo * data;
@property(nonatomic,strong)UIView * lineView;


+ (CGFloat)heightforCell;

@end


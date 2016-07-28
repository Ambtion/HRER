//
//  HRCityCell.h
//  HRER
//
//  Created by kequ on 16/7/28.
//  Copyright © 2016年 linjunhou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BMSystemConfigPageCell.h"

@interface HRCityCell : UITableViewCell

@property(nonatomic,strong)NSDictionary * cityInfo;

- (void)setCellType:(CellPositionType)type;

@end

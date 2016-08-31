//
//  HRRecomendCell.h
//  HRER
//
//  Created by kequ on 16/7/14.
//  Copyright © 2016年 linjunhou. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HRRecomendCell;

@protocol HRRecomendCellDelegate <NSObject>

- (void)recomendCellDidClickRecomendButton:(HRRecomendCell *)cell;
- (void)recomendCellDidClickUserButton:(HRRecomendCell *)cell withUserid:(NSString *)userid;

@end

@interface HRRecomendCell : UITableViewCell

@property(nonatomic,weak)id<HRRecomendCellDelegate>delegate;

@property(nonatomic,strong)UIView * lineView;

@property(nonatomic,strong)HRRecomend * dataSource;

+ (CGFloat)heigthForCellWithData:(HRRecomend *)dataSource;


@end

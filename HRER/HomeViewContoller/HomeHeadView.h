//
//  HomeHeadView.h
//  HRER
//
//  Created by kequ on 16/6/9.
//  Copyright © 2016年 linjunhou. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HomeHeadView;

@protocol HomeHeadViewDelegate <NSObject>
- (void)homeHeadView:(HomeHeadView *)view DidSeletedIndex:(NSInteger)index;
@end

@interface HomeHeadView : UITableViewCell

@property(nonatomic,strong)UIImageView * bgImageView;
@property(nonatomic,strong)UILabel * titleLabel;
@property(nonatomic,strong)UILabel * mainLabel;
@property(nonatomic,strong)UILabel * totalCountLabel;

@property(nonatomic,weak)id<HomeHeadViewDelegate> delegate;

- (void)setcatergortCount:(NSArray *)countArray;

+ (CGFloat)heightForHeadCell;

@end

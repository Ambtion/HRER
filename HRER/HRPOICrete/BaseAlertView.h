//
//  BaseAlertView.h
//  BaiduMapPad
//
//  Created by quke on 14-6-23.
//  Copyright (c) 2014年 Baidu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseAlertView : UIView

@property(nonatomic,strong)UIImageView * contentView;

- (void)disAppear;

- (void)showInView:(UIView *)view completion:(void (^)(BOOL finished))completion;

@end

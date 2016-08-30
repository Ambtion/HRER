//
//  BMRouteHomeMaskView.h
//  basicmap
//
//  Created by quke on 16/1/13.
//  Copyright © 2016年 baidu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BMGuideMaskView : UIView

+ (void)showMaskViewWithKey:(NSString *)key  containerView:(UIView *)view image:(UIImage *)image imageViewRect:(CGRect)rect;

+ (BOOL)isAlreadyShowedWithKey:(NSString *)key;

@end

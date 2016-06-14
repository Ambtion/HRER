//
//  HRScrollItemView.h
//  HRER
//
//  Created by kequ on 16/6/9.
//  Copyright © 2016年 linjunhou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HRCatergoryItemView : UIView

@property(nonatomic,strong)UILabel * label;
@property(nonatomic,strong)UIButton * imageButton;

- (void)setCategoryImage:(UIImage *)image
            seletedImage:(UIImage *)simage
                  target:(id)target
                 seletor:(SEL)seletor
          categoryNumber:(NSInteger)count;

@end

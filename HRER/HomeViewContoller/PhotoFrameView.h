//
//  PhotoFrameView.h
//  HRER
//
//  Created by kequ on 16/6/12.
//  Copyright © 2016年 linjunhou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PortraitView.h"

@interface PhotoFrameView : UIView
@property(nonatomic,strong)PortraitView * imageView;
@property(nonatomic,strong)UIImageView * bgImageView;
@end

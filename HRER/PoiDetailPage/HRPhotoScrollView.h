//
//  HRPhotoScrollView.h
//  HRER
//
//  Created by kequ on 16/7/13.
//  Copyright © 2016年 linjunhou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HRPhotoScrollView : UIView

@property(nonatomic,assign,readonly)NSInteger curPage;
@property(nonatomic,assign)NSInteger poiType;
@property(nonatomic,strong)NSArray * dataArray;

@end

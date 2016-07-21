//
//  HRUPloadImageView.h
//  HRER
//
//  Created by quke on 16/7/21.
//  Copyright © 2016年 linjunhou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseAlertView.h"

typedef void (^UPloadCallBack)(BOOL isSucesss);

@interface HRUPloadImageView : BaseAlertView

+ (void)showInView:(UIView *)view
      withPoiTitle:(NSString *)title
           address:(NSString *)addRess
               loc:(NSString *)loc
      categoryType:(NSInteger)poiType
          callBack:(UPloadCallBack) callBack;


@end

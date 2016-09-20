//
//  HRShareView.h
//  HRER
//
//  Created by kequ on 16/9/12.
//  Copyright © 2016年 linjunhou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HereDataModel.h"


@interface HRShareView : UIImageView

+ (void)creteShareImageWithPoiInfo:(HRPOIInfo *)poiInfo
                   withLoadingView:(UIView *)loadingView
                          callBack:(void (^)(UIImage * shareImage))callBack;

- (void)creteShareImageWithPoiInfo:(HRPOIInfo *)poiInfo
                          callBack:(void (^)(UIImage * shareImage))callBack;
@end

//
//  ImageView_Scale.h
//  ScaleImageView
//
//  Created by sohu on 13-3-26.
//  Copyright (c) 2013年 Qu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HRInfoImageView : UIImageView<UIWebViewDelegate>
{
    UIActivityIndicatorView * actV;
    UIImageView * logo;
}
- (void)startLoading;
- (void)stopLoading;
@end

@class HRImageScaleView;
@protocol ImageScaleViewDelegate <NSObject>
- (void)imageViewScale:(HRImageScaleView *)imageScale clickCurImage:(UIImageView *)imageview;
@end

@interface HRImageScaleView : UIScrollView<UIScrollViewDelegate,UIGestureRecognizerDelegate>
{
    HRInfoImageView * _imageView;
}

@property(nonatomic,weak)id<ImageScaleViewDelegate> Adelegate;
@property(nonatomic,strong)HRInfoImageView * imageView;
@property(nonatomic,assign)BOOL tapEnabled;
@end

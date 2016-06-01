//
//  HRPhotoBrowser.h
//  photobrowser
//
//  Created by aier on 15-2-3.
//  Copyright (c) 2015年 aier. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HRImageScaleView.h"

@class SDButton, HRPhotoBrowser;

@protocol SDPhotoBrowserDelegate <NSObject>

@required

- (BOOL)photoBrowser:(HRPhotoBrowser *)browser loadingImage:(HRImageScaleView *)hrImageView withIndexPath:(NSInteger)index;

@end


@interface HRPhotoBrowser : UIView <UIScrollViewDelegate>

@property (nonatomic, weak) UIView *sourceImagesContainerView;
@property (nonatomic, assign) NSInteger currentImageIndex;
@property (nonatomic, assign) NSInteger imageCount;

@property (nonatomic, weak) id<SDPhotoBrowserDelegate> delegate;

- (void)show;

@end



/*
 SDPhotoBrowser *browser = [[SDPhotoBrowser alloc] init];
 browser.currentImageIndex = imageView.tag;
 browser.sourceImagesContainerView = self;
 browser.imageCount = self.picPathStringsArray.count;
 browser.delegate = self;
 [browser show];
 
*/
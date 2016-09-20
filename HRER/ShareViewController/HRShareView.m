//
//  HRShareView.m
//  HRER
//
//  Created by kequ on 16/9/12.
//  Copyright © 2016年 linjunhou. All rights reserved.
//

#import "HRShareView.h"
#import "PortraitView.h"
#import "UIImageView+WebCache.h"

@interface HRShareView()

@property(nonatomic,strong)UIImageView * bgImageView;
@property(nonatomic,strong)UILabel * titleLabel;

@property(nonatomic,strong)UIImageView * locationView;
@property(nonatomic,strong)UILabel * addressLabel;

@property(nonatomic,strong)UIImageView * selImageView;

@property(nonatomic,strong)PortraitView * portraitView;
@property(nonatomic,strong)UILabel * nameLbael;
@property(nonatomic,strong)UILabel * shareDesLabel;

@property(nonatomic,strong)UILabel * introLabel;

@end
@implementation HRShareView

+ (void)creteShareImageWithPoiInfo:(HRPOIInfo *)poiInfo
                   withLoadingView:(UIView *)loadingView
                          callBack:(void (^)(UIImage * shareImage))callBack
{
    
    HRShareView * shareView = [[HRShareView alloc] initWithFrame:CGRectZero];
    shareView.left = loadingView.width;
    [loadingView addSubview:shareView];
    [shareView creteShareImageWithPoiInfo:poiInfo callBack:^(UIImage *shareImage) {
        if(callBack)
            callBack(shareImage);
        [shareView removeFromSuperview];
    }];
    

}

- (instancetype)initWithFrame:(CGRect)frame
{
    frame.size.width = 375;
    frame.size.height = 540;
    self = [super initWithFrame:frame];
    
    if (self) {
        self.clipsToBounds = YES;
        [self initUI];
    }
    return self;
}

- (void)initUI
{
    
    UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    UIVisualEffectView *effectview = [[UIVisualEffectView alloc] initWithEffect:blur];
    [self addSubview:effectview];
    effectview.frame = self.bounds;
    
    self.bgImageView = [[UIImageView alloc] initWithFrame:self.bounds];
    self.bgImageView.image = [UIImage imageNamed:@"mengban"];
    [self addSubview:self.bgImageView];
    
    
    
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.font = [UIFont systemFontOfSize:20.f];
    self.titleLabel.textColor = UIColorFromRGB(0xffffff);
    [self addSubview:self.titleLabel];
    
    
    self.locationView = [[UIImageView alloc] init];
    self.locationView.image = [UIImage imageNamed:@"share_location"];
    [self addSubview:self.locationView];
    
    self.addressLabel = [[UILabel alloc] init];
    self.addressLabel.font = [UIFont systemFontOfSize:15.f];
    self.addressLabel.textColor = UIColorFromRGB(0xcccccc);
    [self addSubview:self.addressLabel];
    
    self.portraitView = [[PortraitView alloc] init];
    self.portraitView.layer.borderColor = UIColorFromRGBA0_255(255, 255, 255, 0.2).CGColor;
    self.portraitView.layer.cornerRadius = 55/2.f;
    self.portraitView.layer.borderWidth = 5.f;
    [self addSubview:self.portraitView];
    
    
    self.nameLbael = [[UILabel alloc] init];
    self.nameLbael.font = [UIFont systemFontOfSize:20.f];
    self.nameLbael.textColor = UIColorFromRGB(0xffffff);
    [self addSubview:self.nameLbael];
    
    self.shareDesLabel = [[UILabel alloc] init];
    self.shareDesLabel.font = [UIFont systemFontOfSize:20.f];
    self.shareDesLabel.textColor = UIColorFromRGB(0xffffff);
    [self addSubview:self.shareDesLabel];
    
    self.selImageView = [[UIImageView alloc] init];
    [self addSubview:self.selImageView];
    
    self.introLabel = [[UILabel alloc] init];
    self.introLabel.font = [UIFont systemFontOfSize:15.f];
    self.introLabel.numberOfLines = 0;
    self.introLabel.textColor = UIColorFromRGB(0xcccccc);
    [self addSubview:self.introLabel];
    
    
    
    self.titleLabel.frame = CGRectMake(22, 50, self.width - 44, 22);
    self.locationView.frame = CGRectMake(self.titleLabel.left, 0, 13, 17);
    self.addressLabel.frame = CGRectMake(self.locationView.right + 6, self.titleLabel.bottom + 19, self.width - (self.locationView.right + 6) - 140 - 20, 17);
    self.locationView.centerY = self.addressLabel.centerY;
    
    self.selImageView.frame = CGRectMake(self.width - 140, 82, 180, 180);
    self.selImageView.layer.cornerRadius = 90.f;
    
    
    
    self.portraitView.frame = CGRectMake(self.titleLabel.left, self.addressLabel.bottom + 60, 55, 55);
    self.nameLbael.frame = CGRectMake(self.titleLabel.left, self.portraitView.bottom + 17, self.selImageView.left - self.titleLabel.left - 20, 22);
 
    self.shareDesLabel.frame = CGRectMake(self.titleLabel.left, self.nameLbael.bottom + 17, self.width - self.titleLabel.left - 22, 22);
    
    self.introLabel.frame = CGRectMake(self.titleLabel.left, self.shareDesLabel.bottom + 27.f, self.width - 44, self.height - (self.shareDesLabel.bottom + 17) - 90);
        
}

- (void)creteShareImageWithPoiInfo:(HRPOIInfo *)poiInfo
                          callBack:(void (^)(UIImage * shareImage))callBack
{
    self.titleLabel.text = poiInfo.title;
    self.addressLabel.text = poiInfo.address;
    
    self.nameLbael.text = poiInfo.creator_name;
    self.shareDesLabel.text = [NSString stringWithFormat:@"在这里分享的第%ld个%@",(long)poiInfo.recommand,poiInfo.typeName];
    
    NSString * intro = poiInfo.intro;
    if (!intro.length) {
        intro = @"";
    }
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:intro];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    
    [paragraphStyle setLineSpacing:15.f];//调整行间距
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [intro length])];
    self.introLabel.attributedText = attributedString;
    
    [self setNeedsLayout];
  
    //异步加载图片
    
    if (poiInfo.photos && poiInfo.photos.count) {
        
        HRPotoInfo * imageInfo = [[poiInfo photos] firstObject];
        
        __block NSInteger imageLoadingCount = 3;
        
        WS(weakSelf);
        
        SDWebImageCompletionBlock block = ^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
          
                imageLoadingCount --;
                if (imageLoadingCount == 0) {
                    
                    CGRect croppingRect = weakSelf.frame;
                    
                    UIGraphicsBeginImageContextWithOptions(CGSizeMake(croppingRect.size.width, croppingRect.size.height), NO, [UIScreen mainScreen].scale);
                    // Create a graphics context and translate it the view we want to crop so
                    // that even in grabbing (0,0), that origin point now represents the actual
                    // cropping origin desired:
                    CGContextRef context = UIGraphicsGetCurrentContext();
                    if (context == NULL) return ;
                    
//                    CGContextTranslateCTM(context, 0, -croppingRect.origin.y);
                    
                    [weakSelf.layer renderInContext:context];
                    
                    UIImage * shareImage = UIGraphicsGetImageFromCurrentImageContext();
                    UIGraphicsEndImageContext();
                    if (callBack) {
                        callBack(shareImage);
                    }
            }
        };
        
        [self sd_setImageWithURL:[NSURL URLWithString:imageInfo.url] placeholderImage:nil completed:block];
        
        [self.portraitView.imageView sd_setImageWithURL:[NSURL URLWithString:poiInfo.portrait] placeholderImage:[UIImage imageNamed:@"man"] completed:block];

        [self.selImageView sd_setImageWithURL:[NSURL URLWithString:poiInfo.seal.url] placeholderImage:[UIImage imageNamed:@"defoult_seal"] completed:block];
        
    }else{
        //没有图片返回
        if (callBack) {
            callBack(nil);
        }
        return;

    }
}

@end

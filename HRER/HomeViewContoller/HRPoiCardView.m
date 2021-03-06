//
//  HRPoiCardView.m
//  HRER
//
//  Created by quke on 16/6/16.
//  Copyright © 2016年 linjunhou. All rights reserved.
//

#import "HRPoiCardView.h"
#import "PhotoFrameView.h"
#import "HRNavigationTool.h"
#import "HRLocationManager.h"

@interface HRPoiCardView ()

@property(nonatomic,strong)UIImageView * bgImageView;
@property(nonatomic,strong)UIImageView * portraitImage;
@property(nonatomic,strong)UILabel * titleLabel;
@property(nonatomic,strong)UILabel * subLabel;

@property(nonatomic,strong)NSMutableArray * frameImageViews;


@end

@implementation HRPoiCardView


+ (CGFloat)heightForCardView
{
    return 140.f;
}


- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initUI];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initUI];
    }
    return self;
}

- (void)initUI
{
    self.bgImageView = [[UIImageView alloc] init];
    self.bgImageView.image = [[UIImage imageNamed:@"poi_content_bg"] resizableImageWithCapInsets:UIEdgeInsetsMake(7, 7, 7, 7)];
    
    [self addSubview:self.bgImageView];
    
    
    self.portraitImage = [[UIImageView alloc] init];
    self.portraitImage.layer.cornerRadius = 18.5;
    self.portraitImage.layer.masksToBounds = YES;
    [self addSubview:self.portraitImage];
    
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.font = [UIFont systemFontOfSize:15.f];
    self.titleLabel.textColor = RGB_Color(0x4c, 0x4c, 0x4c);
    self.titleLabel.textAlignment = NSTextAlignmentLeft;
    [self addSubview:self.titleLabel];
    
    
    self.subLabel = [[UILabel alloc] init];
    self.subLabel.font = [UIFont systemFontOfSize:13.f];
    self.subLabel.textColor = RGB_Color(0xa6, 0xa6, 0xa6);
    self.subLabel.textAlignment = NSTextAlignmentLeft;
    [self addSubview:self.subLabel];
    
    [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(10.f);
        make.right.equalTo(self).offset(-10.f);
        make.top.equalTo(self);
        make.bottom.equalTo(self);
    }];
    
    [self.portraitImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(37.f, 37.f));
        make.top.equalTo(self.bgImageView).offset(14.f);
        make.left.equalTo(self.bgImageView).offset(12.f);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.portraitImage.mas_right).offset(14.f);
        make.right.equalTo(self.bgImageView).offset(-14.f);
        make.top.equalTo(self.portraitImage);
        make.height.equalTo(@(16.f));
        
    }];
    
    
    [self.subLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel);
        make.width.equalTo(self.titleLabel);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(8.f);
    }];
    
    
    self.locIconView = [[UIImageView alloc] init];
    self.locIconView.image = [UIImage imageNamed:@"km"];
    [self addSubview:self.locIconView];
    
    self.locLabel = [[UILabel alloc] init];
    self.locLabel.font = [UIFont systemFontOfSize:12.f];
    self.locLabel.textColor = RGB_Color(0x4c, 0x4c, 0x4c);
    [self addSubview:self.locLabel];
    
    
    self.frameImageViews = [NSMutableArray arrayWithCapacity:4];
    
    UIView * lastView = nil;
    for (int i = 0; i < 4; i++) {
        
        PhotoFrameView * frameView = [[PhotoFrameView alloc] init];
        [frameView setHidden:YES];
        frameView.tag = i;
        [self.frameImageViews addObject:frameView];
        [self addSubview:frameView];
        
        
        [frameView mas_makeConstraints:^(MASConstraintMaker *make) {
            if (frameView.tag  == 0) {
                make.left.equalTo(self.titleLabel);
            }else{
                make.left.equalTo(lastView.mas_right).offset(5.f);
            }
        }];
        lastView = frameView;
    }
    
    [self.frameImageViews mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.subLabel.mas_bottom).offset(8.f);
        CGFloat width = 52.f;
        make.size.mas_equalTo(CGSizeMake(width, width + 2));
    }];
    
    
    [self.locLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.bgImageView.mas_right).offset(-10);
        make.bottom.equalTo(self.bgImageView.mas_bottom).offset(-10);
        make.height.equalTo(@(14.f));
    }];
    
    [self.locIconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.locLabel.mas_left).offset(-5);
        make.centerY.equalTo(self.locLabel);
    }];
    
    
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(fullViewTap:)];
    [self addGestureRecognizer:tap];
    
    tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userPortDidClick:)];
    [self.portraitImage setUserInteractionEnabled:YES];
    [self.portraitImage addGestureRecognizer:tap];
    
    self.maskView = [[UIView alloc] init];
    self.maskView.layer.cornerRadius = 4.f;
    self.maskView.layer.borderColor = UIColorFromRGB(0xdf4f29).CGColor;
    self.maskView.layer.borderWidth = 0.5;
    self.maskView.backgroundColor = RGBA(0xfe, 0x98, 0x7f, 0.5);
    [self addSubview:self.maskView];
    [self.maskView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self.bgImageView);
        make.width.equalTo(self.bgImageView);
        make.height.equalTo(self.bgImageView).offset(-2);
    }];
    [self.maskView setHidden:YES];

}

- (void)setDataSource:(HRPOIInfo *)data
{
    [self.portraitImage sd_setImageWithURL:[NSURL URLWithString:data.portrait] placeholderImage:[UIImage imageNamed:@"man"]];
        
    
    NSString * str = @"";
    
    NSString * userName = data.creator_name;
    
    if(data.single_type == 5){
        userName = data.xq_user;
//        //想去
//        if ([data.creator_id isEqualToString:[[[LoginStateManager getInstance] userLoginInfo] user_id]]) {
//            //想去我推荐的poi
//            userName = data.xq_user;
//            str = [NSString stringWithFormat:@"%@ 想去你推荐的 %@",userName,data.title];
//        }else{
//            userName = data.creator_name;
//            str = [NSString stringWithFormat:@"想去 %@ 推荐的 %@",userName,data.title];
//        }
        str = [NSString stringWithFormat:@"%@ 想去%@推荐的%@",data.xq_user,data.creator_name,data.title];
    }else{
        str = [NSString stringWithFormat:@"%@ 推荐了 %@",userName,data.title];
    }
    
    NSMutableAttributedString * attr = [[NSMutableAttributedString alloc] initWithString:str];
    
    NSRange titleNormal =  NSMakeRange(0, 0);
    NSRange nameRang = NSMakeRange(0, 0);
    if(userName)
      nameRang  = [str rangeOfString:userName];
    if (data.title)
        titleNormal = [str rangeOfString:data.title];
    
    [attr addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:15] range:titleNormal];
    [attr addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:15] range:nameRang];
    [attr addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0xe14430) range:titleNormal];

//    [attr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:NSMakeRange(nameRang.location + nameRang.length, titleNormal.location)];

    [self.titleLabel setAttributedText:attr];

    if (data.intro.length)
        self.subLabel.text = data.intro;
    else
        self.subLabel.text = @"";
    
    for (int i = 0; i < 4; i++) {
        
        PhotoFrameView * frameView = self.frameImageViews[i];
//        frameView.imageView.imageView.image = [UIImage imageNamed:@"man"];
//        [(PortraitView * )frameView.imageView autoJustImageSize];

        if(i < data.photos.count){
            HRPotoInfo * info = data.photos[i];
            if ([info isKindOfClass:[HRPotoInfo class]]) {
                [frameView setHidden:NO];
                NSURL * url = [NSURL URLWithString:info.url.length ? info.url : @""];
                [frameView.imageView.imageView sd_setImageWithURL:url placeholderImage:[self imageForType:data.type] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//                    [(PortraitView * )frameView.imageView autoJustImageSize];
                }];
                
            }else{
                [frameView setHidden:YES];
            }
        
        }else{
            [frameView setHidden:YES];
        }
      
    }
    CLLocation * desLocaiton = [[CLLocation alloc] initWithLatitude:data.lat longitude:data.lng];
    NSString * distance = [HRNavigationTool distanceBetwenOriGps:[[HRLocationManager sharedInstance] curLocation].coordinate desGps:desLocaiton.coordinate];
    self.locLabel.text = distance;
    [self.locIconView setHidden:NO];
}


- (UIImage *)imageForType:(NSInteger)type
{
    switch (type) {
        case 1:
            return [UIImage imageNamed:@"not_loaded_food"];
            break;
        case 2:

            return [UIImage imageNamed:@"not_loaded_lookShop"];
        case 3:
            return [UIImage imageNamed:@"not_loaded_yule"];
        case 4:
            return [UIImage imageNamed:@"not_loaded_hotel"];
        default:
            break;
    }
    return [UIImage imageNamed:@"not_loaded"];
}


- (void)fullViewTap:(UITapGestureRecognizer *)tap
{
    if ([_delegate respondsToSelector:@selector(poiViewDidClick:)]) {
        [_delegate poiViewDidClick:self];
    }
}

- (void)frameViewDidClick:(UITapGestureRecognizer * )tap
{
    if ([_delegate respondsToSelector:@selector(poiView:DidClickFrameImage:)]) {
        [_delegate poiView:self DidClickFrameImage:(UIImageView *)tap.view];
    }
}

- (void)userPortDidClick:(id)sender
{
    if ([_delegate respondsToSelector:@selector(poiViewDidClickUserPortrait:)]) {
        [_delegate poiViewDidClickUserPortrait:self];
    }
}

@end

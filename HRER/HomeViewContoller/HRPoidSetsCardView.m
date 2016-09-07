//
//  HRPoidSetsCardView.m
//  HRER
//
//  Created by quke on 16/6/16.
//  Copyright © 2016年 linjunhou. All rights reserved.
//

#import "HRPoidSetsCardView.h"
#import "PhotoFrameView.h"

@interface HRPoidSetsCardView()

@property(nonatomic,strong)UIImageView * bgImageView;
@property(nonatomic,strong)UIImageView * portraitImage;
@property(nonatomic,strong)UILabel * titleLabel;
@property(nonatomic,strong)NSMutableArray * frameImageViews;


@end

@implementation HRPoidSetsCardView

+ (CGFloat)heightForCardView
{
    return 105.f;
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
    self.titleLabel.font = [UIFont boldSystemFontOfSize:15.f];
    self.titleLabel.textColor = RGB_Color(0x4c, 0x4c, 0x4c);
    self.titleLabel.textAlignment = NSTextAlignmentLeft;
    [self addSubview:self.titleLabel];
    
    self.locIconView = [[UIImageView alloc] init];
    self.locIconView.image = [UIImage imageNamed:@"km"];
    [self addSubview:self.locIconView];
    
    self.locLabel = [[UILabel alloc] init];
    self.locLabel.font = [UIFont systemFontOfSize:12.f];
    self.locLabel.textColor = RGB_Color(0x4c, 0x4c, 0x4c);
    [self addSubview:self.locLabel];
    
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
//        make.height.equalTo(@(16.f));
    }];
    
    self.frameImageViews = [NSMutableArray arrayWithCapacity:4];
    
    UIView * lastView = nil;
    for (int i = 0; i < 4; i++) {
        
        PhotoFrameView * frameView = [[PhotoFrameView alloc] init];
//        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(frameViewDidClick:)];
//        [frameView addGestureRecognizer:tap];
        [frameView setHidden:YES];
        frameView.tag = i;
        [self.frameImageViews addObject:frameView];
        [self addSubview:frameView];
        
        
        [frameView mas_makeConstraints:^(MASConstraintMaker *make) {
            if (frameView.tag == 0) {
                make.left.equalTo(self.titleLabel);
            }else{
                make.left.equalTo(lastView.mas_right).offset(5.f);
            }
        }];
        lastView = frameView;
    }
    
    [self.frameImageViews mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(8.f);
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
    
    [self.locLabel setHidden:YES];
    [self.locIconView setHidden:YES];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
}

- (void)setData:(HRPOISetInfo *)data
{
    
    [self.portraitImage sd_setImageWithURL:[NSURL URLWithString:data.portrait] placeholderImage:[UIImage imageNamed:@"man"]];
    
    if(data.creator_name.length){
        NSString * str = [NSString stringWithFormat:@"%@ 推荐了 %@",data.creator_name,data.title];
        NSMutableAttributedString * attr = [[NSMutableAttributedString alloc] initWithString:str];
        
        NSRange titleNormal =  NSMakeRange(0, 0);
        NSRange nameRang = NSMakeRange(0, 0);
        if(data.creator_name)
            nameRang  = [str rangeOfString:data.creator_name];
        if (data.title)
            titleNormal = [str rangeOfString:data.title];
        
        [attr addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:15] range:titleNormal];
        [attr addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:15] range:nameRang];
        
        [self.titleLabel setAttributedText:attr];
    }else{
        self.titleLabel.text = data.title;
    }
    
    for (int i = 0; i < 4; i++) {
        
        PhotoFrameView * frameView = self.frameImageViews[i];
        if(i < data.photos.count){
            HRPotoInfo * info = data.photos[i];
            
            if ([info isKindOfClass:[HRPotoInfo class]]) {
                [frameView setHidden:NO];
                NSURL * url = [NSURL URLWithString:info.url.length ? info.url : @""];
                
                [frameView.imageView.imageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"man"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                }];
            }else{
                [frameView setHidden:YES];
            }
        }else{
            [frameView setHidden:YES];
        }

    }
    
    self.titleLabel.numberOfLines = data.poi_type == 16 ? 2 : 1;
    self.titleLabel.font = data.poi_type == 16 ? [UIFont boldSystemFontOfSize:15.f] : [UIFont boldSystemFontOfSize:15.f];
}

- (void)fullViewTap:(UITapGestureRecognizer *)tap
{
    if ([_delegate respondsToSelector:@selector(poiSetsViewDidClick:)]) {
        [_delegate poiSetsViewDidClick:self];
    }
}

- (void)frameViewDidClick:(UITapGestureRecognizer * )tap
{
    if ([_delegate respondsToSelector:@selector(poiSetsView:DidClickFrameImage:)]) {
        [_delegate poiSetsView:self DidClickFrameImage:(UIImageView *)tap.view];
    }
}

- (void)userPortDidClick:(id)sender
{
    if ([_delegate respondsToSelector:@selector(poiSetsViewDidClickPor:)]) {
        [_delegate poiSetsViewDidClickPor:self];
    }
}


@end

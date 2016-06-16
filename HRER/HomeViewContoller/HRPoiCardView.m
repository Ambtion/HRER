//
//  HRPoiCardView.m
//  HRER
//
//  Created by quke on 16/6/16.
//  Copyright © 2016年 linjunhou. All rights reserved.
//

#import "HRPoiCardView.h"
#import "PhotoFrameView.h"


@interface HRPoiCardView ()

@property(nonatomic,strong)UIImageView * bgImageView;
@property(nonatomic,strong)UIImageView * portraitImage;
@property(nonatomic,strong)UILabel * titleLabel;
@property(nonatomic,strong)UILabel * subLabel;

@property(nonatomic,strong)NSMutableArray * frameImageViews;
@property(nonatomic,strong)UIImageView * locIconView;
@property(nonatomic,strong)UILabel * locLabel;


@end

@implementation HRPoiCardView


+ (CGFloat)heightForCardView
{
    return 135.f;
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
        make.top.equalTo(self).offset(10);
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
    self.locIconView.image = [UIImage imageNamed:@"location"];
    [self addSubview:self.locIconView];
    
    self.locLabel = [[UILabel alloc] init];
    self.locLabel.font = [UIFont systemFontOfSize:12.f];
    self.locLabel.textColor = RGB_Color(0x4c, 0x4c, 0x4c);
    [self addSubview:self.locLabel];
    
    
    self.frameImageViews = [NSMutableArray arrayWithCapacity:4];
    
    UIView * lastView = nil;
    for (int i = 0; i < 4; i++) {
        
        PhotoFrameView * frameView = [[PhotoFrameView alloc] init];
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(frameViewDidClick:)];
        [frameView addGestureRecognizer:tap];
        [frameView setHidden:YES];
        frameView.tag = 100 + i;
        [self.frameImageViews addObject:frameView];
        [self addSubview:frameView];
        
        
        [frameView mas_makeConstraints:^(MASConstraintMaker *make) {
            if (frameView.tag - 100 == 0) {
                make.left.equalTo(self.titleLabel);
            }else{
                make.left.equalTo(lastView.mas_right).offset(5.f);
            }
        }];
        lastView = frameView;
        [lastView setHidden:NO];
        lastView.backgroundColor = [UIColor greenColor];
    }
    
    [self.frameImageViews mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(8.f);
        CGFloat width = 52.f;
        make.size.mas_equalTo(CGSizeMake(width, width + 2));
    }];
    
    
    [self.locLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(lastView.mas_right);
        make.bottom.equalTo(self.bgImageView.mas_bottom).offset(-10);
        make.height.equalTo(@(14.f));
    }];
    
    [self.locIconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.locLabel.mas_left).offset(-5);
        make.centerY.equalTo(self.locLabel);
    }];
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(fullViewTap:)];
    [self addGestureRecognizer:tap];
    

    
    self.titleLabel.backgroundColor = [UIColor greenColor];
    self.portraitImage.backgroundColor = [UIColor greenColor];
    
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



@end

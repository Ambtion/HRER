//
//  HRHerePoiCell.m
//  HRER
//
//  Created by quke on 16/6/12.
//  Copyright © 2016年 linjunhou. All rights reserved.
//

#import "HRHerePoiCell.h"
#import "PhotoFrameView.h"

@interface HRHerePoiCell()

@property(nonatomic,strong)UIImageView * bgImageView;
@property(nonatomic,strong)UIImageView * portraitImage;
@property(nonatomic,strong)UILabel * titleLabel;
@property(nonatomic,strong)NSMutableArray * frameImageViews;

@end

@implementation HRHerePoiCell

+ (CGFloat)heightForCell
{
    return 10 + 107.f;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self initUI];
    }
    return self;
}

- (void)initUI
{
    self.bgImageView = [[UIImageView alloc] init];
    self.bgImageView.image = [[UIImage imageNamed:@"poi_content_bg"] resizableImageWithCapInsets:UIEdgeInsetsMake(7, 7, 7, 7)];
    [self.contentView addSubview:self.bgImageView];
    
    self.portraitImage = [[UIImageView alloc] init];
    [self.contentView addSubview:self.portraitImage];
    
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.font = [UIFont systemFontOfSize:15.f];
    self.titleLabel.textColor = RGB_Color(0x4c, 0x4c, 0x4c);
    self.titleLabel.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:self.titleLabel];
    
    
    [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(10.f);
        make.right.equalTo(self.contentView).offset(-10.f);
        make.top.equalTo(self.contentView).offset(10);
        make.bottom.equalTo(self.contentView);
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
    
    self.frameImageViews = [NSMutableArray arrayWithCapacity:4];
    
    UIView * lastView = nil;
    for (int i = 0; i < 4; i++) {
        
        PhotoFrameView * frameView = [[PhotoFrameView alloc] init];
        [frameView setHidden:YES];
        frameView.tag = 100 + i;
        [self.frameImageViews addObject:frameView];
        [self.contentView addSubview:frameView];
        
        
        [frameView mas_makeConstraints:^(MASConstraintMaker *make) {
            if (frameView.tag - 100 == 0) {
                make.left.equalTo(self.titleLabel);
            }else{
                make.left.equalTo(lastView.mas_right).offset(5.f);
            }
        }];
        lastView = frameView;
        
        [frameView setHidden:NO];
        frameView.backgroundColor = [UIColor greenColor];
    }
    
    [self.frameImageViews mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(8.f);
        CGFloat width = 52.f;
        make.size.mas_equalTo(CGSizeMake(width, width + 2));
    }];
    
//    self.bgImageView.backgroundColor = [UIColor redColor];
    self.titleLabel.backgroundColor = [UIColor greenColor];
    self.portraitImage.backgroundColor = [UIColor greenColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{}

@end

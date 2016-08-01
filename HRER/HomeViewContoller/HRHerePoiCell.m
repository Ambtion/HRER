//
//  HRHerePoiCell.m
//  HRER
//
//  Created by quke on 16/6/12.
//  Copyright © 2016年 linjunhou. All rights reserved.
//

#import "HRHerePoiCell.h"
#import "HRPoiCardView.h"

@interface HRHerePoiCell()<HRPoiCardViewdelegate>
@property(nonatomic,strong)HRPoiCardView * cardView;
@end

@implementation HRHerePoiCell

#define KPoiCellSpacing (8.f)

+ (CGFloat)heightForCell
{
    return KPoiCellSpacing + [HRPoiCardView heightForCardView];
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
    self.cardView = [[HRPoiCardView alloc] init];
    self.cardView.delegate = self;
    [self.contentView addSubview:self.cardView];
    
    [self.cardView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.width.equalTo(self);
        make.top.equalTo(self).offset(KPoiCellSpacing);
        make.bottom.equalTo(self).offset(0);
    }];
}

- (void)setData:(HRPOIInfo *)data
{
    if (_data == data) {
        return;
    }
    _data = data;
    [[self cardView] setDataSource:data];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{}

- (void)poiView:(HRPoiCardView *)poiSetsview DidClickFrameImage:(UIImageView *)imageView
{
    if ([_delegate respondsToSelector:@selector(herePoiCell:DidClickFrameView:)]) {
        [_delegate herePoiCell:self DidClickFrameView:imageView];
    }
}

- (void)poiViewDidClick:(HRPoiCardView *)poiSetsview
{
    if ([_delegate respondsToSelector:@selector(herePoiCellDidClick:)]) {
        [_delegate herePoiCellDidClick:self];
    }
}

- (void)poiViewDidClickUserPortrait:(HRPoiCardView *)poiSetsview
{
    if ([_delegate respondsToSelector:@selector(herePoiCellDidClickUserPortrait:)]) {
        [_delegate herePoiCellDidClickUserPortrait:self];
    }
}

@end

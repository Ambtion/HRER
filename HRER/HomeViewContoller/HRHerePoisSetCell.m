//
//  HRHerePoisSetCell.m
//  HRER
//
//  Created by quke on 16/6/12.
//  Copyright © 2016年 linjunhou. All rights reserved.
//

#import "HRHerePoisSetCell.h"
#import "HRPoidSetsCardView.h"

@interface HRHerePoisSetCell()<HRPoidSetsCardViewdelegate>

@property(nonatomic,strong)HRPoidSetsCardView * cardView;

@end

#define  KPoiSetSpacing (8.f)

@implementation HRHerePoisSetCell


+ (CGFloat)heightForCell
{
    return KPoiSetSpacing + [HRPoidSetsCardView heightForCardView];
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
    self.contentView.backgroundColor = UIColorFromRGB(0xebebeb);
    self.cardView = [[HRPoidSetsCardView alloc] init];
    self.cardView.delegate = self;
    [self.contentView addSubview:self.cardView];
    
    [self.cardView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.width.equalTo(self);
        make.top.equalTo(self).offset(KPoiSetSpacing);
        make.bottom.equalTo(self);
    }];
}

- (void)setData:(HRPOISetInfo *)data
{
//    if(_data == data){
//        return;
//    }
    _data = data;
    [self.cardView setData:_data];
}

- (void)setLocaitonStr:(NSString *)str
{
    self.cardView.locLabel.text = str;
    [self.cardView.locIconView setHidden:!str.length];
    [self.cardView.locLabel setHidden:!str.length];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated{
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated{
}

- (void)poiSetsView:(HRPoidSetsCardView *)poiSetsview DidClickFrameImage:(UIImageView *)imageView
{
    if ([_delegate respondsToSelector:@selector(herePoisSetCell: DidClickFrameView:)]) {
        [_delegate herePoisSetCell:self DidClickFrameView:imageView];
    }
}

- (void)poiSetsViewDidClick:(HRPoidSetsCardView *)poiSetsview
{
    if ([_delegate respondsToSelector:@selector(herePoisSetCellDidClick:)]) {
        [_delegate herePoisSetCellDidClick:self];
    }
}

- (void)poiSetsViewDidClickPor:(HRPoidSetsCardView *)poiSetsview
{
    if ([_delegate respondsToSelector:@selector(herePoisSetCellDidClickUserPortrait:)]) {
        [_delegate herePoisSetCellDidClickUserPortrait:self];
    }
}

@end

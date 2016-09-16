//
//  HRPoiDetailPhotosCell.m
//  HRER
//
//  Created by kequ on 16/7/13.
//  Copyright © 2016年 linjunhou. All rights reserved.
//

#import "HRPoiDetailPhotosCell.h"

@interface HRPoiDetailPhotosCell()

@property(nonatomic,strong)UIImageView * maskView;
@end

@implementation HRPoiDetailPhotosCell

+ (CGFloat)heightForCell
{
    return 230 + 8;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self  =  [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = RGB_Color(236, 236, 236);
        [self initUI];
    }
    return self;
}

- (void)initUI
{
    self.photosView = [[HRPhotoScrollView alloc] initWithFrame:CGRectMake(0, 0, self.width, 230)];
    [self.contentView addSubview:self.photosView];
    
    [self.photosView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self).offset(0);
        make.width.equalTo(self);
        make.bottom.equalTo(self).offset(-8);
    }];

    self.maskView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"photo_mengban"]];
    [self.contentView addSubview:self.maskView];
    
    [self.maskView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self.photosView);
        make.size.equalTo(self.photosView);
    }];
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapImage:)];
    [self.contentView addGestureRecognizer:tap];
}

- (void)setDataImages:(NSArray *)array
{
    [self.photosView setDataArray:array];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self.photosView layoutSubviews];
}

- (NSInteger)seletedIndex
{
    return self.photosView.curPage;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated{}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated{}

- (void)onTapImage:(id)sender
{
    if ([_delegate respondsToSelector:@selector(poiDetailPhotosCellDidClickPhoto:)]) {
        [_delegate poiDetailPhotosCellDidClickPhoto:self];
    }
}

@end

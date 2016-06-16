//
//  HRHerePoiCell.m
//  HRER
//
//  Created by quke on 16/6/12.
//  Copyright © 2016年 linjunhou. All rights reserved.
//

#import "HRHerePoiCell.h"
#import "HRPoiCardView.h"

@interface HRHerePoiCell()
@property(nonatomic,strong)HRPoiCardView * cardView;
@end

@implementation HRHerePoiCell

#define KPoiCellSpacing (10.f)

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
    [self.contentView addSubview:self.cardView];
    
    [self.cardView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.width.equalTo(self);
        make.top.equalTo(self);
        make.bottom.equalTo(self).offset(-KPoiCellSpacing);
    }];

}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{}

@end

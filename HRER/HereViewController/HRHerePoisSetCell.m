//
//  HRHerePoisSetCell.m
//  HRER
//
//  Created by quke on 16/6/12.
//  Copyright © 2016年 linjunhou. All rights reserved.
//

#import "HRHerePoisSetCell.h"


@interface HRHerePoisSetCell()

@property(nonatomic,strong)UIImageView * bgImageView;
@property(nonatomic,strong)UILabel * titleLabel;
@end

@implementation HRHerePoisSetCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
    }
    return self;
}

- (void)initUI
{
    self.bgImageView = [[UIImageView alloc] init];
    [self.contentView addSubview:self.bgImageView];
}

@end

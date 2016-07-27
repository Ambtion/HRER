//
//  BMSystemConfigPageCell.h
//  BaiduMapGemini
//
//  Created by Adrain Sun on 7/29/13.
//  Copyright (c) 2013 BaiduLBSMapClient. All rights reserved.
//


typedef enum {
    CellInvalid = -1,
    CellPositionTop,
    CellPositionMiddle,
    CellPositionBottom,
    CellPositionFull,
} CellPositionType;


@interface BMSystemConfigPageCell : UITableViewCell

@property(nonatomic,strong)UILabel * titleLabel;
@property(nonatomic,strong)UILabel * subTtileLabel;

- (void)setCellType:(CellPositionType)type;

@end

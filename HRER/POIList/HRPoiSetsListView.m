//
//  HRPoiSetsListView.m
//  HRER
//
//  Created by kequ on 16/6/15.
//  Copyright © 2016年 linjunhou. All rights reserved.
//

#import "HRPoiSetsListView.h"
#import "HRHerePoiCell.h"
#import "HRPhotoBrowser.h"

@interface HRPoiSetsListView()<UITableViewDelegate,UITableViewDataSource,HRHerePoiCellDelegate,SDPhotoBrowserDelegate>

@property(nonatomic,strong)UITableView * tableView;

@end

@implementation HRPoiSetsListView

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
    [self initNavBar];
    [self initTableView];
}

#pragma mark - NavBar

- (void)initNavBar
{
    
    UIImageView * barView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.width, 64)];
    [barView setUserInteractionEnabled:YES];
    barView.backgroundColor = [UIColor redColor];
    [self addSubview:barView];
    
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, self.width, 44)];
    label.text = @"北京";
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    [barView addSubview:label];
    
    UIButton * backButton = [[UIButton alloc] initWithFrame:CGRectMake(17, 26, 33, 33)];
    [backButton setImage:[UIImage imageNamed:@"list_back"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(buttonDidClick:) forControlEvents:UIControlEventTouchUpInside];
    backButton.tag = 0;
    [self addSubview:backButton];
    
    UIButton * switchButton = [[UIButton alloc] initWithFrame:CGRectMake(self.width - 17 - 33, 26, 33, 33)];
    switchButton.tag = 1;
    [switchButton setImage:[UIImage imageNamed:@"list_map"] forState:UIControlStateNormal];
    [switchButton addTarget:self action:@selector(buttonDidClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:switchButton];
}

- (void)buttonDidClick:(UIButton *)button
{
    if (button.tag == 0) {
        if ([_delegate respondsToSelector:@selector(poiSetsListViewdidClickBackButton:)]) {
            [_delegate poiSetsListViewdidClickBackButton:self];
        }
    }else{
        if ([_delegate respondsToSelector:@selector(poiSetsListViewdidClickListButton:)]) {
            [_delegate poiSetsListViewdidClickListButton:self];
        }
    }
}


#pragma mark - TableView

- (void)initTableView
{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, self.width, self.height - 64) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self addSubview:self.tableView];

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [HRHerePoiCell heightForCell];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString * identify = NSStringFromClass([HRHerePoiCell class]);
    HRHerePoiCell * cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (!cell) {
        cell = [[HRHerePoiCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
        cell.delegate = self;
    }
    return cell;
}


- (void)herePoiCell:(HRHerePoiCell *)cell DidClickFrameView:(UIImageView *)imageView
{
    
    HRPhotoBrowser *browser = [[HRPhotoBrowser alloc] init];
    browser.currentImageIndex = imageView.tag;
    browser.sourceImagesContainerView = self;
    browser.imageCount = 4;
    browser.delegate = self;
    [browser show];
    
}

- (void)herePoiCellDidClick:(HRHerePoiCell *)cell
{
    
}

- (BOOL)photoBrowser:(HRPhotoBrowser *)browser loadingImage:(HRImageScaleView *)hrImageView withIndexPath:(NSInteger)index
{
    hrImageView.backgroundColor = [UIColor redColor];
    return YES;
}

#pragma mark - Date
- (void)refreshUIWithData:(NSArray *)array
{

}
@end

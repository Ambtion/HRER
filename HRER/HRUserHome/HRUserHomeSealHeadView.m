//
//  HRUserHomeSealHeadView.m
//  HRER
//
//  Created by kequ on 16/9/11.
//  Copyright © 2016年 linjunhou. All rights reserved.
//

#import "HRUserHomeSealHeadView.h"
#import "HRUserHomeCollectionSealCell.h"

@interface HRUserHomeSealHeadView()<UICollectionViewDelegate,UICollectionViewDataSource>

@property(nonatomic,strong)UICollectionView * colletctionView;

@end

@implementation HRUserHomeSealHeadView


+ (CGFloat)heightForView
{
    return 230;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initUI];
    }
    return self;
}

- (void)initUI
{
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.itemSize = CGSizeMake(82, 82);
    layout.minimumLineSpacing = 16.f;
    layout.minimumInteritemSpacing = 16.f;

    
    self.colletctionView =  [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height) collectionViewLayout:layout];
    self.colletctionView.contentInset = UIEdgeInsetsMake(25, 25, 25, 25);
    self.colletctionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.colletctionView.clipsToBounds = YES;
    self.colletctionView.backgroundColor = [UIColor clearColor];
    self.colletctionView.delegate = self;
    self.colletctionView.dataSource = self;
    [self addSubview:self.colletctionView];
    
    [self.colletctionView registerClass:[HRUserHomeCollectionSealCell class] forCellWithReuseIdentifier:@"SealCell"];
    
}


#pragma mark -
#pragma mark - Delegate | DataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    HRUserHomeCollectionSealCell * sealCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SealCell" forIndexPath:indexPath];
    HRPotoInfo * photoInfo = [self.dataSource objectAtIndex:indexPath.row];
    [sealCell.imageView.imageView sd_setImageWithURL:[NSURL URLWithString:photoInfo.url] placeholderImage:[UIImage imageNamed:@"not_loaded"]];
    return sealCell;
    
}

@end

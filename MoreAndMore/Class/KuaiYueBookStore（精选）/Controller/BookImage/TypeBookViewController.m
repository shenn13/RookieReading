//
//  TypeBookViewController.m
//  MoreAndMore
//
//  Created by Silence on 16/7/15.
//  Copyright © 2016年 Silence. All rights reserved.
//

#import "TypeBookViewController.h"
#import "BookTypeCell.h"

#define ITEM_WIDTH (SCREEN_WIDTH - 40)/3

@interface TypeBookViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

@property (nonatomic,strong)NSMutableArray *typeDataSource;

@end

@implementation TypeBookViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = 10;
    layout.minimumInteritemSpacing = 10;
    layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    collectionView.backgroundColor = [UIColor whiteColor];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    [self.view addSubview:collectionView];
    
    [collectionView registerNib:[UINib nibWithNibName:@"BookTypeCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"TYPE_IDENTIFIER"];

}

-(NSMutableArray *)typeDataSource
{
    if (!_typeDataSource) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"BookType" ofType:@"plist"];;
        _typeDataSource = [NSMutableArray arrayWithContentsOfFile:path];
    }
    return _typeDataSource;
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.typeDataSource.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    BookTypeCell *typeCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TYPE_IDENTIFIER" forIndexPath:indexPath];
    NSDictionary *dic = self.typeDataSource[indexPath.row];
    
    [typeCell.showImage sd_setImageWithURL:[NSURL URLWithString:dic[@"showImage"]]];
    
    typeCell.labTitle.text = dic[@"showTitle"];
    
    return typeCell;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(ITEM_WIDTH, ITEM_WIDTH * 1.2);
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    return CGSizeMake(SCREEN_WIDTH, 113);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end

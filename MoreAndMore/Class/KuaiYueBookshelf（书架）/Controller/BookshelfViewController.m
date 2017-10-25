//
//  BookshelfViewController.m
//  MoreAndMore
//
//  Created by Silence on 16/6/5.
//  Copyright © 2016年 Silence. All rights reserved.
//

#import "BookshelfViewController.h"

#import "Topic.h"
#import "TextBook.h"

#import "MyBookCellOne.h"
#import "MyBookCellTwo.h"

#import "MyAddBookCell.h"
#import "MyHeaderTitleView.h"

#import "BookDetailViewController.h"
#import "BookTextDetailController.h"

#import "MyUserCenterController.h"

#define INSETS      20.f

#define HOR_WIDTH   (SCREEN_WIDTH - 4 * INSETS)/3
#define HOR_HEIGHT  (SCREEN_HEIGHT - INSETS - 64 - 49)/3
#define VER_HIEGHT  90

typedef NS_ENUM(NSInteger,BookShowType) {
    BookShowTypeOne,  // 一排三个
    BookShowTypeTwo  // 一排一个
};

@interface BookshelfViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,MyHeaderTitleViewDelegate>

@property (nonatomic,strong)UICollectionView *collectinView;

@property (nonatomic,assign)BOOL isEdit;

// 展示横向
@property (nonatomic,assign)BookShowType showType;


@property (nonatomic,strong)NSMutableArray *originalAry;

@property (nonatomic,strong)NSMutableArray *editAry;

@property (nonatomic,strong)UIButton *userButton;

@end

@implementation BookshelfViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.navigationItem.title = self.isFromUserCenter ? @"我的收藏" : @"我的书架";

    [self.view addSubview:self.collectinView];

    [self barItemWithPosition:BarItemPositionOfRight isImage:YES spacer:10 norArr:@[@"hot_topic_Nav",@"tweetBtn_Nav"] selArr:nil];
    
    // 用户头像按钮
    if (!self.isFromUserCenter)
    {
        self.navigationItem.leftBarButtonItems = @[[[UIBarButtonItem alloc] initWithCustomView:self.userButton]];
    }
}

#pragma mark - 导航栏事件

-(void)rightBarItemClick:(UIButton *)rightItem
{
    if ([[self.originalAry firstObject] count] < 1 && [[self.originalAry lastObject] count] < 1)
    {
        return;
    }
    
    rightItem.selected = !rightItem.selected;
    
    // 切换排序方式
    if (rightItem.tag - 888 == 0)
    {
        self.showType = rightItem.selected;
        [self.collectinView reloadData];
        self.collectinView.contentOffset = CGPointZero;
    }
    
    // 编辑
    if (rightItem.tag - 888 == 1)
    {
        BOOL isEdit = rightItem.selected;

        self.isEdit = isEdit;
        
        [self.collectinView reloadData];
    }
}

-(void)leftBarItemClick:(UIButton *)leftItem
{
    [MyUserCenterController showUserCenterWithAnimation:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - UICollectionViewDataSouce和UICollectionViewDelegate

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return self.dataSource.count;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (self.showType == BookShowTypeOne && !self.isEdit) {
        // 还有一个+按钮
        return [self.dataSource[section] count] + 1;
    }
    return [self.dataSource[section] count];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == [self.dataSource[indexPath.section] count])
    {
        MyAddBookCell *addCell = [collectionView dequeueReusableCellWithReuseIdentifier:MY_ADDBOOK forIndexPath:indexPath];
        return addCell;
    }
    
    if (self.showType == BookShowTypeOne)
    {
        MyBookCellOne *myBookOne = [collectionView dequeueReusableCellWithReuseIdentifier:MY_BOOKONE forIndexPath:indexPath];
        MyReaderBookModel *bookModel = self.dataSource[indexPath.section][indexPath.row];
        bookModel.isEdit = self.isEdit;
        myBookOne.readerModel = bookModel;
        return myBookOne;
    }
    else
    {
        MyBookCellTwo *myBookTwo = [collectionView dequeueReusableCellWithReuseIdentifier:MY_BOOKTWO forIndexPath:indexPath];
        MyReaderBookModel *bookModel = self.dataSource[indexPath.section][indexPath.row];
        bookModel.isEdit = self.isEdit;
        myBookTwo.readerModel = bookModel;
        return myBookTwo;
    }
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *theCell = [collectionView cellForItemAtIndexPath:indexPath];
    if ([theCell isKindOfClass:[MyAddBookCell class]])
    {
        NSDictionary *info;
        [[ZXJumpToControllerManager sharedZXJumpToControllerManager].jumpNavigation.topViewController dismissViewControllerAnimated:YES completion:nil];
        if (indexPath.section == 0)
        {
            [self.tabBarController setSelectedIndex:1];
            info = @{@"menu_jingxuan":@(1)};
        }
        else
        {
            [self.tabBarController setSelectedIndex:1];
            info = @{@"menu_jingxuan":@(0)};
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:CHANGE_JINGXUAN_MENU object:nil userInfo:info];
        return;
    }
    /**
     *  如果正在编辑
     */
    
    if (self.isEdit)
    {
        MyReaderBookModel *bookModel = self.dataSource[indexPath.section][indexPath.row];
        
        bookModel.isChoose = !bookModel.isChoose;
        
        BOOL isChoose = [self.editAry containsObject:indexPath];
        if (isChoose)
        {
            [self.editAry removeObject:indexPath];
        }
        else
        {
            [self.editAry addObject:indexPath];
        }
        [collectionView reloadItemsAtIndexPaths:@[indexPath]];
    }
    else
    {
        id model = self.originalAry[indexPath.section][indexPath.row];
        if ([model isKindOfClass:[Magic_Topic class]])
        {
            Magic_Topic *topic = (Magic_Topic *)model;
            
            BookDetailViewController *bookDetail = [[BookDetailViewController alloc] init];
            bookDetail.book = [Topic topicWithMagic:topic];
            bookDetail.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:bookDetail animated:YES];
        }
        if ([model isKindOfClass:[Magic_BookText class]])
        {
            Magic_BookText *bookText = (Magic_BookText *)model;
            
            BookTextDetailController *textBook = [[BookTextDetailController alloc] initWithStyle:UITableViewStyleGrouped];
            textBook.textBook = [TextBook toTextBook:bookText];
            textBook.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:textBook animated:YES];
        }
    }
}

-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableView = nil;
    if ([kind isEqualToString:UICollectionElementKindSectionHeader])
    {
        reusableView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:MY_HEADERTITLE forIndexPath:indexPath];
        MyHeaderTitleView *titleView = (MyHeaderTitleView *)reusableView;
        titleView.index = indexPath;
        titleView.isEdit = self.isEdit;
        titleView.delegate = self;
        NSArray *ary = @[@"图书",@"文字"];
        titleView.headerTitle.text = [NSString stringWithFormat:@"%@（%ld）",ary[indexPath.section],[self.dataSource[indexPath.section] count]];
    }
    return reusableView;
}

#pragma mark - MyHeaderTitleViewDelegate代理

-(void)MyHeaderRemoveBook:(MyHeaderTitleView *)headerView
{
    NSMutableArray *delAry = [NSMutableArray arrayWithCapacity:0];
    for (NSIndexPath *index in self.editAry)
    {
        if (index.section == headerView.index.section)
        {
            [delAry addObject:self.originalAry[index.section][index.row]];
        }
    }
    if (delAry.count > 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"你确定要删除所选的%ld本书籍吗?",delAry.count] message:nil delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        
        kSelfWeak;
        [alert showWithCompleteBlock:^(NSInteger buttonIndex) {
            if (buttonIndex == 1) {
                [weakSelf deleteBookWithAry:delAry];
            }
        }];
    }
    else
    {
        [self showTextWithState:ActivityHUDStateFailed inView:self.view text:@"你暂未选择任何书籍！"];
    }
}

#pragma mark - 从本地删除书籍

-(void)deleteBookWithAry:(NSMutableArray *)ary
{
    for (id model in ary)
    {
        if ([model isKindOfClass:[Magic_Topic class]])
        {
            // 删除图书书籍
            Magic_Topic *topic = (Magic_Topic *)model;
            BOOL isSuccess = [Magic_Topic MR_deleteAllMatchingPredicate:[NSPredicate predicateWithFormat:@"idd == %@", topic.idd]];
            if (isSuccess) {
                NSLog(@"删除《%@》成功！",topic.title);
            }
        }
        else
        {
            // 删除文字书籍
            Magic_BookText *bookText = (Magic_BookText *)model;
            BOOL isSuccess = [Magic_BookText MR_deleteAllMatchingPredicate:[NSPredicate predicateWithFormat:@"idd == %@", bookText.idd]];
            if (isSuccess) {
                NSLog(@"删除《%@》成功！",bookText.title);
            }
        }
    }
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreWithCompletion:^(BOOL contextDidSave, NSError *error) {
        if (!error){
            NSLog(@"删除数据成功!");
        }
    }];
    
    [self showTextWithState:ActivityHUDStateSuccess inView:self.view text:@"删除书籍成功!"];
    
    /**
     *  重新获取数据源
     */
    [self handleDataSource];
}

#pragma mark - 源数据处理

-(void)handleDataSource
{
    [self.originalAry removeAllObjects];
    [self.dataSource removeAllObjects];
    
    // 源数据
    NSMutableArray *sectionOne = [Topic selectMyCollectBook];
    NSMutableArray *sectionTwo = [TextBook selectMyCollectBook];
    [self.originalAry addObject:sectionOne];
    [self.originalAry addObject:sectionTwo];
    
    // 处理之后的数据
    for (NSMutableArray *ary in self.originalAry)
    {
        NSMutableArray *temp = [NSMutableArray arrayWithCapacity:0];
        for (id book in ary)
        {
            if ([book isKindOfClass:[Magic_Topic class]])
            {
                MyReaderBookModel *bookModel = [MyReaderBookModel readerBookModel:book];
                [temp addObject:bookModel];
            }
            if ([book isKindOfClass:[Magic_BookText class]])
            {
                MyReaderBookModel *bookModel = [MyReaderBookModel readerBookModel_Text:book];
                [temp addObject:bookModel];
            }
        }
        [self.dataSource addObject:temp];
    }
    
    [self.editAry removeAllObjects];
    self.isEdit = NO;
    
    [self.collectinView reloadData];
}

#pragma mark - 懒加载

-(NSMutableArray *)editAry
{
    if (!_editAry) {
        _editAry = [NSMutableArray arrayWithCapacity:0];
    }
    return _editAry;
}

-(NSMutableArray *)originalAry
{
    if (!_originalAry) {
        _originalAry = [NSMutableArray arrayWithCapacity:0];
    }
    return _originalAry;
}

-(UICollectionView *)collectinView
{
    if (!_collectinView) {
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.headerReferenceSize = CGSizeMake(SCREEN_WIDTH, 44.f);
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        
        _collectinView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - FIX_NAV_HEIGHT) collectionViewLayout:layout];
        
        if (self.isFromUserCenter)
        {
            _collectinView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - NAVIGATIONANDSTATUSBAR_HEIGHT);
        }
        
        _collectinView.backgroundColor = [UIColor whiteColor];
        
        _collectinView.alwaysBounceVertical = YES;
        
        [_collectinView registerNib:[UINib nibWithNibName:@"MyHeaderTitleView" bundle:[NSBundle mainBundle]] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:MY_HEADERTITLE];
        
        [_collectinView registerNib:[UINib nibWithNibName:@"MyBookCellOne" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:MY_BOOKONE];
        
        [_collectinView registerNib:[UINib nibWithNibName:@"MyBookCellTwo" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:MY_BOOKTWO];
        
        [_collectinView registerNib:[UINib nibWithNibName:@"MyAddBookCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:MY_ADDBOOK];
        
        _collectinView.delegate = self;
        _collectinView.dataSource = self;

    }
    return _collectinView;
}

#pragma mark - 布局相关设置

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.showType == BookShowTypeOne)
    {
        return CGSizeMake(HOR_WIDTH , HOR_HEIGHT);
    }
    else
    {
        return CGSizeMake(SCREEN_WIDTH, VER_HIEGHT);
    }
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    if (self.showType == BookShowTypeOne)
    {
        return UIEdgeInsetsMake(INSETS/2, INSETS, INSETS/2, INSETS);
    }
    
    return UIEdgeInsetsZero;
}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    if (self.showType == BookShowTypeOne)
    {
        return INSETS;
    }
    return 0.f;
}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    if (self.showType == BookShowTypeOne)
    {
        return INSETS;
    }
    return 0.f;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self handleDataSource];
    
    if (self.isFromUserCenter) return;
    
    if ([SingletonUser sharedSingletonUser].sessionKey.length > 0)
    {
        UIImage *defImage = [SingletonUser sharedSingletonUser].userInfo.userIconImage ? [SingletonUser sharedSingletonUser].userInfo.userIconImage : DEFAULT_ICON;
        
        [self.userButton sd_setImageWithURL:[NSURL URLWithString:[SingletonUser sharedSingletonUser].userInfo.avatar] forState:UIControlStateNormal placeholderImage:defImage];
    }
    else
    {
        [self.userButton setImage:DEFAULT_ICON forState:UIControlStateNormal];
    }
}

-(UIButton *)userButton
{
    if (!_userButton) {
        _userButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 28, 28)];
        _userButton.layer.masksToBounds = YES;
        _userButton.layer.cornerRadius = 14.f;
        _userButton.layer.borderWidth = 1.f;
        _userButton.layer.borderColor = [UIColor whiteColor].CGColor;

        [_userButton addTarget:self action:@selector(leftBarItemClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _userButton;
}

@end

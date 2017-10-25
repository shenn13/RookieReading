//
//  BookLibraryViewController.m
//  MoreAndMore
//
//  Created by apple on 16/9/14.
//  Copyright © 2016年 Silence. All rights reserved.
//

#import "BookLibraryViewController.h"

#import "BookSearchViewController.h"

#import "BookTextListFilterController.h"
#import "BookImageListFilterController.h"
#import "MyLikeSettingViewController.h"

#import "LibraryMenuItemCell.h"
#import "LibraryBookTextHeaderView.h"

@interface BookLibraryViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,LibraryBookTextHeaderViewDelegate,MyLikeSettingViewControllerDelegate>

@property (nonatomic,strong)UICollectionView *collectionView;

@property (nonatomic,strong)NSMutableArray *headerTitleArr;

// 男生
@property (nonatomic,strong)NSMutableArray *maleAry;
// 女生
@property (nonatomic,strong)NSMutableArray *femaleAry;
// 快看漫画
@property (nonatomic,strong)NSMutableArray *imgMenuAry;
// 出版
@property (nonatomic,strong)NSMutableArray *pressAry;

/**
 *  子分类列表数据源
 */
@property (nonatomic,strong)NSDictionary *categoryAry;

@end

@implementation BookLibraryViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"书库";
    
    // 搜索按钮
    [self barItemWithPosition:BarItemPositionOfRight isImage:YES spacer:10 norArr:@[@"search_Nav"] selArr:nil];

    // 内容区域
    [self.view addSubview:self.collectionView];

    // 子分类数据列表获取
    [self initWithSubCategoryList];
    
    kSelfWeak;
    // 下拉刷新
    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf initWithSubCategoryList];
    }];
    self.collectionView.mj_header.automaticallyChangeAlpha = YES;
}

-(void)rightBarItemClick:(UIButton *)rightItem
{
    BookSearchViewController *bookSearch = [[BookSearchViewController alloc] init];
    bookSearch.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:bookSearch animated:NO];
}

-(void)initWithSubCategoryList
{
    ZXRequestTool *request = [[ZXRequestTool alloc] init];
    kSelfWeak;
    [request baseRequestWithMethod:@"cats/lv2" requestType:RequestTypeOfZhuiShu params:nil completion:^(NSDictionary *responseObject) {
        if (SUCCESS_OK)
        {
            weakSelf.categoryAry = responseObject;
            [weakSelf initTextMenuListRequest];
        }
    } failure:^(NSError *error) {
        
    }];
}

-(void)initTextMenuListRequest
{
    ZXRequestTool *request = [[ZXRequestTool alloc] init];
    kSelfWeak;
    [request baseRequestWithMethod:[request getTextMethodWithType:URLTypeOfNine param:nil] requestType:RequestTypeOfZhuiShu params:nil completion:^(NSDictionary *responseObject) {
        if (SUCCESS_OK)
        {
            // 男生
            weakSelf.maleAry = [TextMenuModel toMenuModelAry:responseObject[@"male"]];
            NSArray *maleMins = weakSelf.categoryAry[@"male"];
            for (TextMenuModel *menuModel in weakSelf.maleAry)
            {
                menuModel.gender = GenderTypeOfMale;
                for (NSDictionary *dict in maleMins)
                {
                    if ([dict[@"major"] isEqualToString:menuModel.name])
                    {
                        menuModel.mins = dict[@"mins"];
                    }
                }
            }
            // 女生
            weakSelf.femaleAry = [TextMenuModel toMenuModelAry:responseObject[@"female"]];
            NSArray *femaleMins = weakSelf.categoryAry[@"female"];
            for (TextMenuModel *menuModel in weakSelf.femaleAry)
            {
                menuModel.gender = GenderTypeOfFemale;
                for (NSDictionary *dict in femaleMins)
                {
                    if ([dict[@"major"] isEqualToString:menuModel.name])
                    {
                        menuModel.mins = dict[@"mins"];
                    }
                }
            }
            // 出版榜
            weakSelf.pressAry = [TextMenuModel toMenuModelAry:responseObject[@"press"]];
            NSArray *pressMins = weakSelf.categoryAry[@"press"];
            for (TextMenuModel *menuModel in weakSelf.pressAry)
            {
                menuModel.gender = GenderTypeOfPress;
                for (NSDictionary *dict in pressMins)
                {
                    if ([dict[@"major"] isEqualToString:menuModel.name])
                    {
                        menuModel.mins = dict[@"mins"];
                    }
                }
            }
            
            [weakSelf myLikeSettingChangeAction:[SingletonUser sharedSingletonUser].likeType];
        }
        if ([weakSelf.collectionView.mj_header isRefreshing])
        {
            [weakSelf.collectionView.mj_header endRefreshing];
        }
    } failure:^(NSError *error) {
        if ([weakSelf.collectionView.mj_header isRefreshing])
        {
            [weakSelf.collectionView.mj_header endRefreshing];
        }
    }];
}

#pragma mark - UICollectionViewDataSource 代理

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return self.dataSource.count;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.dataSource[section] count];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    LibraryMenuItemCell *menuItemCell = [collectionView dequeueReusableCellWithReuseIdentifier:LIBRARY_MENU forIndexPath:indexPath];
    menuItemCell.menuModel = self.dataSource[indexPath.section][indexPath.row];
    return menuItemCell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    TextMenuModel *menuModel = self.dataSource[indexPath.section][indexPath.row];
    if (menuModel.type == AppApiTypeOfZhuiShu)
    {
        BookTextListFilterController *bookTextList = [[BookTextListFilterController alloc] init];
        bookTextList.menuModel = menuModel;
        bookTextList.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:bookTextList animated:YES];
    }
    else if (menuModel.type == AppApiTypeOfKuaiKan)
    {
        BookImageListFilterController *bookImageList = [[BookImageListFilterController alloc] init];
        bookImageList.menuIndex = indexPath.row;
        bookImageList.menuAry = self.imgMenuAry;
        bookImageList.menuModel = menuModel;
        bookImageList.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:bookImageList animated:YES];
    }
}

-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableView;
    if ([kind isEqualToString:UICollectionElementKindSectionHeader])
    {
        reusableView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:BOOKTEXT_HEADER forIndexPath:indexPath];
        LibraryBookTextHeaderView *header = (LibraryBookTextHeaderView *)reusableView;
        header.delegate = self;
        header.labTitle.text = self.headerTitleArr[indexPath.section];
        header.btnConfig.hidden = indexPath.section;
        header.imaSetIcon.hidden = indexPath.section;
    }
    return reusableView;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

#pragma mark - 偏好设置

-(void)didClickHeaderLikeSetingAction
{
    MyLikeSettingViewController *likeSetting = BoardVCWithID(@"Main", @"MYLIKE_VC");
    likeSetting.hidesBottomBarWhenPushed = YES;
    likeSetting.delegate = self;
    [self.navigationController pushViewController:likeSetting animated:YES];
}

-(void)myLikeSettingChangeAction:(MyLikeType)likeType
{
    //[self startActivityWithText:@"请稍等\n界面排版中!"];
    
    [self.dataSource removeAllObjects];
    // 重新排列数据
    if (likeType == MyLikeTypeOfMale)
    {
        [self.dataSource addObjectsFromArray:@[self.maleAry,self.femaleAry,self.imgMenuAry,self.pressAry]];
        self.headerTitleArr = [@[@"男生（文字）",@"女生（文字）",@"图书（图片）",@"出版（混合）"] mutableCopy];
    }
    else if (likeType == MyLikeTypeOfFemale)
    {
        [self.dataSource addObjectsFromArray:@[self.femaleAry,self.maleAry,self.imgMenuAry,self.pressAry]];
        self.headerTitleArr = [@[@"女生（文字）",@"男生（文字）",@"图书（图片）",@"出版（混合）"] mutableCopy];
    }
    else if (likeType == MyLikeTypeOfCortoon)
    {
        [self.dataSource addObjectsFromArray:@[self.imgMenuAry,self.maleAry,self.femaleAry,self.pressAry]];
        self.headerTitleArr = [@[@"图书（图片）",@"男生（文字）",@"女生（文字）",@"出版（混合）"] mutableCopy];
    }

    [self.collectionView reloadData];
    /*
    kSelfWeak;
    [self syncTaskOnMain:^{
        [weakSelf.collectionView reloadData];
        [weakSelf stopActivityWithText:@"排版成功" state:ActivityHUDStateSuccess];
    } after:0.4];
     */
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(UICollectionView *)collectionView
{
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.itemSize = CGSizeMake((SCREEN_WIDTH - 0.5f)/2.f, 50.f);
        flowLayout.sectionInset = UIEdgeInsetsMake(0.5f, 0, 10.f, 0);
        flowLayout.minimumInteritemSpacing = 0.4f;
        flowLayout.minimumLineSpacing = 0.5f;
        flowLayout.headerReferenceSize = CGSizeMake(SCREEN_WIDTH, 44.f);
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 49) collectionViewLayout:flowLayout];
        _collectionView.backgroundColor = LINE_COLOR;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.alwaysBounceVertical = YES;
        
        [_collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([LibraryMenuItemCell class]) bundle:[NSBundle mainBundle] ]forCellWithReuseIdentifier:LIBRARY_MENU];
        
        [_collectionView registerNib:[UINib nibWithNibName:@"LibraryBookTextHeaderView" bundle:[NSBundle mainBundle]] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:BOOKTEXT_HEADER];
    }
    return _collectionView;
}

-(NSMutableArray *)imgMenuAry
{
    if (!_imgMenuAry) {
        _imgMenuAry = [NSMutableArray arrayWithCapacity:0];
        NSArray *titleAry = @[@"全部",@"恋爱",@"爆笑",@"奇幻",@"恐怖",@"耿美",@"剧情",@"成人",@"日常",@"治愈",@"百合",@"三次元"];;
        NSArray *iddAry = @[@(0),@(20),@(24),@(22),@(32),@(36),@(23),@(44),@(19),@(27),@(45),@(41)];
        int i = 0;
        for (NSString *title in titleAry)
        {
            TextMenuModel *menu = [[TextMenuModel alloc] init];
            menu.name = title;
            menu.imgMenuId = iddAry[i];
            menu.type = AppApiTypeOfKuaiKan;
            menu.gender = [SingletonUser sharedSingletonUser].userInfo.sex;
            [_imgMenuAry addObject:menu];
            
            i++;
        }
    }
    return _imgMenuAry;
}

@end

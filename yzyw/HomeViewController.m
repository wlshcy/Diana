#import "HomeViewController.h"
#import "ItemCell.h"
#import "ItemSectionHeader.h"
#import "HomeHeader.h"
#import <MJRefresh.h>

#define ITEMWIDTH (290/2.0)
#define ITEMHEIGHT ((232+146)/2.0)
#define HEADERHEIGHT  210

#import "ItemDetailViewController.h"

@interface HomeViewController ()<UICollectionViewDataSource,
                                UICollectionViewDelegate,
                                UICollectionViewDelegateFlowLayout,
                                HomeHeaderDelegate,
                                UIScrollViewDelegate>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *listData;
@property (nonatomic, strong) NSMutableArray *slideData;
@property (nonatomic, strong) CaiHomeData *caiData;
@property (nonatomic, strong) NSMutableArray *items;
@property (nonatomic, strong) HomeHeader *header;
@property (nonatomic, strong) UIScrollView *scrollView;

@end

@implementation HomeViewController


- (instancetype)init
{
    if (self = [super init]) {
        [self layoutNavigationBar];
        _listData = [NSMutableArray arrayWithCapacity:5];
    }
    return self;
}

- (void)layoutNavigationBar
{
    self.title = @"首页";

}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setup];
    [ self getData];
}

- (void)setup
{
    self.view.backgroundColor = WHITE_COLOR;
    [self.view addSubview:self.collectionView];

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)getOnsales
{
    [HTTPManager getOnsales:^(NSMutableArray *response) {
        
        _slideData = response;
        
        [self.header configHomeHeader:response];
        
    } failure:^(NSError *err) {
        [self.collectionView.header endRefreshing];
    }];

}
- (void)getItems
{
    
    [HTTPManager getItems:nil success:^(NSMutableArray *response) {
        
        [self.collectionView.header endRefreshing];
        self.collectionView.footer.hidden = NO;
        
        _items = response;
        
        [_listData removeAllObjects];
        [_listData addObjectsFromArray:_items];
        [self.collectionView reloadData];
        
        if ([response count] <10){
            self.collectionView.footer.hidden = YES;
        }
    } failure:^(NSError *err) {
        [self.collectionView.header endRefreshing];
    }];
}



- (void)getData
{
    [self showLoading];
    [self getOnsales];
    [self getItems];
    [self hideLoading];
}

#pragma mark - CollectionDelegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _listData.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ITEMCELL" forIndexPath:indexPath];
        
    [cell configItemCell:_listData[indexPath.row]];
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    ItemSectionHeader *head = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"SECTIONHEADER" forIndexPath:indexPath];
    if (_items.count > 0) {
        head.titleLabel.text = @"蔬菜优选";
        head.line.hidden = NO;
    }else{
        head.titleLabel.text = nil;
        head.line.hidden = YES;
    }
    
    return head;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(SCREEN_WIDTH, 30);
}

#pragma mark --- delegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    ItemDetailViewController *controller = [[ItemDetailViewController alloc] init];
    controller.vid = _listData[indexPath.row][@"id"];
    controller.isNeedBottomBar = YES;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:controller];
        
    [self presentViewController:nav animated:YES completion:nil];
}


#pragma mark - Cai delegate
- (void)didSelectItemAtIndex:(NSInteger)index
{
    ItemDetailViewController *controller = [[ItemDetailViewController alloc] init];
    controller.vid = _slideData[index][@"id"];
    controller.isNeedBottomBar = YES;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:controller];
    
    [self presentViewController:nav animated:YES completion:nil];
}


- (void)getMoreItems:(id)sender
{
    NSString *lastid = [_listData lastObject][@"id"];
    
    [HTTPManager getItems:lastid success:^(NSMutableArray *response) {
        
        [self.collectionView.footer endRefreshing];
        
        if (response.count == 0) {
            [self showErrorStatusWithTitle:@"没有更多商品了"];
            self.collectionView.footer.hidden = YES;
            return ;
        }
            
        [_listData addObjectsFromArray:response];
        [_collectionView reloadData];
            
        if (response.count < 8) {
                self.collectionView.footer.hidden = YES;
            }
    } failure:^(NSError *err) {
        [self.collectionView.footer endRefreshing];

    }];

}

#pragma mark - Getter
- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];

        layout.sectionInset = UIEdgeInsetsMake(0, 10, 10, 10);
        
        layout.itemSize = CGSizeMake((SCREEN_WIDTH-30)/2.0, ITEMHEIGHT*((SCREEN_WIDTH-30)/2.0)/ITEMWIDTH);
                
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-49) collectionViewLayout:layout];
        _collectionView.backgroundColor = RGB_COLOR(245, 245, 245);
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        [_collectionView registerClass:[ItemCell class] forCellWithReuseIdentifier:@"CAICELL"];
        [_collectionView registerClass:[ItemSectionHeader class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"SECTIONHEADER"];
        
        _collectionView.contentInset = UIEdgeInsetsMake(HEADERHEIGHT, 0, 0, 0);
        [_collectionView addSubview:self.header];
        
        MJRefreshNormalHeader *refreshheader = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(getData)];
        refreshheader.ignoredScrollViewContentInsetTop = HEADERHEIGHT;
        refreshheader.lastUpdatedTimeLabel.hidden = YES;
        _collectionView.header = refreshheader;
        
        MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(getMoreItems:)];
        _collectionView.footer = footer;
        _collectionView.footer.hidden = YES;
    }
    return _collectionView;
}

- (UIScrollView *)scrollView
{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _scrollView.contentSize = CGSizeMake(SCREEN_WIDTH*3, SCREEN_HEIGHT);
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.pagingEnabled = YES;
        _scrollView.delegate = self;
    }
    
    return _scrollView;
}
@end

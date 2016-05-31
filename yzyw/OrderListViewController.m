//
//  OrderEnsureViewController.m
//  YW
//
//  Created by nmg on 16/1/20.
//  Copyright (c) 2016 nmg. All rights reserved.
//

#import "OrderListViewController.h"
#import "OrderCell.h"

#import <MJRefresh.h>


#define HEADER_HEIGHT 476/2.0

#define BOTTOM_HEIGHT 60

@interface OrderListViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) UITableView *listView;
@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, strong) UIButton *addBtn;
@property (nonatomic, assign) NSInteger flag;
@property (nonatomic, strong) NSMutableArray *listData;
@end

@implementation OrderListViewController


- (instancetype)init
{
    if (self = [super init]) {
        [self layoutNavigationBar];
        _listData = [NSMutableArray arrayWithCapacity:10];
    }
    return self;
}

- (void)layoutNavigationBar
{
    self.title = @"订单管理";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"nav_back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(clickLeftBarButton:)];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.listView];
    [self.listView.header beginRefreshing];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
}

- (void)viewDidLayoutSubviews
{
    if ([_listView respondsToSelector:@selector(setSeparatorInset:)]) {
        [_listView setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
    }
    
    if ([_listView respondsToSelector:@selector(setLayoutMargins:)]) {
        [_listView setLayoutMargins:UIEdgeInsetsMake(0,0,0,0)];
    }
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)refreshData:(NSNotification *)noti
{
    [self.listView.header beginRefreshing];
}


#pragma mark - TableViewDelegate & Datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    // Return the number of sections.
    return _listData.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    // Return the number of rows in the section.
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 160;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0,0, SCREEN_WIDTH,10)];
    view.backgroundColor = RGB_COLOR(242, 242, 242);
    return view;
}

//-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
//        [cell setSeparatorInset:UIEdgeInsetsZero];
//    }
//
//    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
//        [cell setLayoutMargins:UIEdgeInsetsZero];
//    }
//}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"ORDERCELL";
    OrderCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[OrderCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.backgroundColor = WHITE_COLOR;
    
    [cell configOrderCell];
    
    return cell;
    
    
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_flag == 1) {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"CHOOSEADDRESS" object:nil userInfo:_listData[indexPath.section]];
        [self.navigationController popViewControllerAnimated:YES];
    }
}


#pragma mark - User Action
- (void)clickLeftBarButton:(id)sender
{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)pullToRefresh
{
    [HTTPManager getAddresses:^(NSMutableArray *response) {
        
        
        [self.listView.header endRefreshing];
        self.listView.footer.hidden = NO;
        
        
        [_listData removeAllObjects];
        [_listData addObjectsFromArray:response];
        
        DBLog(@"%@", _listData);
        
        [self.listView reloadData];
        
        if ([response count] <10){
            self.listView.footer.hidden = YES;
        }
    } failure:^(NSError *err) {
        [self.listView.header endRefreshing];
    }];
}

- (void)upToRefresh
{
    [self.listView.header endRefreshing];
}



#pragma mark - Getter
- (UITableView *)listView
{
    if (!_listView) {
        _listView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH,  SCREEN_HEIGHT-60) style:UITableViewStylePlain];
        _listView.dataSource = self;
        _listView.delegate = self;
        _listView.tableFooterView = [UIView new];
        _listView.bounces = YES;
        _listView.showsHorizontalScrollIndicator = NO;
        _listView.showsVerticalScrollIndicator = NO;
        _listView.backgroundColor = RGB_COLOR(242, 242, 242);
        
        MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(pullToRefresh)];
        header.lastUpdatedTimeLabel.hidden = YES;
        _listView.header = header;
        
        MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(upToRefresh)];
        _listView.footer = footer;
        _listView.footer.hidden = YES;
    }
    return _listView;
}

@end

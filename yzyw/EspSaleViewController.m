//
//  ShoppingCarViewController.m
//  Garden
//
//  Created by nmg on 1/12/16.
//  Copyright (c) 2015 Nmg. All rights reserved.
//

#import "EspSaleViewController.h"
#import "VegDetailViewController.h"
#import "EspCell.h"
#import <MJRefresh.h>

#define HEADERHEIGHT  (216/2.0+90)


@interface EspSaleViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView *listView;
@property (nonatomic, strong) NSMutableArray *listData;
@property (nonatomic, strong) NSMutableArray *items;

@property (nonatomic) UIEdgeInsets separatorInset NS_AVAILABLE_IOS(7_0) UI_APPEARANCE_SELECTOR;


@end

@implementation EspSaleViewController


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
    self.title = @"特卖产品";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.listView];
    
//
    
    [self.listView.header beginRefreshing];
}

- (void)pullToRefresh
{
    [HTTPManager getVegs:nil success:^(NSMutableArray *response) {
        
        
                [self.listView.header endRefreshing];
                self.listView.footer.hidden = NO;
        
                _items = response;
        
                [_listData removeAllObjects];
                [_listData addObjectsFromArray:_items];
                [self.listView reloadData];
        
                if ([response count] <4){
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


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//
//
//#pragma mark - UITableViewDelegate
//
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    // Return the number of sections.
    return 1;
}
//
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    // Return the number of rows in the section.
    return _listData.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 130;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIndentifier = @"ESPCELL";
    EspCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
    if (!cell) {
        cell = [[EspCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    [tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [tableView setSeparatorColor:[UIColor colorWithRed:242.0/255.0f green:242.0/255.0f blue:242.0/255.0f alpha:1.0]];
    
    [cell configEspCell:_listData[indexPath.row]];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0,120, SCREEN_WIDTH,10)];
    view.backgroundColor = RGB_COLOR(242, 242, 242);
    [ cell addSubview:view];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    VegDetailViewController *controller = [[VegDetailViewController alloc] init];
    controller.vid = _listData[indexPath.row][@"id"];
    controller.isNeedBottomBar = YES;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:controller];
    
    [self presentViewController:nav animated:YES completion:nil];
}
//#pragma mark - Getter
- (UITableView *)listView
{
    if (!_listView) {
        _listView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
        _listView.dataSource = self;
        _listView.delegate = self;
        _listView.backgroundColor = TABLE_COLOR;
        _listView.tableFooterView = [UIView new];
        _listView.showsHorizontalScrollIndicator = NO;
        _listView.showsVerticalScrollIndicator = NO;
        
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

//
//  ComboListViewController.m
//  yzyw
//
//  Created by nmg on 16/3/14.
//  Copyright © 2016年 nmg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ComboListViewController.h"
#import "ComboListCell.h"
#import "ComboDetailViewController.h"
#import <MJRefresh.h>

#define CELL_HEIGHT  170

@interface  ComboListViewController()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) UITableView *listView;
@property (nonatomic, strong) NSMutableArray *combos;
@end

@implementation ComboListViewController

- (instancetype)init
{
    if (self = [super init]) {
        [self layoutNavigationBar];
         _combos = [NSMutableArray arrayWithCapacity:10];
    }
    return self;
}

- (void)layoutNavigationBar
{
    self.title = @"套餐";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = WHITE_COLOR;
    [self.view addSubview:self.listView];
    
    [self.listView.header beginRefreshing];

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self hideLoading];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  
    return _combos.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return CELL_HEIGHT;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
        static NSString *cellIndentifier = @"COMBOLISTCELL";
        ComboListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
        if (!cell) {
            cell = [[ComboListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier];
            cell.selectionStyle = UITableViewCellSeparatorStyleNone;
        }
        [cell configComboListCell:_combos[indexPath.row]];
    
        return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ComboDetailViewController *controller = [[ComboDetailViewController alloc] init];
    controller.cid = _combos[indexPath.row][@"id"];
//    controller.isNeedBottomBar = YES;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:controller];
    
    [self presentViewController:nav animated:YES completion:nil];
}

- (void)pullToRefresh
{
    [HTTPManager getCombos:nil success:^(NSMutableArray *response) {
        
        
        [self.listView.header endRefreshing];
        self.listView.footer.hidden = NO;
    
        [_combos removeAllObjects];
        [_combos addObjectsFromArray:response];
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


- (UITableView *)listView
{
    if (!_listView) {
        _listView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64-49) style:UITableViewStylePlain];
        _listView.dataSource = self;
        _listView.delegate = self;
        _listView.backgroundColor = TABLE_COLOR;
        _listView.tableFooterView = [UIView new];
        _listView.showsHorizontalScrollIndicator = NO;
        _listView.showsVerticalScrollIndicator = NO;
        _listView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(pullToRefresh)];
        header.lastUpdatedTimeLabel.hidden = YES;
        _listView.header = header;
        
        MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(upToRefresh)];
        _listView.footer = footer;
        _listView.footer.hidden = YES;    }
    return _listView;
}

@end
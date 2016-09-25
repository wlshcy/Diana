//
//  OrderEnsureViewController.m
//  YW
//
//  Created by nmg on 16/1/20.
//  Copyright (c) 2016 nmg. All rights reserved.
//

#import "AddressListCell.h"
#import "AddressListViewController.h"
#import "AddAddressViewController.h"

#import <MJRefresh.h>


#define HEADER_HEIGHT 476/2.0

#define BOTTOM_HEIGHT 60

@interface AddressListViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) UITableView *listView;
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, strong) UIButton *addBtn;
@property (nonatomic, assign) NSInteger flag;
@property (nonatomic, strong) NSMutableArray *listData;
@end

@implementation AddressListViewController


- (instancetype)initWithFlag:(NSInteger)flag
{
    if (self = [super init]) {
        _flag = flag;
        [self layoutNavigationBar];
        _listData = [NSMutableArray arrayWithCapacity:10];
        
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshData:) name:@"ADDUSERADDRESS" object:nil];
    return self;
}

- (void)layoutNavigationBar
{
    self.title = @"地址管理";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"nav_back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(clickLeftBarButton:)];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.listView];
    [self.view addSubview:self.bottomView];
    [self.bottomView addSubview:self.addBtn];
    
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
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0){
        return 80;
    }
    return 40;
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
    
        static NSString *CellIdentifier = @"ADDRESSCEL";
        AddressListCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[AddressListCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
    
//    [cell configAddrCell:indexPath data:_listData];
        cell.backgroundColor = WHITE_COLOR;
//        [cell conf]
//    for (int i=0; i<=_listData.count; i++) {
        if (indexPath.row == 0) {
            [cell configAddrCell:_listData[indexPath.section]];
        }
        else{
    
            UIButton *default_btn = [UIButton buttonWithType:UIButtonTypeCustom];
            default_btn.frame = CGRectMake(8, 10, 100, 20);
            default_btn.backgroundColor = WHITE_COLOR;
            [default_btn setTitleColor:BLACK_COLOR forState:UIControlStateNormal];
            default_btn.titleLabel.font = FONT(14);
            default_btn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 10);
            

            if ([_listData[indexPath.section][@"default"] boolValue]) {
                [default_btn setTitle:@"默认地址" forState:UIControlStateNormal];
                [default_btn setImage:[UIImage imageNamed:@"default_addr.png"] forState:UIControlStateNormal];
            }else{
                [default_btn setTitle:@"设为默认" forState:UIControlStateNormal];
                [default_btn setImage:[UIImage imageNamed:@"set_default.png"] forState:UIControlStateNormal];
                [default_btn addTarget:self action:@selector(setDefault:) forControlEvents:UIControlEventTouchUpInside];
            }
            [cell addSubview:default_btn];
            
            UIButton *edit_btn = [UIButton buttonWithType:UIButtonTypeCustom];
            edit_btn.frame = CGRectMake(SCREEN_WIDTH/2+10, 10, 60, 20);
            edit_btn.backgroundColor = WHITE_COLOR;
            [edit_btn setTitle:@"编辑" forState:UIControlStateNormal];
            [edit_btn setImage:[UIImage imageNamed:@"modify_add.png"] forState:UIControlStateNormal];
            [edit_btn setTitleColor:BLACK_COLOR forState:UIControlStateNormal];
            edit_btn.titleLabel.font = FONT(14);
            //            edit_btn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 10);
            [cell addSubview:edit_btn];
            
            UIButton *del_btn = [UIButton buttonWithType:UIButtonTypeCustom];
            del_btn.frame = CGRectMake(edit_btn.right, 10, 100, 20);
            del_btn.backgroundColor = WHITE_COLOR;
            [del_btn setTitle:@"删除" forState:UIControlStateNormal];
            [del_btn setImage:[UIImage imageNamed:@"delete_addr.png"] forState:UIControlStateNormal];
            [del_btn setTitleColor:BLACK_COLOR forState:UIControlStateNormal];
            del_btn.titleLabel.font = FONT(14);
            del_btn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 10);
            [del_btn addTarget:self action:@selector(deleteAddr:) forControlEvents:UIControlEventTouchUpInside];
            //            [default_btn setTag:_listData[indexPath.row][@"id"]];
            [cell addSubview:del_btn];
     }
    
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
        
        [_listData sortUsingDescriptors:
         @[
           [NSSortDescriptor sortDescriptorWithKey:@"default" ascending:NO],
           ]];
        
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
        _listView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH,  SCREEN_HEIGHT-BOTTOM_HEIGHT-60) style:UITableViewStylePlain];
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

- (UIView *)bottomView
{
    if (!_bottomView) {
        _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, _listView.bottom, SCREEN_WIDTH, BOTTOM_HEIGHT)];
    }
    return _bottomView;
}

- (UIButton *)addBtn
{
    if (!_addBtn) {
        _addBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        _addBtn.frame = CGRectMake(0, 0, SCREEN_WIDTH, BOTTOM_HEIGHT);
        _addBtn.backgroundColor = WHITE_COLOR;
        [_addBtn setTitle:@"添加地址" forState:UIControlStateNormal];
        [_addBtn setTitleColor:RGB_COLOR(243, 96, 67) forState:UIControlStateNormal];
        _addBtn.titleLabel.font = FONT(16);
        
        [_addBtn addTarget:self action:@selector(addAddr:) forControlEvents:UIControlEventTouchUpInside];
        _addBtn.adjustsImageWhenHighlighted = YES;
    }
    return _addBtn;
}



- (void)addAddr:(UIButton *)sender

{
    AddAddressViewController *controller = [[AddAddressViewController alloc] init];
    controller.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)setDefault:(UIButton *)sender
{
    AddressListCell *cell = (AddressListCell *)sender.superview;
    NSIndexPath *indexPath = [self.listView indexPathForCell:cell];
    [sender setTitle:@"默认地址" forState:UIControlStateNormal];
    [sender setImage:[UIImage imageNamed:@"default_addr.png"] forState:UIControlStateNormal];
    [HTTPManager setDefaultAddress:_listData[indexPath.section][@"id"] success:^(NSMutableArray *response) {
        [self.listView.header beginRefreshing];
        
    } failure:^(NSError *err) {
        
    }];

}

- (void)deleteAddr:(UIButton *)sender
{
    AddressListCell *cell = (AddressListCell *)sender.superview;
    NSIndexPath *indexPath = [self.listView indexPathForCell:cell];
    
    [HTTPManager deleteAddress:_listData[indexPath.section][@"id"] success:^(NSMutableArray *response) {
        [self.listView.header beginRefreshing];
        
    } failure:^(NSError *err) {
       
    }];
}

@end

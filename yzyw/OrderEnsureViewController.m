//
//  OrderEnsureViewController.m
//  YW
//
//  Created by nmg on 16/1/20.
//  Copyright (c) 2016 nmg. All rights reserved.
//

#import "LoginViewController.h"
#import "PayController.h"
#import "OrderEnsureViewController.h"
#import "AddressCell.h"
#import <AlipaySDK/AlipaySDK.h>
#import "EnsureCell.h"
#import "PriceCell.h"

#import "WXApi.h"
#import "WXApiObject.h"

#import "AddressListViewController.h"
#import "ZoneListViewController.h"

#import "RDVTabBarController.h"
#import "RDVTabBarItem.h"

#define HEADER_HEIGHT 476/2.0

#define BOTTOM_HEIGHT 60

@interface OrderEnsureViewController ()<UITableViewDataSource,UITableViewDelegate,UIPageViewControllerDelegate>
@property (nonatomic, strong) UITableView *listView;
@property (nonatomic, strong) NSMutableArray *items;
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, strong) UIButton *submitBtn;
@property (nonatomic, strong) UILabel *headerLabel;
@property (nonatomic, strong) UIButton *wxpayButton;
@property (nonatomic, strong) UIButton *alipayButton;
//@property (nonatomic, strong) UIButton *dfpayButton;
@end

@implementation OrderEnsureViewController


- (instancetype)init
{
    if (self = [super init]) {
        [self layoutNavigationBar];
        _items = [NSMutableArray arrayWithCapacity:10];
        
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(chooseAddress:) name:@"CHOOSEADDRESS" object:nil];
        
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(wxpayResult:) name:@"WXPAYRESULT" object:nil];
    }
    return self;
}

- (void)layoutNavigationBar
{
    self.title = @"订单填写";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"nav_back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(clickLeftBarButton:)];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.listView];
    self.listView.tableHeaderView = self.headerLabel;
    [self.view addSubview:self.bottomView];
    [self.bottomView addSubview:self.priceLabel];
    [self.bottomView addSubview:self.submitBtn];
    
    [self setup];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[self rdv_tabBarController] setTabBarHidden:YES animated:NO];
    
    [_items removeAllObjects];
    [_items addObjectsFromArray:[[DBManager instance] getAllItems]];
    
    self.listView.hidden = NO;
    self.bottomView.hidden = NO;
    
    [self computeTotalPrice];
    [_listView reloadData];
    
    [self.wxpayButton setImage:[UIImage imageNamed:@"del_image_2.png"] forState:UIControlStateNormal];
    [self.alipayButton setImage:[UIImage imageNamed:@"del_image_1.png"] forState:UIControlStateNormal];
    self.payType = 0;
    
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



- (void)setup
{
    [self getDefaultAddress];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)chooseAddress:(NSNotification *)noti
{
    NSDictionary *address = [noti userInfo];
    
    self.address = address;
    
    [self.listView reloadData];
    
}

- (void)getDefaultAddress
{
    [HTTPManager getDefaultAddress:^(NSDictionary *response) {
        
        self.address = response;
        
        [self.listView reloadData];
        
    } failure:^(NSError *err) {
        DBLog(@"%@", err);
        
        long statusCode = [[[err userInfo] objectForKey:AFNetworkingOperationFailingURLResponseErrorKey] statusCode];
        if (statusCode == 401){
            UINavigationController *navLogin = [[UINavigationController alloc] initWithRootViewController:[LoginViewController new]];
            [self presentViewController:navLogin animated:YES completion:nil];
            [self getDefaultAddress];
        }
    }];
}


#pragma mark - TableViewDelegate & Datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    // Return the number of sections.
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    // Return the number of rows in the section.
    if (section == 0) {
        return 1;
    }else if(section == 1){
        return _items.count;
    }else if(section == 2){
        return 3;
    }else{
        return 2;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 80;
    }
    else if (indexPath.section == 1){
        
            return 50;
    }
    else if(indexPath.section == 2){
            return 45;
    }else{
        return 50;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0;
    }
        return 5;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0){
//        return @"收货地址";
        return @"";
    }
    else if (section == 1){
//        return @"商品列表";
        return @"";
    }
    else{
        return @"";
    }
    
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UILabel *myLabel = [[UILabel alloc] init];
    myLabel.frame = CGRectMake(15, 0, 320, 33);
    myLabel.font = [UIFont boldSystemFontOfSize:16];
    myLabel.textColor = [UIColor grayColor];
    myLabel.text = [self tableView:tableView titleForHeaderInSection:section];
    
    UIView *headerView = [[UIView alloc] init];
    [headerView addSubview:myLabel];
    
    return headerView;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    if (indexPath.section == 0) {
        
        static NSString *CellIdentifier = @"addressCell";
        AddressCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//        if (cell == nil) {
//            cell = [[AddressCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
//        }
        cell = [[AddressCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        cell.textLabel.text = nil;
        cell.detailTextLabel.text = nil;
        if (_address) {
            UILabel *info = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, SCREEN_WIDTH, 20)];
            info.text = [NSString stringWithFormat:@"%@  %@",_address[@"name"],_address[@"mobile"]];
            info.font = FONT(16);
            
            UILabel *address = [[UILabel alloc] initWithFrame:CGRectMake(15, info.bottom+15, SCREEN_WIDTH, 20)];
            address.text = [NSString stringWithFormat:@"%@%@",_address[@"region"],_address[@"address"]];
            address.font = FONT(14);
            
            [cell addSubview:info];
            [cell addSubview:address];
        }
        else {
            cell.textLabel.text = @"请选择收货地址";

        }
            
        cell.textLabel.font = FONT(16);
        cell.detailTextLabel.font = FONT(14);
        cell.textLabel.textColor = BLACK_COLOR;
        cell.detailTextLabel.textColor = GRAY_COLOR;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        return cell;
        
        
        
    }else if (indexPath.section == 1){
        static NSString *cellIndentifier = @"itemCell";
//        EnsureCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
        if (!cell) {
            cell = [[EnsureCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIndentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
//        [cell populateCell:_items[indexPath.row]];
        cell.textLabel.text = _items[indexPath.row][@"name"];
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@份",_items[indexPath.row][@"count"]];
        cell.detailTextLabel.textColor = BLACK_COLOR;
        cell.textLabel.font = FONT(16);
        cell.detailTextLabel.font = FONT(16);
        
        if ([tableView respondsToSelector:@selector(setSeparatorInset:)]) {
            [tableView setSeparatorInset:UIEdgeInsetsZero];
        }
        
        if ([tableView respondsToSelector:@selector(setLayoutMargins:)]) {
            [tableView setLayoutMargins:UIEdgeInsetsZero];
        }
        
        if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
            [cell setLayoutMargins:UIEdgeInsetsZero];
        }
        
        [tableView setSeparatorColor:[UIColor colorWithRed:242.0/255.0f green:242.0/255.0f blue:242.0/255.0f alpha:1.0]];
        

        return cell;
    }else if(indexPath.section == 2){
        if (indexPath.row == 0) {
            static NSString *CellIdentifier = @"PRICECELL";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            cell.textLabel.text = @"商品价格";
            cell.textLabel.font = FONT(16);
            
            NSString *text = [NSString stringWithFormat:@"¥ %.1f", _totalPrice - _freight];
            cell.detailTextLabel.text = text;
            cell.detailTextLabel.font = FONT(16);
            cell.detailTextLabel.textColor = RGB_COLOR(0,0,0);
            return cell;
        }
        else if (indexPath.row == 1){
            static NSString *CellIdentifier = @"FREIGHTCELL";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            cell.textLabel.text = @"运费";
            cell.textLabel.font = FONT(16);
            
            NSString *text = [NSString stringWithFormat:@"¥ %.0f", _freight];
            cell.detailTextLabel.text = text;
            cell.detailTextLabel.font = FONT(16);
            cell.detailTextLabel.textColor = RGB_COLOR(243, 96, 67);
//            cell.detailTextLabel.textColor = RGB_COLOR(0,0,0);
            return cell;
        }
        else {
            static NSString *CellIdentifier = @"TOTALPRICECELL";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            cell.textLabel.text = @"合计";
            cell.textLabel.font = FONT(16);
            
            NSString *text = [NSString stringWithFormat:@"¥ %.1f", _totalPrice];
            cell.detailTextLabel.text = text;
            cell.detailTextLabel.font = FONT(16);
            cell.detailTextLabel.textColor = RGB_COLOR(0,0,0);
            return cell;
        }
    }else{
        if (indexPath.row == 0) {
            static NSString *CellIdentifier = @"PAYWAYCELL";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
        
            [cell addSubview:self.wxpayButton];
            return cell;
        }else if (indexPath.row == 1){
            static NSString *CellIdentifier = @"PAYWAYCELL";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            
            [cell addSubview:self.alipayButton];
            return cell;
        }else{
            static NSString *CellIdentifier = @"PAYWAYCELL";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            
//            [cell addSubview:self.dfpayButton];
            
            return cell;
        }
        

    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        
            AddressListViewController *controller = [[AddressListViewController alloc] initWithFlag:1];
        
            [self.navigationController pushViewController:controller animated:YES];
    }
}


#pragma mark - User Action
- (void)clickLeftBarButton:(id)sender
{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

#pragma mark - Getter
- (UITableView *)listView
{
    if (!_listView) {
        _listView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH,  SCREEN_HEIGHT-BOTTOM_HEIGHT-65) style:UITableViewStylePlain];
        _listView.dataSource = self;
        _listView.delegate = self;
        _listView.tableFooterView = [UIView new];
        _listView.bounces = YES;
        _listView.showsHorizontalScrollIndicator = NO;
        _listView.showsVerticalScrollIndicator = NO;
        _listView.backgroundColor = RGB_COLOR(242, 242, 242);
    }
    return _listView;
}

- (UILabel *)headerLabel
{
    if (!_headerLabel) {
        _headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 30)];
        _headerLabel.backgroundColor = RGB_COLOR(50, 190, 112);
        _headerLabel.text = @"  当日下单次日送达，计划开通2小时送达";
        _headerLabel.font = FONT(12);
        _headerLabel.textColor = WHITE_COLOR;
    }
    return _headerLabel;
}

- (UIView *)bottomView
{
    if (!_bottomView) {
        _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, _listView.bottom, SCREEN_WIDTH, BOTTOM_HEIGHT)];
    }
    return _bottomView;
}

- (UILabel *)priceLabel
{
    if (!_priceLabel) {
        _priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, (self.bottomView.height-30)/2.0, 150, 30)];
        _priceLabel.textColor = RED_COLOR;
        _priceLabel.font = FONT(16);
    }
    return _priceLabel;
}

- (UIButton *)submitBtn
{
    if (!_submitBtn) {
        _submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _submitBtn.backgroundColor = RGB_COLOR(243, 96, 67);
        _submitBtn.frame = CGRectMake(SCREEN_WIDTH-110, 10 , 100,40);
        [_submitBtn setTitleColor:WHITE_COLOR forState:UIControlStateNormal];
        [_submitBtn setTitle:@"提交订单" forState:UIControlStateNormal];
        _submitBtn.titleLabel.font = FONT(16);
        _submitBtn.layer.cornerRadius = 3;
        [_submitBtn addTarget:self action:@selector(commitOrder:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _submitBtn;
}

- (UIButton *)wxpayButton
{
    if (!_wxpayButton){
        _wxpayButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _wxpayButton.frame = CGRectMake(8, 20, SCREEN_WIDTH, 20);
        _wxpayButton.backgroundColor = WHITE_COLOR;
        [_wxpayButton setTitle:@"微信支付" forState:UIControlStateNormal];
        [_wxpayButton setImage:[UIImage imageNamed:@"del_image_1.png"] forState:UIControlStateNormal];
        [_wxpayButton setTitleColor:BLACK_COLOR forState:UIControlStateNormal];
        _wxpayButton.titleLabel.font = FONT(16);
        _wxpayButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        _wxpayButton.imageEdgeInsets = UIEdgeInsetsMake(0, SCREEN_WIDTH-60, 0, 0);
        _wxpayButton.titleEdgeInsets = UIEdgeInsetsMake(0, -20,0,0);
        [_wxpayButton addTarget:self action:@selector(wx_pay:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _wxpayButton;
}

- (UIButton *)alipayButton
{
    if (!_alipayButton){
        _alipayButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _alipayButton.frame = CGRectMake(8, 20, SCREEN_WIDTH, 20);
        _alipayButton.backgroundColor = WHITE_COLOR;
        [_alipayButton setTitle:@"支付宝" forState:UIControlStateNormal];
        [_alipayButton setImage:[UIImage imageNamed:@"del_image_1.png"] forState:UIControlStateNormal];
        [_alipayButton setTitleColor:BLACK_COLOR forState:UIControlStateNormal];
        _alipayButton.titleLabel.font = FONT(16);
        _alipayButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        _alipayButton.imageEdgeInsets = UIEdgeInsetsMake(0, SCREEN_WIDTH-60, 0, 0);
        _alipayButton.titleEdgeInsets = UIEdgeInsetsMake(0, -20,0,0);
        [_alipayButton addTarget:self action:@selector(ali_pay:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _alipayButton;
}

//- (UIButton *)dfpayButton
//{
//    if (!_dfpayButton){
//        _dfpayButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        _dfpayButton.frame = CGRectMake(8, 20, SCREEN_WIDTH, 20);
//        _dfpayButton.backgroundColor = WHITE_COLOR;
//        [_dfpayButton setTitle:@"货到付款" forState:UIControlStateNormal];
//        [_dfpayButton setImage:[UIImage imageNamed:@"del_image_1.png"] forState:UIControlStateNormal];
//        [_dfpayButton setTitleColor:BLACK_COLOR forState:UIControlStateNormal];
//        _dfpayButton.titleLabel.font = FONT(16);
//        _dfpayButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
//        _dfpayButton.imageEdgeInsets = UIEdgeInsetsMake(0, SCREEN_WIDTH-60, 0, 0);
//        _dfpayButton.titleEdgeInsets = UIEdgeInsetsMake(0, -20,0,0);
//        [_dfpayButton addTarget:self action:@selector(df_pay:) forControlEvents:UIControlEventTouchUpInside];
//    }
//    return _dfpayButton;
//}

- (void)computeTotalPrice
{
    
    
    if (_totalPrice >= 5) {
        
        _priceLabel.text = [NSString stringWithFormat:@"合计:%0.2f元",_totalPrice];
        
    }else{
        _priceLabel.text = [NSString stringWithFormat:@"合计:%0.2f元",_totalPrice+5];
    }
    
}

- (void)payment_method:(UIButton *)sender
{

//    [sender setImage:[UIImage imageNamed:@"del_image_2.png"] forState:UIControlStateSelected];
}

- (void)wx_pay:(UIButton *)sender
{
    [self.wxpayButton setImage:[UIImage imageNamed:@"del_image_2.png"] forState:UIControlStateNormal];
    [self.alipayButton setImage:[UIImage imageNamed:@"del_image_1.png"] forState:UIControlStateNormal];
    self.payType = 0;
//    [self.dfpayButton setImage:[UIImage imageNamed:@"del_image_1.png"] forState:UIControlStateNormal];
}

- (void)ali_pay:(UIButton *)sender
{
    [self.wxpayButton setImage:[UIImage imageNamed:@"del_image_1.png"] forState:UIControlStateNormal];
    [self.alipayButton setImage:[UIImage imageNamed:@"del_image_2.png"] forState:UIControlStateNormal];
    self.payType = 1;
//    [self.dfpayButton setImage:[UIImage imageNamed:@"del_image_1.png"] forState:UIControlStateNormal];
}

//- (void)df_pay:(UIButton *)sender
//{
//    [self.wxpayButton setImage:[UIImage imageNamed:@"del_image_1.png"] forState:UIControlStateNormal];
//    [self.alipayButton setImage:[UIImage imageNamed:@"del_image_1.png"] forState:UIControlStateNormal];
//    [self.dfpayButton setImage:[UIImage imageNamed:@"del_image_2.png"] forState:UIControlStateNormal];
//}


- (void)commitOrder:(UIButton *)sender

{
    if (self.address) {
        NSMutableArray *item_list = [[NSMutableArray alloc] init];
        for(int i=0; i<[_items count]; i++){
            NSMutableDictionary *item = [[NSMutableDictionary alloc] init];

            [item setObject:[_items objectAtIndex:i][@"id"] forKey:@"id"];
            [item setValue:[_items objectAtIndex:i][@"count"] forKey:@"count"];
            [item_list addObject:item];
        }
        
        [HTTPManager createOrder:_address[@"name"] mobile:_address[@"mobile"] region:_address[@"region"] address:_address[@"address"] paytype:_payType items:item_list success:^(id response) {

            [self hideLoading];
//            PayController *controller = [[PayController alloc] init];
//            controller.number = response[@"number"];
//            controller.price = [response[@"price"] floatValue];
//            controller.hidesBottomBarWhenPushed = YES;
//            [self.navigationController pushViewController:controller animated:YES];
            
        } failure:^(NSError *err) {
            [self hideLoading];
            [self showFailureStatusWithTitle:@"服务器繁忙，请稍后重试"];
            
        }];
        
    }
    else{
        [self showErrorStatusWithTitle:@"请选择收货地址"];
    }
   
}
@end

//
//  PayCaiController.m
//  Garden
//
//  Created by 金学利 on 9/14/15.
//  Copyright (c) 2015 Kingxl. All rights reserved.
//

#import "PayController.h"
//#import "AddressCell.h"
#import <AlipaySDK/AlipaySDK.h>
#import "PriceCell.h"

#import "WXApi.h"
#import "WXApiObject.h"

//change
//#import "ManageAddressViewController.h"
//#import "RedPacketViewController.h"
//#import "PayResultViewController.h"

#import "HomeViewController.h"

#define HEADER_HEIGHT 476/2.0
#define BOTTOM_HEIGHT 50

@interface PayController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) UITableView *listView;
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) CouponsData *coupondata; //订单
@property (nonatomic, assign) NSInteger oldcouponid; //原始红包id；

@property (nonatomic, strong) NSDictionary *wxpayResponse;

@property (nonatomic, strong) UIButton *cancelBtn;

@end

@implementation PayController


- (instancetype)init
{
    if (self = [super init]) {
        [self layoutNavigationBar];
    }
    return self;
}

- (void)layoutNavigationBar
{
    self.title = @"收银台";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"nav_back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(clickLeftBarButton:)];
}

- (void)clickLeftBarButton:(id)sender
{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = WHITE_COLOR;
    
     [self.view addSubview:self.listView];
     [self.view addSubview:self.bottomView];
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



- (void)setup
{
    [self.view addSubview:self.listView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - TableViewDelegate & Datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    // Return the number of sections.
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    // Return the number of rows in the section.
    if (section == 0) {
        return 1;
    }else if (section == 1){
        return 2;
    }else{
    
        return 1;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 50;
    }
    return 60;
        
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 8;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
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
    
    [tableView setSeparatorColor:[UIColor colorWithRed:242.0/255.0f green:242.0/255.0f blue:242.0/255.0f alpha:1.0]];
    
    if (indexPath.section==0){
//        if (indexPath.row == 0) {
//            static NSString *cellIndentifier = @"ORDERNUMCELL";
//            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
//            if (!cell) {
//                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIndentifier];
//                cell.selectionStyle = UITableViewCellSelectionStyleNone;
//            }
//            
//            cell.textLabel.text = @"订单号";
//            cell.textLabel.font = FONT(16);
//            cell.detailTextLabel.text = self.number;
//            cell.accessoryType = UITableViewCellAccessoryNone;
//            
//            return cell;
//        }
//        else{
            static NSString *cellIndentifier = @"PAYPRICECELL";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIndentifier];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            
            cell.textLabel.text = @"支付金额";
            cell.textLabel.font = FONT(16);
            
            cell.detailTextLabel.text = [NSString stringWithFormat:@"¥ %.2f",self.price];
            cell.detailTextLabel.textColor = RGB_COLOR(243, 96, 67);
            cell.accessoryType = UITableViewCellAccessoryNone;
            
            return cell;
//        }
    
        
//        static NSString *cellIndentifier = @"PRICECELL";
//        PriceCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
//        if (!cell) {
//            cell = [[PriceCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIndentifier];
//            cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        }
//        cell.textLabel.text = @"订单已提交 请完成付款";
//        cell.textLabel.font = FONT(16);
//        cell.detailTextLabel.text = [NSString stringWithFormat:@"￥%0.2f",self.totalPrice];
//        cell.accessoryType = UITableViewCellAccessoryNone;
//        
//        return cell;
        
        }else if (indexPath.section == 1){
        
            static NSString *cellIndentifier = @"PAYCELL";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIndentifier];
            }
            
//            [tableView setSeparatorColor:[UIColor colorWithRed:242.0/255.0f green:242.0/255.0f blue:242.0/255.0f alpha:1.0]];
            
            // Configure the cell...
            
            cell.imageView.image = nil;
            cell.detailTextLabel.text = nil;
            
            if (indexPath.row == 0) {
                cell.imageView.image = [UIImage imageNamed:@"wxpay"];
                cell.textLabel.text = @"微信支付";
                cell.textLabel.textColor = GRAY_COLOR;
//                cell.detailTextLabel.text = @"微信支付";
              
  
            }else if(indexPath.row == 1){
                cell.imageView.image = [UIImage imageNamed:@"alipay"];
                cell.textLabel.text = @"支付宝支付";
                cell.textLabel.textColor = GRAY_COLOR;
//                cell.detailTextLabel.text = @"支付宝支付";
            }else{
                cell.imageView.image = [UIImage imageNamed:@"wxpay"];
                cell.textLabel.text = @"余额支付";
                cell.textLabel.textColor = GRAY_COLOR;
//                cell.detailTextLabel.text = @"暂未开通";
            }
            
            cell.detailTextLabel.font = FONT(16);
            cell.detailTextLabel.textColor = BLACK_COLOR;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            
        
            return cell;
        }else{
            static NSString *cellIndentifier = @"CANCEl";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIndentifier];
            }
            [cell addSubview:self.cancelBtn];
            return cell;
        }
    

    }

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0) {
        return;
    }else{
        if (indexPath.row == 0){
            [self payWithWx];
        }else{
            [self payWithAli];
        }
    }
    
    
}


- (void)payWithAli
{
  
}


- (void)payWithWx
{
    

}

#pragma mark - Getter
- (UITableView *)listView
{
    if (!_listView) {
//        _listView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _listView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH,  SCREEN_HEIGHT-BOTTOM_HEIGHT-65) style:UITableViewStylePlain];
        _listView.dataSource = self;
        _listView.delegate = self;
        _listView.backgroundColor = WHITE_COLOR;//RGB_COLOR(242, 242, 242);
        _listView.tableFooterView = [UIView new];
        _listView.bounces = NO;
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

- (UIButton *)cancelBtn
{
if (!_cancelBtn) {
    _cancelBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    _cancelBtn.frame = CGRectMake(0, 8, SCREEN_WIDTH, 50);
    _cancelBtn.backgroundColor = WHITE_COLOR;
    [_cancelBtn setTitle:@"暂不支付" forState:UIControlStateNormal];
    [_cancelBtn setTitleColor:RGB_COLOR(17, 194, 88) forState:UIControlStateNormal];
    _cancelBtn.titleLabel.font = FONT(16);
    [_cancelBtn addTarget:self action:@selector(cancelPay:) forControlEvents:UIControlEventTouchUpInside];
    _cancelBtn.adjustsImageWhenHighlighted = YES;
    }

    return _cancelBtn;
}

- (void)cancelPay:(UIButton *)sender
{
//    [self.navigationController popToRootViewControllerAnimated:YES];
//    [self.tabBarController setSelectedIndex:0];
//    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:0] animated:YES];
//    [[AppDelegate tabbarController].navigationController popToViewControllerAnimated:YES];
//    UINavigationController * home =[self.tabBarController.viewControllers objectAtIndex:0];
//    DBLog(@"%@", home);
//    UIViewController *rvc = [home.viewControllers firstObject];
//    DBLog(@"%@", rvc);
////    [self.navigationController popToViewController:rvc animated:YES];
//    [home popToViewController:rvc animated:YES];
    [self.navigationController popToRootViewControllerAnimated:NO];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"JUMP" object:nil];
}

@end

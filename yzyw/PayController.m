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

#import "VegViewController.h"

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
        
        _oldcouponid = 0;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshAddress:) name:@"SENDADDRESS" object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(wxpayResult:) name:@"WXPAYRESULT" object:nil];
    }
    return self;
}

- (void)layoutNavigationBar
{
    self.title = @"收银台";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"nav_back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(clickLeftBarButton:)];
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
        return 2;
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
    
    if (indexPath.section==0){
        if (indexPath.row == 0) {
            static NSString *cellIndentifier = @"ORDERNUMCELL";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIndentifier];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            
            cell.textLabel.text = @"订单号";
            cell.textLabel.font = FONT(16);
            cell.detailTextLabel.text = @"201603211234567890";
            cell.accessoryType = UITableViewCellAccessoryNone;
            
            return cell;
        }
        else{
            static NSString *cellIndentifier = @"PAYPRICECELL";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIndentifier];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            
            cell.textLabel.text = @"支付金额";
            cell.textLabel.font = FONT(16);
            
            cell.detailTextLabel.text = @"¥28.5";
            cell.detailTextLabel.textColor = RGB_COLOR(243, 96, 67);
            cell.accessoryType = UITableViewCellAccessoryNone;
            
            return cell;
        }
        
        
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
    
    
//    if (indexPath.section == 0) {
//        
////        if (!_isFromOrder) {
////            
////            ManageAddressViewController *controller = [[ManageAddressViewController alloc] initWithFromType:2];
////            
////            [self.navigationController pushViewController:controller animated:YES];
////        }
//        return;
//        
//    }else{
//        if (indexPath.row == 0){
//            [self payWithWx];
//        }else{
//            [self payWithAli];
//        }
//
//    }
////           //            if (self.payType == 1) {
////                DBLog(@"单品类型红包");
////      
////                [self pushPacketWithType:@"2"];
////            }else{
////                [self pushPacketWithType:@"1"];
////            }
////            
////        }else if (indexPath.row == 2){
////            
////            [self payWithAli];
////        }else if (indexPath.row == 3){
////            [self payWithWx];
////        }
//    }
}


- (void)payWithAli
{
    //订单不能重复提交如何判断
    
    if (_isFromOrder) {
        
        if (self.order) {
            
            //已经有订单信息了
            
            if (self.oldcouponid == self.coupondata.cid) {
                //直接调用alipay
                [self Alipay];
            }else{
                
                [self reFetchOrderWithType:@"2"];
            }
            
        }else{
            
            [self reFetchOrderWithType:@"2"];
        }
        
    }else{
        
        if (self.order) {
            
            //已经有订单信息了
            
            if (self.oldcouponid == self.coupondata.cid) {
                //直接调用alipay
                [self Alipay];
            }else{
                
                //modify by jin 2015-10-16
                [self reFetchOrderWithType:@"2"];
            }
            
        }else{
            
            if (self.orderNo) {
                //有订单号了，直接来了
                [self reFetchOrderWithType:@"2"];
                
            }else{
                if (self.payType == 1) {
                    [self createTcOrderWithPaytype:@"2"];
                    
                }else if(self.payType == 3){
                    DBLog(@"这里是秒杀啊~~");
                    [self createMsOrderWithPaytype:@"2"];
                    
                    
                }else{
                    [self createOrderWithType:@"2"];
                }
            }
        }
    }

}


- (void)payWithWx
{
    
//    //订单不能重复提交如何判断
//    
//    if (_isFromOrder) {
//        
//        if (self.wxpayResponse) {
//            
//            //已经有订单信息了
//            
//            if (self.oldcouponid == self.coupondata.cid) {
//                //直接调用alipay
//                [self Wxpay];
//            }else{
//                
//                [self reFetchOrderWithType:@"3"];
//            }
//            
//        }else{
//            
//            [self reFetchOrderWithType:@"3"];
//        }
//        
//    }else{
//        
//        
//        if (self.wxpayResponse) {
//            
//            //已经有订单信息了
//            
//            if (self.oldcouponid == self.coupondata.cid) {
//                //直接调用alipay
//                [self Wxpay];
//            }else{
//                
//                //modify by jin 2015-10-16
//                
//                [self reFetchOrderWithType:@"3"];
//
//            }
//            
//        }else{
//            
//            if (self.orderNo) {
//                [self reFetchOrderWithType:@"3"];
//            }else{
//            
//                if (self.payType == 1) {
//                    [self createTcOrderWithPaytype:@"3"];
//                    
//                }else if(self.payType == 3){
//                    DBLog(@"这里是秒杀啊~~");
//                    [self createMsOrderWithPaytype:@"3"];
//                }else{
//                    [self createOrderWithType:@"3"];
//                }
//            }
//        }
//    }
    [self Wxpay];
}


- (void)pushPacketWithType:(NSString *)type
{
//    RedPacketViewController *controller = [[RedPacketViewController alloc] initWithType:type];
//    controller.delegate = self;
//    if (self.needFreight) {
//        controller.price = self.totalPrice-10;
//    }else{
//        controller.price = self.totalPrice;
//    }
//    [self.navigationController pushViewController:controller animated:YES];
//
}

#pragma mark - coupondata
- (void)sendCouponData:(CouponsData *)data
{
    self.coupondata = data;
    [self.listView reloadData];
}

#pragma mark - Alipay
- (void)Alipay
{
    NSString *appScheme = @"Garden";
    
    [[AlipaySDK defaultService] payOrder:_order[@"alipay"] fromScheme:appScheme callback:^(NSDictionary *resultDic) {
        
        if ([[resultDic valueForKey:@"resultStatus"] isEqualToString:@"9000"])
        {
            //刷新首页数据
            [[NSNotificationCenter defaultCenter] postNotificationName:@"REFRESHHOMEDATA" object:nil];
            
            //订单数据
            [[NSNotificationCenter defaultCenter] postNotificationName:@"REFRESHORDER" object:nil];
            
            //支付成功!
//            PayResultViewController *controller = [[PayResultViewController alloc]initWithFromType:1];
//            controller.orderNo = self.order[@"orderno"];
            
//            [self.navigationController pushViewController:controller animated:YES];
            
            
        }else if ([[resultDic valueForKey:@"resultStatus"] isEqualToString:@"6001"]){
            [self showErrorStatusWithTitle:@"您取消了支付!"];
        }else{
            [self showFailureStatusWithTitle:@"支付失败!"];
        }
    }];
    
}


- (void)Wxpay
{
    PayReq *request = [[PayReq alloc] init];
    request.partnerId = _wxpayResponse[@"wxpay"][@"partnerid"];
    request.prepayId =  _wxpayResponse[@"wxpay"][@"prepayid"];
    request.package = _wxpayResponse[@"wxpay"][@"package"];
    request.nonceStr = _wxpayResponse[@"wxpay"][@"noncestr"];
    request.timeStamp = [_wxpayResponse[@"wxpay"][@"timestamp"] doubleValue];
    request.sign = _wxpayResponse[@"wxpay"][@"sign"];
    [WXApi sendReq:request];
    
}

#pragma mark - Fetch Data
- (void)fetchAddress
{
    [self showLoading];
    
    [HTTPManager getUserV3AddressWithSuccess:^(id response) {
        
        [self hideLoading];
        
        UserAddress *addlist = [UserAddress objectWithKeyValues:response];
        
        if (addlist.errmsg != nil) {
            [self showErrorStatusWithTitle:addlist.errmsg];
        }else{
           
            if (addlist.addresses.count > 0) {
                
                for (NSInteger i = 0; i < addlist.addresses.count; i++) {
                    if ([(UserAddressInfo *)addlist.addresses[i] adefault] == 1) {
                        
                        self.address = addlist.addresses[i];
                        break;
                    }
                }
            }
            
        }

        
        
        [self setup];
        
        
        
    } failure:^(NSError *err) {
        [self hideLoading];
        [self setup];
    }];
}



- (void)fetchShareData
{
    
}




- (void)createOrderWithType:(NSString *)paytype
{
    if (!self.address) {
        [self showErrorStatusWithTitle:@"请选择收货地址"];
        return;
    }
    
    [self showLoading];
    
    NSMutableArray *tempArr = [NSMutableArray arrayWithCapacity:10];
    
    for (NSInteger i = 0 ; i < self.caiData.count; i++) {
        VGItemInfo *info = self.caiData[i][@"data"];
        NSNumber *count = self.caiData[i][@"count"];
        NSString *temp = [NSString stringWithFormat:@"%@:%@",@(info.vid),count];
        [tempArr addObject:temp];
    }
    
    NSMutableArray *tempbx = [NSMutableArray arrayWithCapacity:10];
    for (NSInteger i = 0; i < self.bxData.count; i++) {
        VGItemInfo *info = self.bxData[i];
        
        [tempbx addObject:@(info.vid)];
    }
    
    
    NSString *address ;
    
    if (_address.doneAddress) {
        address = _address.doneAddress;
    }else{
        address = [NSString stringWithFormat:@"%@%@%@",_address.city,_address.region,_address.address];
    }
    
    
    //有红包
    NSString *couponid ;
    if (self.coupondata) {
        couponid = STR(@(self.coupondata.cid));
    }
    
    self.oldcouponid = self.coupondata.cid;

    
    NSString *addon = nil;
    NSMutableArray *tempaddon = [NSMutableArray arrayWithCapacity:10];

    
    for (NSInteger i = 0; i < self.requiredData.count; i++) {
        
        ComboItemInfo *info = self.requiredData[i][@"data"];
        NSNumber *count = self.requiredData[i][@"count"];
        NSString *temp = [NSString stringWithFormat:@"%@:%@",@(info.itemid),count];
        [tempaddon addObject:temp];
    }
    
    if (tempaddon.count > 0) {
        addon = [tempaddon componentsJoinedByString:@","];
    }

    
    [HTTPManager createOrderWithComboId:self.comboid couponId:couponid type:STR(@(self.type)) comboIdx:self.comboIdx items:[tempArr componentsJoinedByString:@","] extras:nil spares:[tempbx componentsJoinedByString:@","] name:_address.name mobile:_address.mobile address:address memo:self.beizhu addon:addon paytype:paytype success:^(id response) {
        
        [self hideLoading];
        
        DBLog(@"resonse=%@",response);
        
        if (response[@"errmsg"] != nil) {
            
            AlertWithMessage(response[@"errmsg"]);
        }else{

            self.orderNo = [NSString stringWithFormat:@"%@",response[@"orderno"]];


            if ([paytype isEqualToString:@"2"]) {
                self.order = response;
                [self Alipay];
            }else{
                
                self.wxpayResponse = response;
                [self Wxpay];
            }

    
        }
        
    } failure:^(NSError *err) {
        DBLog(@"error=%@",err.localizedDescription);
        [self hideLoading];
    }];

}


- (void)createTcOrderWithPaytype:(NSString *)paytype
{
    if (!self.address) {
        [self showErrorStatusWithTitle:@"请选择收货地址"];
        return;
    }
    
    [self showLoading];
    
    
    NSMutableArray *tempArr = [NSMutableArray arrayWithCapacity:10];
    
    for (NSInteger i = 0 ; i < self.caiData.count; i++) {
        TCData *info = self.caiData[i][@"data"];
        NSNumber *count = self.caiData[i][@"count"];
        NSString *temp = [NSString stringWithFormat:@"%@:%@",@(info.tid),count];
        [tempArr addObject:temp];
    }

    
    
    NSString *address ;
    
    if (_address.doneAddress) {
        address = _address.doneAddress;
    }else{
        address = [NSString stringWithFormat:@"%@%@%@",_address.city,_address.region,_address.address];
    }
    
    
    //有红包
    NSString *couponid ;
    if (self.coupondata) {
        couponid = STR(@(self.coupondata.cid));
    }

    self.oldcouponid = self.coupondata.cid;

    
    [HTTPManager createOrderWithComboId:nil couponId:couponid type:@"3" comboIdx:nil items:nil extras:[tempArr componentsJoinedByString:@","] spares:nil name:_address.name mobile:_address.mobile address:address memo:self.beizhu addon:nil paytype:paytype success:^(id response) {
        
        [self hideLoading];
        
        DBLog(@"resonse=%@",response);
        
        if (response[@"errmsg"] != nil) {
            
            AlertWithMessage(response[@"errmsg"]);
        }else{
            
//            self.order = response;
            
            self.orderNo = [NSString stringWithFormat:@"%@",response[@"orderno"]];
            
            if ([paytype isEqualToString:@"2"]) {
                self.order = response;
                [self Alipay];
            }else{
                
                self.wxpayResponse = response;
                [self Wxpay];
            }
            
            //add  clear beizhu
            POSTNOTIFICATION(@"CLEARBEIZHU", nil);
            
            //清空数据库
            [[DBManager instance] clearAllItem];
            
        }
        
    } failure:^(NSError *err) {
        DBLog(@"error=%@",err.localizedDescription);
        [self hideLoading];
    }];
    

}


- (void)createMsOrderWithPaytype:(NSString *)paytype
{
    DBLog(@"开始创建秒杀Order");
    
    if (!self.address) {
        [self showErrorStatusWithTitle:@"请选择收货地址"];
        return;
    }
    
    [self showLoading];
    
    
    NSString *goodsid = STR(@(_msdata.tid));
    NSString *extras = [NSString stringWithFormat:@"%@:%@",goodsid,@"1"];

    
    
    NSString *address ;
    
    if (_address.doneAddress) {
        address = _address.doneAddress;
    }else{
        address = [NSString stringWithFormat:@"%@%@%@",_address.city,_address.region,_address.address];
    }
    
    
    
    [HTTPManager createOrderWithComboId:nil couponId:nil type:@"3" comboIdx:nil items:nil extras:extras spares:nil name:_address.name mobile:_address.mobile address:address memo:self.beizhu addon:nil paytype:paytype success:^(id response) {
        
        [self hideLoading];
        
        DBLog(@"resonse=%@",response);
        
        if (response[@"errmsg"] != nil) {
            
            AlertWithMessage(response[@"errmsg"]);
        }else{
            
            self.order = response;
            self.orderNo = [NSString stringWithFormat:@"%@",response[@"orderno"]];


            if ([paytype isEqualToString:@"2"]) {
                self.order = response;
                [self Alipay];
            }else{
                
                self.wxpayResponse = response;
                [self Wxpay];
            }

        }
        
    } failure:^(NSError *err) {
        DBLog(@"error=%@",err.localizedDescription);
        [self hideLoading];
    }];

    
}


- (void)reFetchOrderWithType:(NSString *)paytype
{
    [self showLoading];
    
    NSString *couponid ;
    if (self.coupondata) {
        couponid = STR(@(self.coupondata.cid));
    }
    
    self.oldcouponid = self.coupondata.cid;

    
    [HTTPManager payOrderWithOrderId:self.orderNo couponId:couponid paytype:paytype success:^(id response) {
        [self hideLoading];
        
        if (response[@"errmsg"] != nil) {
            
            AlertWithMessage(response[@"errmsg"]);
        }else{
            
            if ([paytype isEqualToString:@"2"]) {
                self.order = response;
                [self Alipay];
            }else{
                
                if (response[@"wxpay"]) {
                    self.wxpayResponse = response;

                    [self Wxpay];
                }else{
                    [self showFailureStatusWithTitle:@"价格变更，微信支付失败，请用支付宝"];
                    self.oldcouponid = 0;
                }
                
            }
            
        }

    } failure:^(NSError *err) {
        [self hideLoading];
    }];
}

#pragma mark - User Action
- (void)clickLeftBarButton:(id)sender
{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}


- (void)refreshAddress:(NSNotification *)noti
{
    UserAddressInfo *info = noti.userInfo[@"data"];
    
    self.address = info;
    [self.listView reloadData];
    
}


- (void)wxpayResult:(NSNotification *)noti
{
    NSString *resutl = noti.userInfo[@"data"];
    
    if ([resutl isEqualToString:@"0"]) {
        DBLog(@"支付成功");
        
        //刷新首页数据
        [[NSNotificationCenter defaultCenter] postNotificationName:@"REFRESHHOMEDATA" object:nil];
        
        //订单数据
        [[NSNotificationCenter defaultCenter] postNotificationName:@"REFRESHORDER" object:nil];
        
        //支付成功!
//        PayResultViewController *controller = [[PayResultViewController alloc]initWithFromType:1];
//        controller.orderNo = self.wxpayResponse[@"orderno"];
        
//        [self.navigationController pushViewController:controller animated:YES];
        

        
        
    }else if ([resutl isEqualToString:@"-2"]){
        DBLog(@"用户取消");
        [self showErrorStatusWithTitle:@"您取消了支付!"];

    }else{
        DBLog(@"支付失败~");
        [self showFailureStatusWithTitle:@"支付失败!"];

    }
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

//
//  ShoppingCarViewController.m
//  Garden
//
//  Created by nmg on 1/12/16.
//  Copyright (c) 2015 Nmg. All rights reserved.
//

#import "ShoppingCarViewController.h"
//#import "AddressCell.h"
#import "ShoppingCell.h"
//#import "RemarkViewController.h"

//change
//#import "RemarkViewController.h"
#import "LoginViewController.h"
#import "OrderEnsureViewController.h"
#import "VegDetailViewController.h"

#define CELL_HEIGHT   222/2.0
#define BOTTOM_HEIGHT 60
#define FREIGHT 10
#define PRICE_LIMIT 49

@interface ShoppingCarViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView *listView;
@property (nonatomic, strong) NSMutableArray *listData;
@property (nonatomic, strong) AddressInfo *address;

@property (nonatomic, strong) UILabel *headerLabel;

@property (nonatomic, strong) UIView *bottomToBorderView;
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, strong) UIButton *submitBtn;

@property (nonatomic, strong) NSString *markMessage;

//@property (nonatomic, strong) UIView *emptyView;
@property (nonatomic, strong) UIButton *loginBtn;

@property (nonatomic) UIEdgeInsets separatorInset NS_AVAILABLE_IOS(7_0) UI_APPEARANCE_SELECTOR;

@end

@implementation ShoppingCarViewController


- (instancetype)init
{
    if (self = [super init]) {
        [self layoutNavigationBar];
        _listData = [NSMutableArray arrayWithCapacity:10];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(clearBeiZhu:) name:@"CLEARBEIZHU" object:nil];
    }
    return self;
}

- (void)layoutNavigationBar
{
    self.title = @"购物车";
//       self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"咨询" style:UIBarButtonItemStylePlain target:self action:@selector(clickRightButton:)];
//    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:@{NSForegroundColorAttributeName:BLACK_COLOR,NSFontAttributeName:FONT(14)} forState:UIControlStateNormal];
}




- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view addSubview:self.listView];
    self.listView.tableHeaderView = self.headerLabel;
    [self.view addSubview:self.bottomToBorderView];
    [self.view addSubview:self.bottomView];
    [self.bottomView addSubview:self.priceLabel];
    [self.bottomView addSubview:self.submitBtn];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [_listData removeAllObjects];
    [_listData addObjectsFromArray:[[DBManager instance] getAllItems]];
    
//    DBLog(@"%@", _listData);
    
    if (_listData.count == 0){
        self.listView.hidden = YES;
        self.bottomView.hidden = YES;
        self.bottomToBorderView.hidden = YES;
        return;
    }
    
    self.listView.hidden = NO;
    self.bottomView.hidden = NO;
    
    [self changePriceStatus];
    [_listView reloadData];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    // Return the number of rows in the section.
    if(section == 0) {
        return _listData.count;
    }else if(section == 1) {
        return 0;
    }else{
        return 2;
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return CELL_HEIGHT;
    }
    return 40;
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 1 || section == 2 ) {
        return 5;
    }
    return 0;
}


- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0,0, SCREEN_WIDTH,5)];
    view.backgroundColor = RGB_COLOR(242, 242, 242);
    return view;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    
    // Configure the cell...
    if (indexPath.section == 0){
    
        static NSString *cellIndentifier = @"SHOPCell";
        ShoppingCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
        if (!cell) {
            cell = [[ShoppingCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell.addBtn addTarget:self action:@selector(addtcGoods:) forControlEvents:UIControlEventTouchUpInside];
            [cell.subBtn addTarget:self action:@selector(subtcGoods:) forControlEvents:UIControlEventTouchUpInside];

        }
        
        [tableView setSeparatorColor:[UIColor colorWithRed:242.0/255.0f green:242.0/255.0f blue:242.0/255.0f alpha:1.0]];
        
        [cell configCellData:_listData[indexPath.row]];
        
            
        if ([tableView respondsToSelector:@selector(setSeparatorInset:)]) {
            [tableView setSeparatorInset:UIEdgeInsetsZero];
        }
            
        if ([tableView respondsToSelector:@selector(setLayoutMargins:)]) {
            [tableView setLayoutMargins:UIEdgeInsetsZero];
        }
            
        if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
            [cell setLayoutMargins:UIEdgeInsetsZero];
        }
        
        return cell;


    }else if (indexPath.section == 1){
        static NSString *CellIdentifier = @"TIMECELL";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        
        cell.textLabel.text = nil;
        cell.detailTextLabel.text = nil;
        //cell.textLabel.text = [NSString stringWithFormat:@"配送日期：每周五配送"];
//        cell.detailTextLabel.text = [NSString stringWithFormat:@"共%@份",@([self allGoodsCount])];
        cell.textLabel.font = FONT(12);
        cell.detailTextLabel.font = FONT(12);
        cell.textLabel.textColor = RGB_COLOR(68, 68, 68);
        cell.detailTextLabel.textColor = RGB_COLOR(68, 68, 68);
        
        return cell;

    }else {
        static NSString *CellIdentifier = @"BEIZHUCELL";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        cell.textLabel.text = nil;
        cell.detailTextLabel.text = nil;

        cell.textLabel.font = FONT(14);
        cell.detailTextLabel.font = FONT(14);
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

        
        if (indexPath.row == 0) {
            cell.textLabel.text = @"备注";
            
            if (self.markMessage) {
                cell.detailTextLabel.text = self.markMessage;
                cell.detailTextLabel.textColor = BLACK_COLOR;
            }else{
                cell.detailTextLabel.text = @"添加备注";//[NSString stringWithFormat:@"共%@份",@(_allCount)];
                cell.detailTextLabel.textColor = RGB_COLOR(153, 153, 153);
            }

        }else{
            cell.textLabel.text = @"运费";
            cell.textLabel.font = FONT(14);
            
            
            if ([self allPrice] >= 5) {
                
                NSString *text = [NSString stringWithFormat:@"0元(订单满49元免运费)"];

                cell.detailTextLabel.attributedText = [text ew_focusSubstring:@"0" color:RGB_COLOR(243,96,67) font:FONT(14)];
                
                
            }else{
                NSString *text = [NSString stringWithFormat:@"5元(订单满49元免运费)"];
                cell.detailTextLabel.attributedText = [text ew_focusSubstring:@"5元" color:RGB_COLOR(243,96,67) font:FONT(14)];
            }
            
        }
        

        return cell;

    }
    
}

//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    
//    if (indexPath.section == 0) {
//        
//        VegDetailViewController *controller = [[VegDetailViewController alloc] initWithTCData:nil];
//        controller.isNeedBottomBar = NO;
//        controller.cid = STR(@([(TCData *)_listData[indexPath.row][@"data"] tid]));
//        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:controller];
//        [self presentViewController:nav animated:YES completion:nil];
//        
//    }else if (indexPath.section == 2 && indexPath.row == 0) {
//        RemarkViewController *controller = [RemarkViewController new];
//        controller.delegate = self;
//        controller.hidesBottomBarWhenPushed = YES;
//        [self.navigationController pushViewController:controller animated:YES];
//    }
//}


- (void)sendMessage:(NSString *)message
{
    //增加留言备注
    self.markMessage = message;
    
    [self.listView reloadSections:[NSIndexSet indexSetWithIndex:2] withRowAnimation:UITableViewRowAnimationNone];
    
}



#pragma mark - User Action
- (void)addtcGoods:(UIButton *)sender
{
    UITableViewCell *cell = nil;
    if ([sender.superview isKindOfClass:[UITableViewCell class]]) {
        cell = (UITableViewCell *)sender.superview;
    }else{
        cell = (UITableViewCell *)sender.superview.superview;
    }
    
    NSIndexPath *indexPath = [self.listView indexPathForCell:cell];
    NSMutableDictionary *data = _listData[indexPath.row];

    if (indexPath) {
        
        NSInteger count = [data[@"count"] integerValue];

        //add goods
        [data setObject:@(count+1) forKey:@"count"];
        //update db
        [[DBManager instance] updateItem:data count:[data[@"count"] integerValue ]];
        //reload section
        //[self.listView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
        
        [self changePriceStatus];
        [self.listView reloadData];

    }
    
    
    

}

- (void)subtcGoods:(UIButton *)sender
{
    UITableViewCell *cell = nil;
    if ([sender.superview isKindOfClass:[UITableViewCell class]]) {
        cell = (UITableViewCell *)sender.superview;
    }else{
        cell = (UITableViewCell *)sender.superview.superview;
    }
    
    NSIndexPath *indexPath = [self.listView indexPathForCell:cell];

    NSMutableDictionary *data = _listData[indexPath.row];
    
    if (indexPath) {
        NSInteger count = [data[@"count"] integerValue] - 1;
        if (count == 0) {
            [[DBManager instance] deleteItem:data];
            [self.listData removeObjectAtIndex:indexPath.row];
        }
        else{
            [data setObject:@(count) forKey:@"count"];
            [[DBManager instance] updateItem:data count:[data[@"count"] integerValue ]];
        }
        [self changePriceStatus];
        [self.listView reloadData];
//        
//        if ([data[@"count"] integerValue] -1 == 0) {
//            
//            //clear db
//            [[DBManager instance] deleteItem:data];
//            //delete datasource
//            [self.listData removeObjectAtIndex:indexPath.row];
//            //reload section
//            //[self.listView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
//            [self changePriceStatus];
//            [self.listView reloadData];
//
//        }else{
//        
//            //count -1
//            NSInteger preCount = [data[@"count"] integerValue];
//            [data setObject:@(preCount-1) forKey:@"count"];
//            
//            //update db count
//            [[DBManager instance] updateItem:data count:[data[@"count"] integerValue ]];
//            //reload section
//            //[self.listView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
//            [self changePriceStatus];
//            [self.listView reloadData];
//        }
//        
        if (self.listData.count == 0) {
            self.listView.hidden = YES;
            self.bottomView.hidden = YES;
            self.bottomToBorderView.hidden = YES;
            [[DBManager instance] clearAllItem];
            return;
        }
        
        //都删除要更新页面
//        if (self.listData.count == 0) {
//            
//            [self showEmptyCar];
//        }
        
    }

}


- (void)clickRightButton:(id)sender
{
    [EWUtils ew_callNumber:@"010-67789567"];
}



- (void)checkout:(UIButton *)sender
{
//    if ([VGUtils userHasLogin]) {
//        OrderEnsureViewController *controller = [[OrderEnsureViewController alloc] init];
//        controller.totalPrice = [self allPrice] >= PRICE_LIMIT ?[self allPrice]:[self allPrice] +FREIGHT;
//        if ([self allPrice] >= PRICE_LIMIT) {
//            controller.freight = 0;
//        }else{
//            controller.freight = FREIGHT;
//        }
//        controller.hidesBottomBarWhenPushed = YES;
//        [self.navigationController pushViewController:controller animated:YES];
//    }else{
//        [self showErrorStatusWithTitle:@"登录后才能结算"];
//    }
    OrderEnsureViewController *controller = [[OrderEnsureViewController alloc] init];
    controller.totalPrice = [self allPrice] >= PRICE_LIMIT ?[self allPrice]:[self allPrice] + FREIGHT;
    if ([self allPrice] >= PRICE_LIMIT) {
        controller.freight = 0;
    }else{
        controller.freight = FREIGHT;
    }
    controller.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)login:(UIButton *)sender
{
    UINavigationController *navLogin = [[UINavigationController alloc] initWithRootViewController:[LoginViewController new]];
    [self presentViewController:navLogin animated:YES completion:nil];

}

- (void)clearBeiZhu:(NSNotification *)noti
{
    self.markMessage = nil;
}

#pragma mark - Getter
- (UITableView *)listView
{
    if (!_listView) {
        _listView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-49-BOTTOM_HEIGHT-64) style:UITableViewStylePlain];
        _listView.dataSource = self;
        _listView.delegate = self;
        _listView.backgroundColor = TABLE_COLOR;
        _listView.tableFooterView = [UIView new];
        _listView.showsHorizontalScrollIndicator = NO;
        _listView.showsVerticalScrollIndicator = NO;
        
    }
    return _listView;
}

- (UILabel *)headerLabel
{
    if (!_headerLabel) {
        _headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 30)];
        _headerLabel.backgroundColor = RGB_COLOR(50, 190, 112);
        _headerLabel.text = @"  订单满49元免运费，不满49元加10元运费";
        _headerLabel.font = FONT(12);
        _headerLabel.textColor = WHITE_COLOR;
    }
    return _headerLabel;
}


- (UIView *)bottomView
{
    if (!_bottomView) {
        _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, _bottomToBorderView.bottom, SCREEN_WIDTH, BOTTOM_HEIGHT)];
    }
    return _bottomView;
}

- (UIView *)bottomToBorderView
{
    if (!_bottomToBorderView) {
        _bottomToBorderView = [[UIView alloc] initWithFrame:CGRectMake(0, _listView.bottom, SCREEN_WIDTH, 1)];
        _bottomToBorderView.backgroundColor = RGB_COLOR(242, 242, 242);
    }
    return _bottomToBorderView;
}


- (UILabel *)priceLabel
{
    if (!_priceLabel) {
        _priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, (self.bottomView.height-30)/2.0, 200, 30)];
        _priceLabel.textColor = RED_COLOR;
        _priceLabel.font = FONT(16);
        _priceLabel.text = [NSString stringWithFormat:@"共:%0.2f元",[self allPrice]];
    }
    return _priceLabel;
}


- (UIButton *)submitBtn
{
    if (!_submitBtn) {
        _submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _submitBtn.backgroundColor = RGB_COLOR(243, 96, 67);//  RGB_COLOR(0, 196, 83);
        _submitBtn.frame = CGRectMake(SCREEN_WIDTH-110, 10 , 100,40);
        [_submitBtn setTitleColor:WHITE_COLOR forState:UIControlStateNormal];
        [_submitBtn setTitle:@"立即结算" forState:UIControlStateNormal];
        _submitBtn.titleLabel.font = FONT(16);
        _submitBtn.layer.cornerRadius = 3;
        [_submitBtn addTarget:self action:@selector(checkout:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _submitBtn;
}



- (void)showNotLoginPage
{
}


/**
 *  cal
 */

- (NSInteger)allGoodsCount
{
    NSInteger count = 0;
    
    for (NSInteger i = 0; i < _listData.count; i++) {
        
        count += [_listData[i][@"count"] integerValue];
    }
    return count;
}

- (float)allPrice
{
    float price = 0.0;
    
    for (NSInteger i =0; i < _listData.count; i++) {
        price += [_listData[i][@"price"] floatValue] * [_listData[i][@"count"] integerValue];
    }

    return price;
}

- (void)changePriceStatus
{
    
    
//    if ([self allPrice] >= 5) {
//        
//        _priceLabel.text = [NSString stringWithFormat:@"商品价格:%0.2f元",[self allPrice]];
//        
//    }else{
//        _priceLabel.text = [NSString stringWithFormat:@"商品价格:%0.2f元(5元运费)",[self allPrice]+5];
//    }
    
    _priceLabel.text = [NSString stringWithFormat:@"商品价格:%0.2f元",[self allPrice]];
}


@end

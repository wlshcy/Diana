//
//  UserViewController.m
//  Garden
//
//  Created by nmg on 1/11/16.
//  Copyright (c) 2015 nmg. All rights reserved.
//

#import "UserViewController.h"
#import "UserHeader.h"
//#import "OrderListViewController.h"
#define CELL_HEIGHT 60
#define HEADER_HEIGHT  350/2.0  //(350+222+30)/2.0

//change
#import "LoginViewController.h"

//#import "SettingViewController.h"
//#import "RedPacketViewController.h"
//#import "DelayViewController.h"
//#import "ManageAddressViewController.h"
//#import "ModifyPasswdViewController.h"
#import "OrderListViewController.h"
#import "AddressListViewController.h"

//test
//#import "PayResultViewController.h"


@interface UserViewController ()<UITableViewDataSource,UITableViewDelegate,UserHeaderDelegate>
@property (nonatomic, strong) UITableView *listView;
@property (nonatomic, strong) NSArray *listData;
@property (nonatomic, strong) UserHeader *header;
@property (nonatomic, strong) NSString *delaydate;
@property (nonatomic, assign) BOOL enable;
@property (nonatomic, strong) NSArray *imageArray;

@property (nonatomic, strong) UILabel *tipsLabel;
@property (nonatomic) UIEdgeInsets separatorInset NS_AVAILABLE_IOS(7_0) UI_APPEARANCE_SELECTOR;
@end


@implementation UserViewController

- (instancetype)init
{
    if (self = [super init]) {
        [self layoutNavigationBar];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadUserData:) name:@"REFRESHUSERPAGE" object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushOrder) name:@"PUSHTOORDERLIST" object:nil];
    }
    return self;
}

- (void)layoutNavigationBar
{
    self.title = @"我的";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [self setup];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
     _listData = @[@"我的订单",@"地址管理",@"联系客服"];
    [self.listView reloadData];
    
}

- (void)setup
{
    [self.view addSubview:self.listView];
    self.listView.tableHeaderView = self.header;
    
    [self.header configUserHeader:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - TableViewDelegate & Datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    // Return the number of rows in the section.
    return _listData.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return CELL_HEIGHT;
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
    static NSString *cellIndentifier = @"CELL";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIndentifier];
    }
    
    // Configure the cell...

    cell.textLabel.text = _listData[indexPath.row];
    cell.textLabel.font = FONT(16);
    
    [tableView setSeparatorColor:[UIColor colorWithRed:242.0/255.0f green:242.0/255.0f blue:242.0/255.0f alpha:1.0]];
    
    if ([tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }

    
    if (indexPath.row == 2) {
        cell.detailTextLabel.text = @"0936-4315087";
        cell.detailTextLabel.font = FONT(16);
        cell.detailTextLabel.textColor = LIGHTGRAY_COLOR;
    }

    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//    UIImageView *imageview = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 22, 22)];
//    imageview.image = [UIImage imageNamed:@"user_arrow.png"];
//    cell.accessoryView = imageview;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.row) {
        case 0:
        {
            if ([VGUtils userHasLogin]) {
                OrderListViewController *controller = [OrderListViewController new];
                controller.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:controller animated:YES];
            }else{
                [self showErrorStatusWithTitle:@"用户未登录"];
                OrderListViewController *controller = [OrderListViewController new];
                controller.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:controller animated:YES];
            }
//            OrderListViewController *controller = [[OrderListViewController alloc] init];
//            controller.hidesBottomBarWhenPushed = YES;
//             [self.navigationController pushViewController:controller animated:YES];
            
        }
            break;
        
        case 1:
        {

//            if ([VGUtils userHasLogin]){
//                ManageAddressViewController *controller = [[ManageAddressViewController alloc] initWithFromType:1];
                AddressListViewController *controller = [[AddressListViewController alloc] initWithFlag:2];
                controller.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:controller animated:YES];
//            }else{
//                [self showErrorStatusWithTitle:@"用户未登录"];
//            }
            
        }
            break;
        
        case 3:
        {
            [EWUtils ew_callNumber:@"010-67789567"];
            
        }
            break;
        default:
            break;
}
}

- (void)didTapUserHeader
{
    if ([VGUtils userHasLogin]) {
        
//        ModifyPasswdViewController *controller = [[ModifyPasswdViewController alloc]init];
//        controller.hidesBottomBarWhenPushed = YES;
//        [self.navigationController pushViewController:controller animated:YES];
        
        [EWUtils setObject:@"1" key:@"MODIFYPWD"];
        self.tipsLabel.hidden = YES;

        
    }else{
    
        [self login];
    }
}

- (void)reloadUserData:(NSNotification *)noti
{
    [self.header configUserHeader:nil];
    if ([VGUtils userHasLogin] && [[EWUtils getObjectForKey:@"haspwd"]boolValue] == NO &&[[EWUtils getObjectForKey:@"MODIFYPWD"] boolValue] == NO) {
        [self.view addSubview:self.tipsLabel];
    }

}


- (void)login
{
//    UINavigationController *navLogin = [[UINavigationController alloc] initWithRootViewController:[LoginViewController new]];
//    [self presentViewController:navLogin animated:YES completion:nil];
    DBLog(@"go to wx");
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
   // [delegate loginWithWX:self];
}


- (void)pushOrder
{
//    OrderListViewController *controller = [OrderListViewController new];
//    controller.hidesBottomBarWhenPushed = YES;
//    controller.right = YES;
//    [self.navigationController pushViewController:controller animated:NO];

    
}

- (void)goModifyPwd:(UITapGestureRecognizer *)tap
{
    [EWUtils setObject:@"1" key:@"MODIFYPWD"];
    self.tipsLabel.hidden = YES;
    
//    ModifyPasswdViewController *controller = [[ModifyPasswdViewController alloc]init];
//    controller.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:controller animated:YES];

}

#pragma mark - Getter
- (UITableView *)listView
{
    if (!_listView) {
        _listView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-49) style:UITableViewStyleGrouped];
        _listView.dataSource = self;
        _listView.delegate = self;
        _listView.backgroundColor = RGB_COLOR(242, 242, 242);
        _listView.tableFooterView = [UIView new];
//        _listView.bounces = NO;
        _listView.showsHorizontalScrollIndicator = NO;
        _listView.showsVerticalScrollIndicator = NO;
    }
    return _listView;
}


- (UserHeader *)header
{
    if (!_header) {
        _header = [[UserHeader alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, HEADER_HEIGHT)];
        _header.delegate = self;
    }
    return _header;
}

- (UILabel *)tipsLabel
{
    if (!_tipsLabel) {
        _tipsLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.listView.bottom-35, SCREEN_WIDTH, 35)];
        _tipsLabel.backgroundColor = RGB_COLOR(220,238,225);
        _tipsLabel.textColor = RGB_COLOR(71, 67, 35);
        _tipsLabel.font = FONT(13);
        _tipsLabel.textAlignment = NSTextAlignmentCenter;
        _tipsLabel.text = @"为保证您的账户安全请设置密码，只需10秒!";
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goModifyPwd:)];
        _tipsLabel.userInteractionEnabled = YES;
        [_tipsLabel addGestureRecognizer:tap];
        tap = nil;
    }
    return _tipsLabel;
}

#pragma mark - ios 7
- (UIRectEdge)edgesForExtendedLayout
{
    return UIRectEdgeAll;
}

- (BOOL)automaticallyAdjustsScrollViewInsets
{
    return NO;
}

@end

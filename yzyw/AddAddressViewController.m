//
//  AddAddressViewController.m
//  Lynp
//
//  Created by nmg on 16/1/5.
//  Copyright (c) 2016 nmg. All rights reserved.
//

#import "AddAddressViewController.h"
#import "TPKeyboardAvoidingTableView.h"
#import "AddAddressCell.h"

//change
//#import "SearchViewController.h"
//#import "CityListViewController.h"
#import "ZoneListViewController.h"

//#import "SlidingViewManager.h"
//#import "UIViewController+MJPopupViewController.h"

//#import "UIViewController+KNSemiModal.h"

@interface AddAddressViewController ()<UITableViewDataSource,UITableViewDelegate,PassingValueDelegate>
@property (nonatomic ,strong) TPKeyboardAvoidingTableView *listView;
@property (nonatomic, strong) UserAddressInfo *address;
@property (nonatomic, assign) NSInteger zid;

//2.2.0
@property (nonatomic, strong) UIView *footerView;
@property (nonatomic, strong) UIButton *saveBtn;

@end

@implementation AddAddressViewController


//- (instancetype)initWithAddressInfo:(UserAddressInfo *)info

- (instancetype) init
{
    if (self = [super init]) {
        [self layoutNavigationBar];
//        
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(freshZoneInfo:) name:@"ADDUSERZONEINFO" object:nil];

    }
    return self;
}

- (void)layoutNavigationBar
{
    self.title = @"添加地址";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"nav_back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(clickLeftBarButton:)];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor  = RGB_COLOR(236, 236, 236);
    [self.view addSubview:self.listView];
    self.listView.tableFooterView = self.footerView;
    [self.footerView addSubview:self.saveBtn];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewController:(ZoneListViewController *)viewController didPassingValueWithInfo:(id)info{
    UITableViewCell * cell = [self.listView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
    UITextField * textField = [(AddAddressCell *)cell textField];
    textField.text = info;
}

#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    // Return the number of rows in the section.
    return 2;
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

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}


//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
//{
//    if (section == 0) {
//        return @"联系人";
//    }else{
//        return @"收货地址";
//    }
//}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 47;
}

//- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
//{
//    
//        if([view isKindOfClass:[UITableViewHeaderFooterView class]]){
//            UITableViewHeaderFooterView *tableViewHeaderFooterView = (UITableViewHeaderFooterView *) view;
//            [tableViewHeaderFooterView.textLabel setFont:[UIFont systemFontOfSize:14]];
//        }
//    
//    
//}

//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
//    
//    UILabel *myLabel = [[UILabel alloc] init];
//    myLabel.frame = CGRectMake(15, 0, 320, 33);
//    myLabel.font = [UIFont boldSystemFontOfSize:16];
//    myLabel.textColor = [UIColor grayColor];
//    myLabel.text = [self tableView:tableView titleForHeaderInSection:section];
//    
//    UIView *headerView = [[UIView alloc] init];
//    [headerView addSubview:myLabel];
//    
//    return headerView;
//}




- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIndentifier = @"Cell";
    AddAddressCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
    if (!cell) {
        cell = [[AddAddressCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier];
    }
    
    // Configure the cell...
    
    [cell configCell:indexPath];
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 1 && indexPath.row == 0) {
        
        ZoneListViewController *search = [[ZoneListViewController alloc] init];
        search.delegate = self;
        [self.navigationController pushViewController:search animated:YES];
    }
}



#pragma mark - UserAction
- (void)clickLeftBarButton:(UIBarButtonItem *)sender
{

//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"确定放弃此次编辑?" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
//    
//    [alert showAlertWithBlock:^(NSInteger buttonIndex) {
//        
//        if (buttonIndex == 1) {
//            [self.navigationController popViewControllerAnimated:YES];
//        }
//        
//    }];
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)saveAddress:(UIButton *)sender
{
    
    NSString *name = [[(AddAddressCell *)[self.listView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]] textField] text];
    
    NSString *phone = [[(AddAddressCell *)[self.listView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]] textField] text];
    
    NSString *zone = [[(AddAddressCell *)[self.listView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]] textField] text];
    
    NSString *detail = [[(AddAddressCell *)[self.listView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:1]] textField] text];
    
    
    if (name.length >0  && phone.length > 0 && zone.length >0 && detail.length >0) {
        if (![phone ew_checkPhoneNumber]) {
            [self showErrorStatusWithTitle:@"请输入正确的手机号"];
            return;
        }
            
        [self showLoading];
            
            
        [HTTPManager addAddress:name mobile:phone region:zone address:detail success:^(id response) {
            
        [self.navigationController popViewControllerAnimated:YES];
        [self hideLoading];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ADDUSERADDRESS" object:nil userInfo:nil];
        } failure:^(NSError *err) {
                [self hideLoading];
                [self showFailureStatusWithTitle:@"添加失败"];

            }];
            
        }else{
            [self showErrorStatusWithTitle:@"请填写完整的地址信息"];
            return;
        }
}

#pragma mark - Getter
- (TPKeyboardAvoidingTableView *)listView
{
    if (!_listView) {
        _listView = [[TPKeyboardAvoidingTableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
        _listView.delegate = self;
        _listView.dataSource = self;
        _listView.tableFooterView = [UIView new];
        _listView.backgroundColor = CLEAR_COLOR;
        _listView.showsHorizontalScrollIndicator = NO;
        _listView.showsVerticalScrollIndicator = NO;
    }
    
    return _listView;
}


- (UIView *)footerView
{
    if (!_footerView) {
        _footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 30+47)];
        _footerView.backgroundColor = CLEAR_COLOR;
    }
    return _footerView;
}

- (UIButton *)saveBtn
{
    if (!_saveBtn) {
        _saveBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        _saveBtn.frame = CGRectMake(0, 15, SCREEN_WIDTH, 60);
        _saveBtn.backgroundColor = WHITE_COLOR;
        [_saveBtn setTitle:@"保存地址" forState:UIControlStateNormal];
        [_saveBtn setTitleColor:RGB_COLOR(17, 194, 88) forState:UIControlStateNormal];
        _saveBtn.titleLabel.font = FONT(16);
        [_saveBtn addTarget:self action:@selector(saveAddress:) forControlEvents:UIControlEventTouchUpInside];
        _saveBtn.adjustsImageWhenHighlighted = YES;
    }
    return _saveBtn;
}

@end

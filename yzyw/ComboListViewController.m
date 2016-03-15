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

#define CELL_HEIGHT  120

@interface  ComboListViewController()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) UITableView *listView;
@property (nonatomic, strong) NSMutableArray *listData;
@end

@implementation ComboListViewController

- (instancetype)init
{
    if (self = [super init]) {
        [self layoutNavigationBar];
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
    
    [self setup];
    
//    [self fetchComboData:@"0"];
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

- (void)setup
{
    self.view.backgroundColor = WHITE_COLOR;
    [self.view addSubview:self.listView];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    // Return the number of rows in the section.
//    if (section == 0) {
//        return 1;
//    }
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return CELL_HEIGHT;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
//    if (indexPath.section == 0) {
//        
//        static NSString *cellIndentifier = @"USERCOMBOCELL";
//        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
////        if (!cell) {
////            cell = [[ProductUserCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier];
////            cell.selectionStyle = UITableViewCellSeparatorStyleNone;
////        }
////        
////        [cell configProductUserCell:_listUserData[indexPath.row]];
//        
//        return cell;
//        
//    }else{
    
        static NSString *cellIndentifier = @"COMBOLISTCELL";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier];
            cell.selectionStyle = UITableViewCellSeparatorStyleNone;
        }
//
//        [cell configProductCell:_listData[indexPath.row]];
//        [cell configProductCell];
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        nameLabel.font = FONT(16);
        nameLabel.backgroundColor = CLEAR_COLOR;
        nameLabel.textColor = BLACK_COLOR;
        nameLabel.text = @"幸福家庭月套餐";
        nameLabel.textAlignment = NSTextAlignmentCenter;
        nameLabel.frame = CGRectMake(0, 20, SCREEN_WIDTH, 15);
        [cell addSubview:nameLabel];
    
        UILabel *sendTime = [[UILabel alloc] initWithFrame:CGRectZero];
        sendTime.font = FONT(14);
        sendTime.backgroundColor = CLEAR_COLOR;
        sendTime.textColor = GRAY_COLOR;
        sendTime.text = @"一周配送两次";
        sendTime.textAlignment = NSTextAlignmentCenter;
        sendTime.frame = CGRectMake(0, nameLabel.bottom+10, SCREEN_WIDTH, 15);
        [cell addSubview:sendTime];
    
        UILabel *people = [[UILabel alloc] initWithFrame:CGRectZero];
        people.font = FONT(14);
        people.backgroundColor = CLEAR_COLOR;
        people.textColor = GRAY_COLOR;
        people.text = @"2人～5人";
        people.textAlignment = NSTextAlignmentCenter;
        people.frame = CGRectMake(0, sendTime.bottom+10, SCREEN_WIDTH, 15);
        [cell addSubview:people];
    
        UILabel *priceLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        priceLabel.font = FONT(15);
        priceLabel.backgroundColor = CLEAR_COLOR;
        priceLabel.textColor = RGB_COLOR(50,189, 111);
        priceLabel.text = @"¥240～¥580";
        priceLabel.textAlignment = NSTextAlignmentCenter;
        priceLabel.frame = CGRectMake(0, people.bottom+10, SCREEN_WIDTH, 15);
        [cell addSubview:priceLabel];
    
        return cell;
//    }
}

- (UITableView *)listView
{
    if (!_listView) {
        _listView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64) style:UITableViewStylePlain];
        _listView.dataSource = self;
        _listView.delegate = self;
        _listView.backgroundColor = TABLE_COLOR;
        _listView.tableFooterView = [UIView new];
        _listView.showsHorizontalScrollIndicator = NO;
        _listView.showsVerticalScrollIndicator = NO;
        _listView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _listView;
}

@end
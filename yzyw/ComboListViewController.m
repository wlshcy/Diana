//
//  ComboListViewController.m
//  yzyw
//
//  Created by nmg on 16/3/14.
//  Copyright © 2016年 nmg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ComboListViewController.h"

#define CELL_HEIGHT  130

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
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"nav_back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(clickLeftBarButton:)];
}

- (void)clickLeftBarButton:(UIBarButtonItem *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
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
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    // Return the number of rows in the section.
    if (section == 0) {
        return 1;
    }
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return CELL_HEIGHT+10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        
        static NSString *cellIndentifier = @"USERCOMBOCELL";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
//        if (!cell) {
//            cell = [[ProductUserCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier];
//            cell.selectionStyle = UITableViewCellSeparatorStyleNone;
//        }
//        
//        [cell configProductUserCell:_listUserData[indexPath.row]];
        
        return cell;
        
    }else{
        
        static NSString *cellIndentifier = @"COMBOLISTCELL";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier];
            cell.selectionStyle = UITableViewCellSeparatorStyleNone;
        }
//
//        [cell configProductCell:_listData[indexPath.row]];
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        nameLabel.font = FONT(15);
        nameLabel.backgroundColor = CLEAR_COLOR;
        nameLabel.textColor = BLACK_COLOR;
        nameLabel.text = @"幸福家庭周套餐";
        nameLabel.frame = CGRectMake(10, 20, 150, 15);
        [cell addSubview:nameLabel];
        return cell;
    }
}

@end
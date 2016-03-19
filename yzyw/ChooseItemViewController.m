//
//  ChooseItemViewController.m
//  yzyw
//
//  Created by nmg on 16/3/19.
//  Copyright © 2016年 nmg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ChooseItemViewController.h"

@interface ChooseItemViewController()<UITableViewDataSource,UITableViewDelegate,UIPageViewControllerDelegate>
@end

@implementation ChooseItemViewController

- (instancetype)init
{
    if (self = [super init]) {
        [self layoutNavigationBar];
    }
    return self;
}

- (void)layoutNavigationBar
{
    self.title = @"套餐固定菜品选择";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"nav_back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(clickLeftBarButton:)];
}

- (void)clickLeftBarButton:(UIBarButtonItem *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"addressCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    
    return cell;
}


@end
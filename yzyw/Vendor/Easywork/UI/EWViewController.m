//
//  EWViewController.m
//  Garden
//
//  Created by 金学利 on 8/5/15.
//  Copyright (c) 2015 Kingxl. All rights reserved.
//

#import "EWViewController.h"
//#import <MobClick.h>

@interface EWViewController ()
@property (nonatomic, strong) MBProgressHUD *HUD;
@end

@implementation EWViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    [MobClick beginLogPageView:[NSString stringWithFormat:@"%@",self]];

}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
//    [MobClick endLogPageView:[NSString stringWithFormat:@"%@",self]];
    
}


#pragma mark - Loading
- (void)showLoading
{
    _HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:_HUD];
    _HUD.removeFromSuperViewOnHide = YES;
    [_HUD show:YES];
}
- (void)showLoadingWithTitle:(NSString *)title
{
    _HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:_HUD];
    _HUD.removeFromSuperViewOnHide = YES;
    _HUD.labelText = title;
    [_HUD show:YES];

}

- (void)hideLoading
{
    [MBProgressHUD hideAllHUDsForView:self.navigationController.view animated:YES];
}

- (void)showSuccessStatusWithTitle:(NSString *)title
{
    [self showLoadingWithTitle:title type:1];
}

- (void)showErrorStatusWithTitle:(NSString *)title
{
    [self showLoadingWithTitle:title type:2];
}

- (void)showFailureStatusWithTitle:(NSString *)title
{
    [self showLoadingWithTitle:title type:3];
}

- (void)showLoadingWithTitle:(NSString *)title type:(NSInteger)type
{
    UIImage *image;
    switch (type) {
        case 1:
            image = [UIImage imageNamed:@"status_success"];
            break;
        case 2:
            image = [UIImage imageNamed:@"status_error"];
            break;
        case 3:
            image = [UIImage imageNamed:@"status_failure"];
            break;
    }
    
    _HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:_HUD];
//    _HUD.customView = [[UIImageView alloc] initWithImage:image];
    _HUD.mode = MBProgressHUDModeCustomView;
    _HUD.removeFromSuperViewOnHide = YES;
    _HUD.labelText = title;
    [_HUD show:YES];
    [_HUD hide:YES afterDelay:1.0];

}



#pragma mark - Getter


#pragma mark - IOS7
- (UIRectEdge)edgesForExtendedLayout
{
    return UIRectEdgeNone;
}

- (BOOL)automaticallyAdjustsScrollViewInsets
{
    return NO;
}

@end

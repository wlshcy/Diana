//
//  AppDelegate.m
//  Lynp
//
//  Created by nmg on 16/2/2.
//  Copyright (c) 2016 nmg. All rights reserved.
//

#import "AppDelegate.h"
#import "RDVTabBarController.h"
#import "RDVTabBarItem.h"

#import <AlipaySDK/AlipaySDK.h>
#import "WXApi.h"
//#import <MobClick.h>
#import "UMSocial.h"

#import "HomeViewController.h"
#import "ShoppingCarViewController.h"
#import "UserViewController.h"

#import "LoginViewController.h"



@interface AppDelegate ()<WXApiDelegate,RDVTabBarControllerDelegate>
@property (strong, nonatomic) RDVTabBarController *tabBarController;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    [self setupThirdparty];
    
    [[DBManager instance] createDB];

    [self changeToMainPage];
    
    
    
    return YES;
}

- (void)jump:(NSNotification *)noti {
    [self.tabBarController setSelectedIndex:0];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    
    if ([url.absoluteString hasPrefix:@"wxedddf5c468bfd955://pay"]){
        
        return [WXApi handleOpenURL:url delegate:self];

        
    }else{
        
        //跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
        }];
    }
    

    return YES;
}



#pragma mark - config
- (void)registRemoteNotification
{
}


- (void)setupThirdparty
{
    //UMENG
//    [MobClick startWithAppkey:UMENG_KEY reportPolicy:BATCH channelId:@"WEB"];
//    [MobClick setAppVersion:[EWUtils ew_bundleVersion]];
//    [UMSocialData setAppKey:UMENG_KEY];
//    [WXApi registerApp:WXKEY withDescription:@"有菜红包"];

}


#pragma mark - page
- (void)changeToMainPage
{
    
    UINavigationController *home = [[UINavigationController alloc] initWithRootViewController:HomeViewController.new];
    
    UINavigationController *cart = [[UINavigationController alloc]initWithRootViewController:ShoppingCarViewController.new];
    
    UINavigationController *user = [[UINavigationController alloc]initWithRootViewController:UserViewController.new];

    
    self.tabBarController = [[RDVTabBarController alloc] init];
    self.tabBarController.delegate = self;
    
    [self.tabBarController setViewControllers:@[home,cart,user]];
//    [self customizeTabBarForController:_tabbarController];
    
    [self setupTabBarItems];
    
    self.window.rootViewController = self.tabBarController;

}

- (void)setupTabBarItems
{
    RDVTabBar *tabBar = self.tabBarController.tabBar;
    tabBar.translucent = YES;
    tabBar.backgroundView.backgroundColor = WHITE_COLOR;
    tabBar.height = 60;
    
    NSArray *tabBarItemImages = @[@"home", @"cart",@"mine"];
    
    NSInteger index = 0;
    for (RDVTabBarItem *item in [[self.tabBarController tabBar] items]) {
        UIImage *selectedimage = [UIImage imageNamed:[NSString stringWithFormat:@"%@_selected",
                                                      [tabBarItemImages objectAtIndex:index]]];
        UIImage *unselectedimage = [UIImage imageNamed:[NSString stringWithFormat:@"%@_unselected",
                                                        [tabBarItemImages objectAtIndex:index]]];
        [item setFinishedSelectedImage:selectedimage withFinishedUnselectedImage:unselectedimage];
        [item setSelectedTitleAttributes:@{NSFontAttributeName:FONT(11),                           NSForegroundColorAttributeName: RGB_COLOR(0, 171, 97)}];
        [item setUnselectedTitleAttributes:@{NSFontAttributeName:FONT(11),NSForegroundColorAttributeName:RGB_COLOR(80, 80, 80)}];
        index++;
    }

    
    [self updateCartTabBadge];
}

- (void)customizeTabBarForController:(RDVTabBarController *)tabBarController {
    
    RDVTabBar *tabBar = tabBarController.tabBar;
    tabBar.translucent = YES;
    tabBar.backgroundView.backgroundColor = WHITE_COLOR;
    tabBar.height = 60;

    UIImage *finishedImage = [UIImage imageNamed:@"tabbar_background"];
    UIImage *unfinishedImage = [UIImage imageNamed:@"tabbar_background"];
    
    NSArray *tabBarItemImages = @[@"home", @"cart",@"mine"];
    
    NSInteger index = 0;
    for (RDVTabBarItem *item in [[tabBarController tabBar] items]) {
        [item setBackgroundSelectedImage:finishedImage withUnselectedImage:unfinishedImage];
        UIImage *selectedimage = [UIImage imageNamed:[NSString stringWithFormat:@"%@_selected",
                                                      [tabBarItemImages objectAtIndex:index]]];
        UIImage *unselectedimage = [UIImage imageNamed:[NSString stringWithFormat:@"%@_unselected",
                                                        [tabBarItemImages objectAtIndex:index]]];
        [item setFinishedSelectedImage:selectedimage withFinishedUnselectedImage:unselectedimage];
        [item setSelectedTitleAttributes:@{NSFontAttributeName:FONT(11),                           NSForegroundColorAttributeName: RGB_COLOR(0, 171, 97)}];
        [item setUnselectedTitleAttributes:@{NSFontAttributeName:FONT(11),NSForegroundColorAttributeName:RGB_COLOR(80, 80, 80)}];
        index++;
    }
    
    [self updateCartTabBadge];
}

- (void)updateCartTabBadge
{
    NSMutableArray *items = [[DBManager instance] getAllItems];
    NSInteger count = 0;
    for (NSInteger i = 0; i < items.count; i++) {
        count += [items[i][@"count"] integerValue];
    }

    RDVTabBarItem *item = [self.tabBarController.tabBar.items objectAtIndex:1];
    
    if(count == 0)
        [item setBadgeValue:nil];
    else
        [item setBadgeValue:[NSString stringWithFormat:@"%ld", (long)count]];
        [item setBadgeTextFont:FONT(8)];
        [item setBadgePositionAdjustment:UIOffsetMake(-6, 8)];
        item.badgeBackgroundColor = RED_COLOR;

}

@end

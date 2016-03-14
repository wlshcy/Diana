//
//  AppDelegate.m
//  Lynp
//
//  Created by nmg on 16/2/2.
//  Copyright (c) 2016 nmg. All rights reserved.
//

#import "AppDelegate.h"
#import <AlipaySDK/AlipaySDK.h>
#import "WXApi.h"
//#import <MobClick.h>
#import "UMSocial.h"

//#import "HomeViewController.h"
#import "UserViewController.h"
//#import "FrtViewController.h"
//#import "SptViewController.h"
#import "EspSaleViewController.h"
#import "ShoppingCarViewController.h"
#import "VegViewController.h"
#import "ComboListViewController.h"
#import "LoginViewController.h"

@interface AppDelegate ()<WXApiDelegate>
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    [self registRemoteNotification];
    [self registLocalNotification];
    [self setupThirdparty];
    
    
    //init app
    //[self initApp];
    
    //正式
    [self changeToMainPage];
    
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //update
        //[self appUpdate];

    });
    
    //db
    [[DBManager instance] createDB];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(jump:) name:@"JUMP" object:nil];
    
    return YES;
}

- (void)jump:(NSNotification *)noti {
    [self.tabbarController setSelectedIndex:0];
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

- (void)registLocalNotification
{
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(login:) name:@"ERROR403" object:nil];
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
    
    UINavigationController *home = [[UINavigationController alloc] initWithRootViewController:VegViewController.new];
    
//    UINavigationController *esp = [[UINavigationController alloc] initWithRootViewController:EspSaleViewController.new];
    UINavigationController *combo = [[UINavigationController alloc] initWithRootViewController:ComboListViewController.new];
    
    UINavigationController *car = [[UINavigationController alloc]initWithRootViewController:ShoppingCarViewController.new];
    
    UINavigationController *user = [[UINavigationController alloc]initWithRootViewController:UserViewController.new];
    

    NSArray *titles = @[@"单品", @"套餐", @"购物车", @"我的"];
    NSArray *images = @[@"home_unselected", @"esp_unselected", @"cart_unselected", @"mine_unselected"];
    NSArray *selectimages = @[@"home_selected",@"esp_selected", @"cart_selected",@"mine_selected"];
    
    _tabbarController = [[UITabBarController alloc] init];
    _tabbarController.viewControllers = @[home,combo,car,user];
    [_tabbarController ew_configTabBarItemWithTitles:titles font:FONT(12) titleColor:RGB_COLOR(164, 162, 154) selectedTitleColor:RGB_COLOR(17,194, 88) images:images selectedImages:selectimages barBackgroundImage:nil];
    
    self.window.rootViewController = _tabbarController;
}


#pragma mark - InitApp
- (void)initApp
{
    NSInteger flag = [[EWUtils getObjectForKey:SHOULDINIT] integerValue];
    if (flag == 0) {
        
        [HTTPManager appInitSuccess:^(id response) {
            if ([response[@"init"] integerValue] == 1) {
                
            }else{
                DBLog(@"初始化失败~");
            }

        } failure:^(NSError *err) {
            DBError(err);

        }];
    }else{
        [EWUtils loadCookies];
    }

}


#pragma mark - wechat paty
//支付跳转回到 app 后带有支付状态
- (void) onResp:(BaseResp*)resp
{
    
    PayResp *response = (PayResp *)resp;
    
    switch (response.errCode)
    {
        case WXSuccess:
            
            //支付成功,进一步写相关逻辑
            
            POSTNOTIFICATION(@"WXPAYRESULT", @"0");
            
            break;
            
        case WXErrCodeUserCancel:
            //用户中途取消支付
            POSTNOTIFICATION(@"WXPAYRESULT", @"-2");

            break;
            
        case WXErrCodeCommon:
        case WXErrCodeAuthDeny:
        case WXErrCodeSentFail:
        case WXErrCodeUnsupport:
            //支付失败!
            POSTNOTIFICATION(@"WXPAYRESULT", @"-5");

            break;
            
        default:
            break;
    }
    
}



#pragma mark - app update
- (void)appUpdate
{
    [HTTPManager updateWithSuccess:^(id response) {
        
        DBLog(@"----response=%@",response);
        if (response[@"errmesg"] != nil) {
            
        }else{
            
            if ([VGUtils isNeedUpdate:response[@"version"]]) {
                
                if ([response[@"status"] integerValue] == 1) {
                    DBLog(@"可更新");
                    
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"应用升级" message:response[@"change"] delegate:nil cancelButtonTitle:@"更新" otherButtonTitles:@"取消", nil];
                    
                    [alert showAlertWithBlock:^(NSInteger buttonIndex) {
                        
                        if (buttonIndex == 1) {
                            
                            [EWUtils ew_jumpToAppleStore];
                        }
                        
                    }];
                    
                    
                }else if ([response[@"status"] integerValue] == 2){
                    DBLog(@"强制更新");
                    
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"应用升级" message:response[@"change"] delegate:nil cancelButtonTitle:@"更新" otherButtonTitles:nil, nil];
                    
                    [alert showAlertWithBlock:^(NSInteger buttonIndex) {

                        [EWUtils ew_jumpToAppleStore];

                        
                    }];

                }
                
            }
            
        }
        
    } failure:^(NSError *err) {
        
    }];
}


- (void)loginWithWX:(UIViewController *)controller
{
    SendAuthReq* req = [[SendAuthReq alloc] init] ;
    req.scope = @"snsapi_userinfo"; // @"post_timeline,sns"
    req.state = @"MyVillage";
    
    [WXApi sendAuthReq:req viewController:controller delegate:self];
    
}



#pragma mark - handle login
- (void)login:(NSNotification *)noti
{
    UINavigationController *nav = [self.tabbarController selectedViewController];
    
    UIViewController *controller = nav.viewControllers.lastObject;
    
    UINavigationController *navLogin = [[UINavigationController alloc] initWithRootViewController:[LoginViewController new]];
    [controller presentViewController:navLogin animated:YES completion:nil];
}


@end

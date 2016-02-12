//
//  EWUtils.h
//  Easywork
//
//  Created by Kingxl on 11/3/14.
//  Copyright (c) 2014 Jin. All rights reserved.
//  http://kingxl.cn

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, DeviceResolution)
{
    iPhone_320_480  = 0,
    iPhone_640_960   ,
    iPhone_640_1136  ,
    iPhone_750_1334  , //iphone 6
    iPhone_1242_2208 , //iphone 6+
};


@interface EWUtils : NSObject

/** Bundle version */
+ (NSString *)ew_bundleVersion;
+ (void)ew_jumpToAppleStore;

/** File path */
+ (NSString *)ew_documentsPath;
+ (NSString *)ew_cachePath;
+ (NSString *)ew_bundleFile:(NSString*)file;
+ (NSString *)ew_documentFile:(NSString*)file;

+ (DeviceResolution)ew_deviceResolution;  // iphone resolution  not ipad


/**File */
+ (BOOL)ew_fileExist:(NSString *)fileName;  //document file

/** Play sound*/
+ (void)ew_playSound:(NSString *)path;
+ (void)ew_playSoundWithVibrate:(NSString *)path;
+ (void)ew_playVibrate;

/** Notification */
+ (void)uninstallNotification:(id)data;

/** UserDefault */
+ (void)setObject:(id)data key:(NSString *)key;
+ (id)getObjectForKey:(NSString *)key;
+ (void)deleteObject:(NSString *)key;

/** Status bar */
+ (void)showStatusBar;
+ (void)hideStatusBar;

/** Cookies */
+ (void)saveCookies;
+ (void)loadCookies;

/** uiimage */
+ (UIImage *)scaleToSize:(UIImage *)img;

/** Alert message */
void AlertWithError(NSError *error);
void AlertWithMessage(NSString *message);
void AlertWithMessageAndDelegate(NSString *message, id delegate);


/**utils*/
+ (void)ew_callNumber:(NSString *)phone;

@end

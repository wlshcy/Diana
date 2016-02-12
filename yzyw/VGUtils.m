//
//  VGUtils.m
//  Garden
//
//  Created by 金学利 on 8/12/15.
//  Copyright (c) 2015 Kingxl. All rights reserved.
//

#import "VGUtils.h"

@implementation VGUtils

+ (BOOL)userHasLogin
{
    NSInteger flag = [[EWUtils getObjectForKey:USERHASLOGIN] integerValue];
    if (flag == 1) {
        return YES;
    }
    return NO;
}

+ (void)saveUserData:(NSDictionary *)data
{
    [data enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        
        if (obj && ![obj isEqual:[NSNull null]]) {
            [EWUtils setObject:[NSString stringWithFormat:@"%@",obj] key:key];
        }
        
    }];
}

+ (UIViewController *)cacheControllerWithName:(NSString *)name controllers:(NSArray *)controllers
{
    
    UIViewController *vc = nil;
    
    for (NSInteger i = 0; i < controllers.count; i++) {
        if ([controllers[i] isKindOfClass:NSClassFromString(name)]) {
            vc = controllers[i];
        }
    }
    
    if (vc) {
        return vc;
    }
    
    return nil;
}


void POSTNOTIFICATION(NSString *name,id data)
{
    if (data) {
        [[NSNotificationCenter defaultCenter] postNotificationName:name object:nil userInfo:@{@"data":data}];
    }else{
        [[NSNotificationCenter defaultCenter] postNotificationName:name object:nil];
    }

}

void REMOVENOTIFICATION(id sender)
{
    [[NSNotificationCenter defaultCenter] removeObserver:sender];
}

NSString *STR(id data)
{
    return [NSString stringWithFormat:@"%@",data];
}


+ (BOOL)isNeedUpdate:(NSString *)ver
{
    BOOL flag = NO;
    //已经存储的
    NSString *preVer = [EWUtils ew_bundleVersion];
    NSString *curVer = ver;    
    //比较两个版本
    NSArray *preArr = [preVer ew_sepratorwithString:@"."];
    NSArray *curArr = [curVer ew_sepratorwithString:@"."];
    //DBLog(@"prearr===%@",preArr);
    //DBLog(@"\n__curarr___%@",curArr);
    
    int pV = [[preArr componentsJoinedByString:@""] intValue];
    int cV = [[curArr componentsJoinedByString:@""] intValue];
    
    //DBLog(@"prearr===%d",pV);
    //DBLog(@"\n__curarr___%d",cV);
    
    
    if (cV > pV) {
        flag = YES;
    }
    
    if (flag) {
        [EWUtils setObject:@"有可用更新" key:@"UPDATE"];
    }else{
        [EWUtils setObject:@"已经是最新版本" key:@"UPDATE"];
    }
    
    return flag;

}

+ (BOOL)isWelcome
{
    BOOL flag = NO;
    //已经存储的
    NSString *preVer = [EWUtils getObjectForKey:@"APPVERSION"];
    NSString *curVer = [EWUtils ew_bundleVersion];
    
    //比较两个版本
    NSArray *preArr = [preVer ew_sepratorwithString:@"."];
    NSArray *curArr = [curVer ew_sepratorwithString:@"."];
    //DBLog(@"prearr===%@",preArr);
    //DBLog(@"\n__curarr___%@",curArr);
    
    int pV = [[preArr componentsJoinedByString:@""] intValue];
    int cV = [[curArr componentsJoinedByString:@""] intValue];
    
    //DBLog(@"prearr===%d",pV);
    //DBLog(@"\n__curarr___%d",cV);
    
    
    if (cV > pV) {
        flag = YES;
    }
    
    return flag;
    

}

@end

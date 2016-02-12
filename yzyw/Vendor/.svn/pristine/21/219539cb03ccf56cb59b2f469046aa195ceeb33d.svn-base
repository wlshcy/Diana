//
//  UIWebView+Extension.m
//  Easywork
//
//  Created by Kingxl on 1/11/15.
//  Copyright (c) 2015 Jin. All rights reserved.
//

#import "UIWebView+Extension.h"

@implementation UIWebView (Extension)

- (NSString *)ew_title
{
     return [self stringByEvaluatingJavaScriptFromString:@"document.title"];
}

- (NSURL *)ew_url
{
    
    NSString *urlString = [self stringByEvaluatingJavaScriptFromString:@"location.href"];
    if (urlString) {
        return [NSURL URLWithString:urlString];
    }
    return nil;
}


- (NSString *)ew_html
{
    return [self stringByEvaluatingJavaScriptFromString:@"document.documentElement.innerHTML"];
}

- (void)ew_clean
{
    [self loadHTMLString:@"" baseURL:nil];
    [self stopLoading];
    self.delegate = nil;
    [self removeFromSuperview];
    
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    [[NSURLCache sharedURLCache] setDiskCapacity:0];
    [[NSURLCache sharedURLCache] setMemoryCapacity:0];

}

- (void)webView:(UIWebView *)sender runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(CGRect)frame
{
//    NSLog(@"message=%@",message);
    
//    if (1) {
//       //TODO: xxxxxx
//        
//    }else{
//        [[[UIAlertView alloc] initWithTitle:@"提示" message:message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
//    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"WEBVIEWALERT" object:nil userInfo:@{@"msg":message}];
}


@end

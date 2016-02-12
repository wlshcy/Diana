//
//  NSTimer+Extension.m
//  Easywork
//
//  Created by Kingxl on 12/30/14.
//  Copyright (c) 2014 Jin. All rights reserved.
//

#import "NSTimer+Extension.h"

@implementation NSTimer (Extension)

+ (NSTimer *)ew_scheduledTimerWithTimeInterval:(NSTimeInterval)interval
                                         block:(void(^)())block
                                       repeats:(BOOL)repeats
{
    return [self scheduledTimerWithTimeInterval:interval target:self selector:@selector(ew_blockInvoke:) userInfo:[block copy] repeats:repeats];
}

+ (void)ew_blockInvoke:(NSTimer *)timer
{
    void (^block)() = timer.userInfo;
    if (block) {
        block();
    }
}

@end

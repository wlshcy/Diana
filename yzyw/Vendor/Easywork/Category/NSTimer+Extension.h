//
//  NSTimer+Extension.h
//  Easywork
//
//  Created by Kingxl on 12/30/14.
//  Copyright (c) 2014 Jin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSTimer (Extension)

+ (NSTimer *)ew_scheduledTimerWithTimeInterval:(NSTimeInterval)interval
                                         block:(void(^)())block
                                       repeats:(BOOL)repeats;

@end

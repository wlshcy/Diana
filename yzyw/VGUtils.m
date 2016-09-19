#import "VGUtils.h"
#import "Lockbox.h"

@implementation VGUtils

+ (BOOL)userHasLogin
{
    if ([Lockbox unarchiveObjectForKey:@"token"] != nil) {
        return true;
    }
    return false;
}

@end

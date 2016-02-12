//
//  EWLocationManager.h
//  MyVillage
//
//  Created by 金学利 on 6/11/15.
//  Copyright (c) 2015 Kingxl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

typedef void (^LocationSuccessBlock)(CLLocationCoordinate2D locationCorrrdinate);
typedef void (^LocationErrorBlock) (NSError *error);

@interface EWLocationManager : NSObject

+ (instancetype)instance;

- (void)getLocationCoordinate:(LocationSuccessBlock)success error:(LocationErrorBlock)error;
- (void)stopLocation;

@end

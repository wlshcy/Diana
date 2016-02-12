//
//  OrderEnsureController.h
//  Garden
//
//  Created by nmg on 16/1/13.
//  Copyright © 2016年 Kingxl. All rights reserved.
//

#ifndef OrderEnsureController_h
#define OrderEnsureController_h

#import "EWViewController.h"

//@interface UserAddressInfo : NSObject
//@property (nonatomic, strong) NSString *name;
//@property (nonatomic, strong) NSString *mobile;
//@property (nonatomic, strong) NSString *region;
//@property (nonatomic, strong) NSString *address;
//@end


@interface OrderEnsureViewController : EWViewController

@property (nonatomic, strong) NSDictionary *address;
@property (nonatomic ,assign) BOOL isFromOrder;
@property (nonatomic, assign) BOOL needFreight;
@property (nonatomic, assign) float totalPrice;
@property (nonatomic, assign) float freight;
@property (nonatomic, assign) NSInteger payType;
@property (nonatomic, strong) NSDictionary *order;
@property (nonatomic, strong) NSString *orderNo;
//@property (nonatomic, strong) NSMutableArray *items;

@end


#endif /* OrderEnsureController_h */

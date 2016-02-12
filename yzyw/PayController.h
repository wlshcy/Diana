//
//  PayController.h
//  YW
//
//  Created by nmg on 16/2/4.
//  Copyright (c) 2016 nmg. All rights reserved.
//

#import "EWViewController.h"

@interface PayController : EWViewController


@property (nonatomic, strong) NSDictionary *order;  //订单的信息；
@property (nonatomic, assign) float totalPrice;
@property (nonatomic, assign) NSInteger fromType; // 1 选品来的 2 订单来的


@property (nonatomic, strong) NSMutableArray *caiData;
@property (nonatomic, strong) NSMutableArray *bxData;
@property (nonatomic, strong) NSString *comboid;
@property (nonatomic, assign) NSInteger type;  //1 2
@property (nonatomic, strong) NSString *beizhu;
@property (nonatomic, strong) NSString *comboIdx;


@property (nonatomic, assign) NSInteger payType; //1 特产支付 2 套餐支付 3 秒杀支付

@property (nonatomic, strong) TCData *msdata;
@property (nonatomic, assign) BOOL needFreight; // 这个价格是否需要运费。

@property (nonatomic ,assign) BOOL isFromOrder;
@property (nonatomic, strong) NSString *orderNo;
@property (nonatomic, strong) UserAddressInfo *address; //移到前边

@property (nonatomic, strong) NSArray *requiredData;

//- (instancetype)initWithData:(NSDictionary *)data; //alipay and orderno


@end

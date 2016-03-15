//
//  HTTPManager.h
//  Garden
//
//  Created by 金学利 on 8/1/15.
//  Copyright (c) 2015 Kingxl. All rights reserved.
//

#import <Foundation/Foundation.h>
@import CoreLocation;

typedef NS_ENUM(NSInteger, RequestMethodType){
    RequestMethodTypePost = 1,
    RequestMethodTypeGet = 2,
    RequestMethodTypeDelete = 3
};


@interface HTTPManager : NSObject


/**
 *  发送一个请求
 *
 *  @param methodType   请求方法
 *  @param url          请求路径
 *  @param params       请求参数
 *  @param success      请求成功后的回调（请将请求成功后想做的事情写到这个block中）
 *  @param failure      请求失败后的回调（请将请求失败后想做的事情写到这个block中）
 */
+(void)requestWithMethod:(RequestMethodType)methodType
                     url:(NSString *)url
               parameter:(NSDictionary *)parameter
                 success:(void (^)(id response))success
                 failure:(void (^)(NSError *err))failure;


//init
+ (void)appInitSuccess:(void (^)(id response))success
               failure:(void (^)(NSError *err))failure;

//getcode
+ (void)getCodeWithPhone:(NSString *)phone
                    type:(NSString *)type //修改密码传6 登录5
                  success:(void (^)(id response))success
                  failure:(void (^)(NSError *err))failure;


//login
+ (void)loginWithPhone:(NSString *)phone
                  code:(NSString *)code
                  type:(NSInteger)type
               success:(void (^)(id response))success
               failure:(void (^)(NSError *err))failure;


//zonelist
+ (void)zoneListWithLocation:(CLLocationCoordinate2D)location
                     success:(void (^)(id response))success
                     failure:(void (^)(NSError *err))failure;



//citylist
+ (void)cityListWithSuccess:(void (^)(id response))success
                   failure:(void (^)(NSError *err))failure;

//region
+ (void)regionListWithSuccess:(void (^)(id response))success
                      failure:(void (^)(NSError *err))failure;
//search
+ (void)searchCityWithCityId:(NSString *)cid
                     ksyword:(NSString *)keyword
                     success:(void (^)(id response))success
                     failure:(void (^)(NSError *err))failure;


//address
+ (void)addUserAddressWithID:(NSString *)aid
                        name:(NSString *)name
                      mobile:(NSString *)mobile
                        city:(NSString *)city
                      region:(NSString *)region
                      street:(NSString *)street
                         zid:(NSString *)zid
                       zname:(NSString *)zname
                    building:(NSString *)building
                        unit:(NSString *)unit
                        room:(NSString *)room
                     success:(void (^)(id response))success
                     failure:(void (^)(NSError *err))failure;

//get address
+ (void)getUserAddressWithSuccess:(void (^)(id response))success
                          failure:(void (^)(NSError *err))failure;


//combo
+ (void)comboWithLastid:(NSString *)lastid
                 length:(NSInteger)length
                success:(void (^)(id response))success
                failure:(void (^)(NSError *err))failure;


//comboinfo
+ (void)comboInfoWithID:(NSString *)cid
                success:(void (^)(id response))success
                failure:(void (^)(NSError *err))failure;


//comboItemList
+ (void)comboItemListWithId:(NSString *)cid
                    orderno:(NSString *)orderno
                       mode:(NSString *)mode
                    success:(void (^)(id response))success
                    failure:(void (^)(NSError *err))failure;


//首页轮播图
+ (void)getSlideWithSuccess:(void (^)(id response))success
                    failure:(void (^)(NSError *err))failure;



//更新
+ (void)updateWithSuccess:(void (^)(id response))success
                  failure:(void (^)(NSError *err))failure;


//订单列表
+ (void)orderListWithLastId:(NSString *)lastid
                       type:(NSString*)type
                    success:(void (^)(id response))success
                    failure:(void (^)(NSError *err))failure;

//订单详情
+ (void)orderDetailWithOrderId:(NSString *)orderno
                       success:(void (^)(id response))success
                       failure:(void (^)(NSError *err))failure;


//创建订单
+ (void)createOrderWithComboId:(NSString *)comboId
                      couponId:(NSString *)couponid  //add new 红包id
                          type:(NSString *)type
                      comboIdx:(NSString *)comboIdx
                         items:(NSString *)items
                        extras:(NSString *)extras
                        spares:(NSString *)spares //add new  备选
                          name:(NSString *)name
                        mobile:(NSString *)mobile
                       address:(NSString *)address
                          memo:(NSString *)memo    //add new 备注
                         addon:(NSString *)addon  //2.2.0 新增固定菜
                       paytype:(NSString *)paytype  //2.支付宝支付，3.微信支付
                       success:(void (^)(id response))success
                       failure:(void (^)(NSError *err))failure;

//pay order
+ (void)payOrderWithOrderId:(NSString *)orderno
                   couponId:(NSString *)coupon_id
                    paytype:(NSString *)paytype
                    success:(void (^)(id response))success
                    failure:(void (^)(NSError *err))failure;


//cai/delorder
+ (void)delOrderWithId:(NSString *)orderid
               success:(void (^)(id response))success
               failure:(void (^)(NSError *err))failure;


//反馈
+ (void)feedBackWithContent:(NSString *)content
                    success:(void (^)(id response))success
                    failure:(void (^)(NSError *err))failure;


//logout
+ (void)logoutWithSuccess:(void (^)(id response))success
                  failure:(void (^)(NSError *err))failure;
//cai/altorder
+ (void)alterOrderWithOrderNo:(NSString *)orderNo
                        items:(NSString *)items
                       spares:(NSString *)spares
                        addon:(NSString *)addon
                         name:(NSString *)name
                       mobile:(NSString *)mobile
                      address:(NSString *)address
                         memo:(NSString *)memo
                      success:(void (^)(id response))success
                      failure:(void (^)(NSError *err))failure;


// /cai/home
//+ (void)caiHomeDataWithMode:(NSInteger)mode
//                    success:(void (^)(id response))success
//                    failure:(void (^)(NSError *err))failure;

//+ (void)getVegs:(void (^)(id response))success
//        failure:(void (^)(NSError *err))failure;

+ (void)showVeg:(NSString *)cid
        success:(void (^)(id response))success
        failure:(void (^)(NSError *err))failure;

+ (void) getVegs:(NSString *)lastid
         success:(void (^)(id response))success
         failure:(void (^)(NSError *err))failure;

+ (void)getVegSlides:(void (^)(id response))success
        failure:(void (^)(NSError *err))failure;

+ (void) getEsps:(NSString *)lastid
         success:(void (^)(id response))success
         failure:(void (^)(NSError *err))failure;

+ (void) getCombos:(NSString *)lastid
         success:(void (^)(id response))success
         failure:(void (^)(NSError *err))failure;

+ (void)showEsp:(NSString *)vid
        success:(void (^)(id response))success
        failure:(void (^)(NSError *err))failure;

+ (void)showFrt:(NSString *)cid
        success:(void (^)(id response))success
        failure:(void (^)(NSError *err))failure;

+ (void) getFrts:(NSString *)lastid
         success:(void (^)(id response))success
         failure:(void (^)(NSError *err))failure;

+ (void)getFrtSlides:(void (^)(id response))success
             failure:(void (^)(NSError *err))failure;

+ (void)showSpt:(NSString *)cid
        success:(void (^)(id response))success
        failure:(void (^)(NSError *err))failure;

+ (void) getSpts:(NSString *)lastid
         success:(void (^)(id response))success
         failure:(void (^)(NSError *err))failure;

+ (void)getSptSlides:(void (^)(id response))success
             failure:(void (^)(NSError *err))failure;


+ (void)caiHomeDataWithMode:(NSInteger)mode
        success:(void (^)(id response))success
        failure:(void (^)(NSError *err))failure;


+ (void)addAddress:(NSString *)name
            mobile:(NSString *)mobile
            region:(NSString *)region
           address:(NSString *)address
           success:(void (^)(id response))success
           failure:(void (^)(NSError *err))failure;

+ (void)getAddresses:(void (^)(id))success
             failure:(void (^)(NSError *))failure;

+ (void)getZoneData:(void (^)(id response))success
            failure:(void (^)(NSError *err))failure;

+ (void)deleteAddress:(NSString *)addr_id
              success:(void (^)(id))success
             failure:(void (^)(NSError *))failure;
/**
 *  1.1.0 新增接口
 */

// /cai/delay
+ (void)caiDelayWithType:(NSInteger)type  // 1 get 2 post
                 orderNo:(NSString *)orderNo
                 success:(void (^)(id response))success
                 failure:(void (^)(NSError *err))failure;


//红包
+ (void)caiCouponWithType:(NSString *)type  //nil 列表 1 套餐 2 单品
                   lastid:(NSString *)lastId
                   usable:(NSString *)usable //可选，0.不可用优惠券，1.可用优惠券，默认1
                  success:(void (^)(id response))success
                  failure:(void (^)(NSError *err))failure;


///user/v2/address
+ (void)userAddressListWithSuccess:(void (^)(id response))success
                           failure:(void (^)(NSError *err))failure;


// 新增用户地址
+ (void)userAddressAddNewWithId:(NSInteger)aid
                           name:(NSString *)name
                         mobile:(NSString *)mobile
                            zid:(NSString *)zid
                          zname:(NSString *)zname
                            bur:(NSString *)bur
                        Success:(void (^)(id response))success
                        failure:(void (^)(NSError *err))failure;

// /cai/choose get
+ (void)caiChooseWithOrderno:(NSString *)orderNo
                     success:(void (^)(id response))success
                     failure:(void (^)(NSError *err))failure;

// /cai/choose post create order
+ (void)createXPOrderWithOrderNo:(NSString *)orderno
                            items:(NSString *)items
                           spares:(NSString *)spares
                             memo:(NSString *)memo
                            addon:(NSString *)addon //2.2.0 新增的
                             name:(NSString *)name
                           mobile:(NSString *)mobile
                          address:(NSString *)address
                          success:(void (^)(id response))success
                          failure:(void (^)(NSError *err))failure;


// cai/coupon 获取分享连接

+ (void)getCouponDataWithOrderNo:(NSString *)oderno
                         success:(void (^)(id response))success
                         failure:(void (^)(NSError *err))failure;



// cai/itemlist  扩展
+ (void)caiMoreTcWithId:(NSString *)tid
                success:(void (^)(id response))success
                failure:(void (^)(NSError *err))failure;



//  /cai/mycombo
+ (void)caiMyCombWithSuccess:(void (^)(id response))success
                     failure:(void (^)(NSError *err))failure;



// /cai/itemdtl
+ (void)caiItemDetailWithCaiId:(NSString *)cid
                       success:(void (^)(id response))success
                       failure:(void (^)(NSError *err))failure;


//添加地址 v3 版本
+ (void)addV3AddressWithId:(NSString *)aid
                      name:(NSString *)name
                    mobile:(NSString *)mobile
                      city:(NSString *)city
                    region:(NSString *)region
                   address:(NSString *)address
                   success:(void (^)(id response))success
                   failure:(void (^)(NSError *err))failure;


//获取地址 v3 版本
+ (void)getUserV3AddressWithSuccess:(void (^)(id response))success
                            failure:(void (^)(NSError *err))failure;


//change pwd
+ (void)changePassword:(NSString *)password
               smscode:(NSString *)smscode
               success:(void (^)(id response))success
               failure:(void (^)(NSError *err))failure;



///delete user address
+ (void)deleteUserAddressWithId:(NSString *)aid
                        success:(void (^)(id response))success
                        failure:(void (^)(NSError *err))failure;




@end

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



//init
+ (void)showVeg:(NSString *)cid
        success:(void (^)(id response))success
        failure:(void (^)(NSError *err))failure;

+ (void) getItems:(NSString *)lastid
         success:(void (^)(id response))success
         failure:(void (^)(NSError *err))failure;

+ (void)getOnsales:(void (^)(id response))success
        failure:(void (^)(NSError *err))failure;

+ (void) getEsps:(NSString *)lastid
         success:(void (^)(id response))success
         failure:(void (^)(NSError *err))failure;

+ (void) getCombos:(NSString *)lastid
         success:(void (^)(id response))success
         failure:(void (^)(NSError *err))failure;

+ (void)showCombo:(NSString *)cid
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

+ (void)getOrders:(NSString *)lastid
           length:(NSInteger)length
          success:(void (^)(id))success
             failure:(void (^)(NSError *))failure;

+ (void)getZoneData:(void (^)(id response))success
            failure:(void (^)(NSError *err))failure;

+ (void)deleteAddress:(NSString *)addr_id
              success:(void (^)(id))success
             failure:(void (^)(NSError *))failure;

+ (void)createOrder:(NSString *)name
             mobile:(NSString *)mobile
             region:(NSString *)region
            address:(NSString *)address
            paytype:(NSInteger)paytype
              items:(NSMutableArray *)items
            success:(void (^)(id response))success
            failure:(void (^)(NSError *err))failure;
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

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
                token:(NSString *)token
                 success:(void (^)(id response))success
                 failure:(void (^)(NSError *err))failure;

+ (void)getSMSCode:(NSString *)phone
                 success:(void (^)(id response))success
                 failure:(void (^)(NSError *err))failure;


//login
+ (void)loginWithSMSCode:(NSString *)phone
                    code: (NSString *)code
               success:(void (^)(id response))success
               failure:(void (^)(NSError *err))failure;



//init
+ (void)showItem:(NSString *)cid
        success:(void (^)(id response))success
        failure:(void (^)(NSError *err))failure;

+ (void) getItems:(NSString *)lastid
         success:(void (^)(id response))success
         failure:(void (^)(NSError *err))failure;

+ (void)getOnsales:(void (^)(id response))success
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

@end

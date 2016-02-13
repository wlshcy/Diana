//
//  HTTPManager.m
//  Garden
//
//  Created by 金学利 on 8/1/15.
//  Copyright (c) 2015 Kingxl. All rights reserved.
//

#import "HTTPManager.h"

//static NSString *const BASE_URL = @"https://api.shequcun.com";
static NSString *const BASE_URL = @"http://api.freshtaste.me:8080";

@implementation HTTPManager

+ (void)requestWithMethod:(RequestMethodType)methodType url:(NSString *)url parameter:(NSDictionary *)parameter success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    AFHTTPRequestOperationManager* manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:BASE_URL]];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"text/plain",@"application/json",nil];
    manager.requestSerializer.HTTPShouldHandleCookies = YES;
    [manager.requestSerializer setValue:[self userAgent] forHTTPHeaderField:@"User-Agent"];
    [manager.requestSerializer setValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"];
    manager.operationQueue.maxConcurrentOperationCount = 5;
    manager.requestSerializer.timeoutInterval = 10;
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    switch (methodType) {
        case RequestMethodTypeGet:
        {
            //GET请求
            [manager GET:url parameters:parameter
                 success:^(AFHTTPRequestOperation* operation, NSDictionary* responseObj) {
                     if (success) {
                         if ([url isEqualToString:@"/auth/init"]) {
                             [EWUtils setObject:operation.response.allHeaderFields[@"X-Xsrftoken"] key:@"_xsrf"];
                         }
                         [EWUtils saveCookies];
                         success(responseObj);
                         
//    
//                         if ([responseObj[@"errcode"] integerValue] == 403 || 2001==[responseObj[@"errcode"] integerValue]) {
//                             //处理403的问题
//                             POSTNOTIFICATION(@"ERROR403", nil);
//                             
//                         }
                     }
                 } failure:^(AFHTTPRequestOperation* operation, NSError* error) {
                     if (failure) {
                         failure(error);
                     }
                 }];
            
        }
            break;
        case RequestMethodTypePost:
        {
            //POST请求
            [manager POST:url parameters:parameter
                  success:^(AFHTTPRequestOperation* operation, NSDictionary* responseObj) {
                      if (success) {
                          [EWUtils saveCookies];
                          success(responseObj);
                          
                          if ([responseObj[@"errcode"] integerValue] == 403|| 2001==[responseObj[@"errcode"] integerValue]) {
                              //处理403的问题
                              POSTNOTIFICATION(@"ERROR403", nil);

                          }

                      }
                  } failure:^(AFHTTPRequestOperation* operation, NSError* error) {
                      if (failure) {
                          failure(error);
                      }
                  }];
        }
            break;
        case RequestMethodTypeDelete:
        {
            [manager DELETE:url parameters:parameter
                  success:^(AFHTTPRequestOperation* operation, NSDictionary* responseObj) {
                      if (success) {
                          [EWUtils saveCookies];
                          success(responseObj);
                          
                          if ([responseObj[@"errcode"] integerValue] == 403|| 2001==[responseObj[@"errcode"] integerValue]) {
                              //处理403的问题
                              POSTNOTIFICATION(@"ERROR403", nil);
                              
                          }
                          
                      }
                  } failure:^(AFHTTPRequestOperation* operation, NSError* error) {
                      if (failure) {
                          failure(error);
                      }
                  }];
        }
        default:
            break;
    }
    
}

+ (NSString *)userAgent
{
    NSString *version = [EWUtils ew_bundleVersion];
    NSString *sysver = [UIDevice currentDevice].systemVersion;
    NSString *sysName = nil;
    if (iPad) {
        sysName = @"iPad";
    }else{
        sysName = @"iPhone";
    }
    
    NSString *formatStr = [NSString stringWithFormat:@"youcai/%@ ios/%@ device/%@",version,sysver,sysName];
    return formatStr;

}


////////////////////////////////////////
+ (void)appInitSuccess:(void (^)(id response))success
                   failure:(void (^)(NSError *err))failure
{
    [HTTPManager requestWithMethod:RequestMethodTypeGet
                               url:@"/auth/init"
                         parameter:nil
                           success:success
                           failure:failure];
}

////////////////////////////////////////
+ (void)getCodeWithPhone:(NSString *)phone
                    type:(NSString *)type
                 success:(void (^)(id response))success
                 failure:(void (^)(NSError *err))failure
{
    NSDictionary *parameter = @{@"mobile":phone,XSRF:XSRFVALUE,@"type":type};
    [HTTPManager requestWithMethod:RequestMethodTypePost
                               url:@"/util/smscode"
                         parameter:parameter
                           success:success
                           failure:failure];
}


////////////////////////////////////////
+ (void)loginWithPhone:(NSString *)phone
                  code:(NSString *)code
                  type:(NSInteger)type
               success:(void (^)(id response))success
               failure:(void (^)(NSError *err))failure
{
    NSDictionary *parameter;
    if (type == 0) {
         parameter = @{@"mobile":phone,XSRF:XSRFVALUE,@"smscode":code};
    }else{
         parameter = @{@"mobile":phone,XSRF:XSRFVALUE,@"password":code};
    }
    

    [HTTPManager requestWithMethod:RequestMethodTypePost
                               url:@"/auth/login"
                         parameter:parameter
                           success:success
                           failure:failure];


}

////////////////////////////////////////
+ (void)zoneListWithLocation:(CLLocationCoordinate2D)location
                  success:(void (^)(id response))success
                  failure:(void (^)(NSError *err))failure
{
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
    [parameter setObject:@(location.longitude) forKey:@"lng"];
    [parameter setObject:@(location.latitude) forKey:@"lat"];
    
    [HTTPManager requestWithMethod:RequestMethodTypeGet
                               url:@"/zone/v2/list"
                         parameter:parameter
                           success:success
                           failure:failure];
}

////////////////////////////////////////
+ (void)cityListWithSuccess:(void (^)(id response))success
                   failure:(void (^)(NSError *err))failure
{
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
    [parameter setValue:@"1" forKey:@"group"];
    [parameter setValue:@"2" forKey:@"type"];
    
    [HTTPManager requestWithMethod:RequestMethodTypeGet
                               url:@"/util/region"
                         parameter:parameter
                           success:success
                           failure:failure];
}


////////////////////////////////////////
+ (void)regionListWithSuccess:(void (^)(id response))success
                      failure:(void (^)(NSError *err))failure
{
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
    [parameter setValue:@"1" forKey:@"pid"];
    [parameter setValue:@"1" forKey:@"group"];
    [parameter setValue:@"2" forKey:@"type"];
    
    [HTTPManager requestWithMethod:RequestMethodTypeGet
                               url:@"/util/region"
                         parameter:parameter
                           success:success
                           failure:failure];

}


////////////////////////////////////////
+ (void)searchCityWithCityId:(NSString *)cid
                     ksyword:(NSString *)keyword
                     success:(void (^)(id response))success
                     failure:(void (^)(NSError *err))failure
{
    NSDictionary *parameter = @{@"cid":cid,@"kw":keyword};
    [HTTPManager requestWithMethod:RequestMethodTypeGet
                               url:@"/zone/search"
                         parameter:parameter
                           success:success
                           failure:failure];
}

////////////////////////////////////////
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
                     failure:(void (^)(NSError *err))failure
{
    
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
    
    if (aid) {
        [parameter setValue:aid forKey:@"id"];
    }
    
    if (unit) {
        [parameter setValue:unit forKey:@"unit"];
    }
    
    [parameter setValue:name forKey:@"name"];
    [parameter setValue:mobile forKey:@"mobile"];
    [parameter setValue:city forKey:@"city"];
    if (region) {
        [parameter setValue:region forKey:@"region"];
    }
    if (street) {
        [parameter setValue:street forKey:@"street"];

    }
    [parameter setValue:zid forKey:@"zid"];
    [parameter setValue:zname forKey:@"zname"];
    [parameter setValue:building forKey:@"building"];
    [parameter setValue:unit forKey:@"unit"];
    [parameter setValue:room forKey:@"room"];
    [parameter setValue:XSRFVALUE forKey:XSRF];
    
    [HTTPManager requestWithMethod:RequestMethodTypePost
                               url:@"/user/address"
                         parameter:parameter
                           success:success
                           failure:failure];
    
}

////////////////////////////////////////
+ (void)getUserAddressWithSuccess:(void (^)(id response))success
                          failure:(void (^)(NSError *err))failure
{
    [HTTPManager requestWithMethod:RequestMethodTypeGet url:@"/user/address" parameter:nil success:success failure:failure];
}


////////////////////////////////////////
+ (void)comboWithLastid:(NSString *)lastid length:(NSInteger)length success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    //貌似参数废弃了
    NSDictionary *parameter = @{@"lastid":lastid,@"length":@(length)};
    
    [HTTPManager requestWithMethod:RequestMethodTypeGet
                               url:@"/cai/combo"
                         parameter:parameter
                           success:success
                           failure:failure];

}

////////////////////////////////////////
+ (void)comboInfoWithID:(NSString *)cid
                success:(void (^)(id response))success
                failure:(void (^)(NSError *err))failure
{
    NSDictionary *parameter = @{@"id":cid};
    
    [HTTPManager requestWithMethod:RequestMethodTypeGet url:@"/cai/combodtl" parameter:parameter success:success failure:failure];
}

////////////////////////////////////////
//comboItemList
+ (void)comboItemListWithId:(NSString *)cid
                    orderno:(NSString *)orderno
                       mode:(NSString *)mode
                    success:(void (^)(id response))success
                    failure:(void (^)(NSError *err))failure;
{
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];//@{@"combo_id":cid};
    if (cid) {
        [parameter setObject:cid forKey:@"combo_id"];
    }
    
    if (orderno) {
        [parameter setObject:orderno forKeyedSubscript:@"orderno"];
    }
    
    if (mode) {
        [parameter setObject:mode forKeyedSubscript:@"mode"];
    }
    
    [HTTPManager requestWithMethod:RequestMethodTypeGet url:@"/cai/itemlist" parameter:parameter success:success failure:failure];
}


////////////////////////////////////////
+ (void)getSlideWithSuccess:(void (^)(id response))success
                    failure:(void (^)(NSError *err))failure
{
    [HTTPManager requestWithMethod:RequestMethodTypeGet url:@"/cai/slide" parameter:nil success:success failure:failure];
}

////////////////////////////////////////
+ (void)updateWithSuccess:(void (^)(id response))success
                  failure:(void (^)(NSError *err))failure
{
    NSDictionary *parameter = @{@"apptype":@"5",@"platform":@"1"};
    [HTTPManager requestWithMethod:RequestMethodTypeGet url:@"/app/version" parameter:parameter success:success failure:failure];
}

////////////////////////////////////////
+ (void)orderListWithLastId:(NSString *)lastid
                       type:(NSString*)type
                    success:(void (^)(id response))success
                    failure:(void (^)(NSError *err))failure
{
    NSDictionary *parameter = @{@"lastid":lastid,@"length":@"20",@"type":type};
    [HTTPManager requestWithMethod:RequestMethodTypeGet url:@"/cai/order" parameter:parameter success:success failure:failure];
}


////////////////////////////////////////
+ (void)orderDetailWithOrderId:(NSString *)orderno
                       success:(void (^)(id response))success
                       failure:(void (^)(NSError *err))failure
{
    NSDictionary *parameter = @{@"orderno":orderno};
    
    [HTTPManager requestWithMethod:RequestMethodTypeGet url:@"/cai/v2/orderdtl" parameter:parameter success:success failure:failure];
}

////////////////////////////////////////
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
                       failure:(void (^)(NSError *err))failure
{
    
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
    [parameter setObject:type forKey:@"type"];
    [parameter setObject:name forKey:@"name"];
    [parameter setObject:mobile forKey:@"mobile"];
    [parameter setObject:address forKey:@"address"];
    
    if (extras) {
        [parameter setObject:extras forKey:@"extras"];
    }
    
    if (comboId) {
        [parameter setObject:comboId forKey:@"combo_id"];
    }
    
    if (items) {
        [parameter setObject:items forKey:@"items"];
    }
    
    if (comboIdx) {
        [parameter setObject:comboIdx forKey:@"combo_idx"];
    }
    
    
    //add
    if (couponid) {
        [parameter setObject:couponid forKey:@"coupon_id"];
    }
    //add
    if (spares) {
        [parameter setObject:spares forKey:@"spares"];
    }
    //add
    if (memo) {
        [parameter setObject:memo forKey:@"memo"];
    }
    
    if (paytype) {
        [parameter setObject:paytype forKey:@"paytype"];
    }
    
    if (addon) {
        [parameter setObject:addon forKey:@"addon"];
    }
    
    [parameter setObject:XSRFVALUE forKey:XSRF];
    
    DBLog(@"parameter===%@",parameter);
    
    [HTTPManager requestWithMethod:RequestMethodTypePost url:@"/cai/order" parameter:parameter success:success failure:failure];
    
}

////////////////////////////////////////
+ (void)payOrderWithOrderId:(NSString *)orderno
                   couponId:(NSString *)coupon_id
                    paytype:(NSString *)paytype
                    success:(void (^)(id response))success
                    failure:(void (^)(NSError *err))failure
{
    //NSDictionary *parameter = @{@"orderno":orderno,XSRF:XSRFVALUE,@"coupon_id":coupon_id};
    
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
    [parameter setValue:orderno forKey:@"orderno"];
    [parameter setValue:XSRFVALUE forKey:XSRF];
    
    if (coupon_id) {
        [parameter setValue:coupon_id forKey:@"coupon_id"];
    }
    
    if (paytype) {
        [parameter setValue:paytype forKey:@"paytype"];
    }
    
    [HTTPManager requestWithMethod:RequestMethodTypePost url:@"/cai/payorder" parameter:parameter success:success failure:failure];
}

////////////////////////////////////////
+ (void)delOrderWithId:(NSString *)orderid
               success:(void (^)(id response))success
               failure:(void (^)(NSError *err))failure
{
    NSDictionary *parameter = @{@"id":orderid,XSRF:XSRFVALUE};
    
    [HTTPManager requestWithMethod:RequestMethodTypePost url:@"/cai/delorder" parameter:parameter success:success failure:failure];
}


////////////////////////////////////////
+ (void)feedBackWithContent:(NSString *)content success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    NSDictionary *parameter = @{@"content":content,@"type":@"5",XSRF:XSRFVALUE};
    [HTTPManager requestWithMethod:RequestMethodTypePost url:@"/app/feedback" parameter:parameter success:success failure:failure];
}
+ (void)alterOrderWithOrderNo:(NSString *)orderNo
                        items:(NSString *)items
                       spares:(NSString *)spares
                        addon:(NSString *)addon
                         name:(NSString *)name
                       mobile:(NSString *)mobile
                      address:(NSString *)address
                         memo:(NSString *)memo
                      success:(void (^)(id response))success
                      failure:(void (^)(NSError *err))failure
{
//    NSDictionary *parameter = @{@"orderno":orderNo,XSRF:XSRFVALUE,@"items":items};
    
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
    [parameter setObject:orderNo forKey:@"orderno"];
    [parameter setObject:items forKey:@"items"];
    [parameter setObject:spares forKey:@"spares"];

    if (addon) {
        [parameter setObject:addon forKey:@"addon"];
    }
    
    if (memo) {
        [parameter setValue:memo forKey:@"memo"];
    }
    
    [parameter setObject:name forKey:@"name"];
    [parameter setObject:mobile forKey:@"mobile"];
    [parameter setObject:address forKey:@"address"];
    
    [parameter setObject:XSRFVALUE forKey:XSRF];
    
    
    [HTTPManager requestWithMethod:RequestMethodTypePost url:@"/cai/altorder" parameter:parameter success:success failure:failure];
}


////////////////////////////////////////
+ (void)logoutWithSuccess:(void (^)(id response))success
                  failure:(void (^)(NSError *err))failure
{
    [HTTPManager requestWithMethod:RequestMethodTypePost url:@"/auth/logout" parameter:@{XSRF:XSRFVALUE} success:success failure:failure];
}

////////////////////////////////////////
+ (void)caiHomeDataWithMode:(NSInteger)mode
        success:(void (^)(id response))success
        failure:(void (^)(NSError *err))failure;
{
    [HTTPManager requestWithMethod:RequestMethodTypeGet url:@"/v1/vegetables" parameter:@{@"length":@"10"} success:success failure:failure];
}

+ (void)showVeg:(NSString *)vid
        success:(void (^)(id response))success
        failure:(void (^)(NSError *err))failure
{
    NSString *url = [NSString stringWithFormat:@"/v1/vegetables/%@",vid];
    [HTTPManager requestWithMethod:RequestMethodTypeGet url:url parameter:nil success:success failure:failure];
}

+ (void) getVegs:(NSString *)lastid
         success:(void (^)(id response))success
         failure:(void (^)(NSError *err))failure
{
    if (lastid != nil) {
        [HTTPManager requestWithMethod:RequestMethodTypeGet url:@"/v1/vegetables" parameter:@{@"lastid":lastid,@"length":@"10"} success:success failure:failure];
    }else{
        [HTTPManager requestWithMethod:RequestMethodTypeGet url:@"/v1/vegetables" parameter:@{@"length":@"10"} success:success failure:failure];
    }
    
}

+ (void) getVegSlides:(void (^)(id response))success
         failure:(void (^)(NSError *err))failure
{
    [HTTPManager requestWithMethod:RequestMethodTypeGet url:@"/v1/vegetables/slides" parameter:nil success:success failure:failure];
}

+ (void) getEsps:(NSString *)lastid
         success:(void (^)(id response))success
         failure:(void (^)(NSError *err))failure
{
    if (lastid != nil) {
        [HTTPManager requestWithMethod:RequestMethodTypeGet url:@"/v1/specialties" parameter:@{@"lastid":lastid,@"length":@"10"} success:success failure:failure];
    }else{
        [HTTPManager requestWithMethod:RequestMethodTypeGet url:@"/v1/specialties" parameter:@{@"length":@"10"} success:success failure:failure];
    }
    
}

+ (void)showFrt:(NSString *)vid
        success:(void (^)(id response))success
        failure:(void (^)(NSError *err))failure
{
    NSString *url = [NSString stringWithFormat:@"/v1/fruits/%@",vid];
    [HTTPManager requestWithMethod:RequestMethodTypeGet url:url parameter:nil success:success failure:failure];
}


+ (void) getFrts:(NSString *)lastid
         success:(void (^)(id response))success
         failure:(void (^)(NSError *err))failure
{
    if (lastid != nil) {
        [HTTPManager requestWithMethod:RequestMethodTypeGet url:@"/v1/fruits" parameter:@{@"lastid":lastid,@"length":@"4"} success:success failure:failure];
    }else{
        [HTTPManager requestWithMethod:RequestMethodTypeGet url:@"/v1/fruits" parameter:@{@"length":@"4"} success:success failure:failure];
    }
    
}

+ (void) getFrtSlides:(void (^)(id response))success
              failure:(void (^)(NSError *err))failure
{
    [HTTPManager requestWithMethod:RequestMethodTypeGet url:@"/v1/fruits/slides" parameter:nil success:success failure:failure];
}

+ (void)showSpt:(NSString *)vid
        success:(void (^)(id response))success
        failure:(void (^)(NSError *err))failure
{
    NSString *url = [NSString stringWithFormat:@"/v1/specialties/%@",vid];
    [HTTPManager requestWithMethod:RequestMethodTypeGet url:url parameter:nil success:success failure:failure];
}



+ (void) getSpts:(NSString *)lastid
         success:(void (^)(id response))success
         failure:(void (^)(NSError *err))failure
{
    if (lastid != nil) {
        [HTTPManager requestWithMethod:RequestMethodTypeGet url:@"/v1/specialties" parameter:@{@"lastid":lastid,@"length":@"4"} success:success failure:failure];
    }else{
        [HTTPManager requestWithMethod:RequestMethodTypeGet url:@"/v1/specialties" parameter:@{@"length":@"4"} success:success failure:failure];
    }
    
}

+ (void) getSptSlides:(void (^)(id response))success
              failure:(void (^)(NSError *err))failure
{
    [HTTPManager requestWithMethod:RequestMethodTypeGet url:@"/v1/specialties/slides" parameter:nil success:success failure:failure];
}

+ (void)getZoneData:(void (^)(id response))success
                    failure:(void (^)(NSError *err))failure
{
    [HTTPManager requestWithMethod:RequestMethodTypeGet url:@"/v1/zones" parameter:nil success:success failure:failure];
}


////////////////////////////////////////
+ (void)caiDelayWithType:(NSInteger)type  // 1 get 2 post
                 orderNo:(NSString *)orderNo
                 success:(void (^)(id response))success
                 failure:(void (^)(NSError *err))failure
{
    if (type == 1) {
        [HTTPManager requestWithMethod:RequestMethodTypeGet url:@"/cai/delay" parameter:nil success:success failure:failure];
    }else{
        [HTTPManager requestWithMethod:RequestMethodTypePost url:@"/cai/delay" parameter:@{XSRF:XSRFVALUE,@"orderno":orderNo} success:success failure:failure];
    }
}


////////////////////////////////////////
+ (void)caiCouponWithType:(NSString *)type  //nil 列表 1 套餐 2 单品
                   lastid:(NSString *)lastId
                   usable:(NSString *)usable
                  success:(void (^)(id response))success
                  failure:(void (^)(NSError *err))failure;
{
    
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
    
    if (type) {
        [parameter setObject:type forKey:@"type"];
    }
    
    [parameter setObject:usable forKey:@"usable"];
    [parameter setObject:lastId forKey:@"lastid"];
    [parameter setObject:@"20" forKey:@"length"];
    
    [HTTPManager requestWithMethod:RequestMethodTypeGet url:@"/cai/coupon" parameter:parameter success:success failure:failure];
}


////////////////////////////////////////
+ (void)userAddressListWithSuccess:(void (^)(id response))success
                           failure:(void (^)(NSError *err))failure
{
    [HTTPManager requestWithMethod:RequestMethodTypeGet url:@"/user/v2/address" parameter:nil success:success failure:failure];
}

////////////////////////////////////////
+ (void)userAddressAddNewWithId:(NSInteger)aid
                           name:(NSString *)name
                         mobile:(NSString *)mobile
                            zid:(NSString *)zid
                          zname:(NSString *)zname
                            bur:(NSString *)bur
                        Success:(void (^)(id response))success
                        failure:(void (^)(NSError *err))failure
{
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
    
    if (aid) {
        [parameter setObject:STR(@(aid)) forKeyedSubscript:@"id"];
    }
    
    if (name) {
        [parameter setObject:name forKeyedSubscript:@"name"];
    }
    
    if (mobile) {
        [parameter setObject:mobile forKeyedSubscript:@"mobile"];
    }
    
    if (zid) {
        [parameter setObject:zid forKeyedSubscript:@"zid"];
    }
    
    if (zname) {
        [parameter setObject:zname forKeyedSubscript:@"zname"];
    }
    
    if (bur) {
        [parameter setObject:bur forKeyedSubscript:@"bur"];
    }
    
    [parameter setObject:XSRFVALUE forKeyedSubscript:XSRF];
    
    DBLog(@"parameter==%@",parameter);
    
    
    [HTTPManager requestWithMethod:RequestMethodTypePost url:@"/user/v2/address" parameter:parameter success:success failure:failure];
}

////////////////////////////////////////
+ (void)caiChooseWithOrderno:(NSString *)orderNo
                     success:(void (^)(id response))success
                     failure:(void (^)(NSError *err))failure
{
    [HTTPManager requestWithMethod:RequestMethodTypeGet url:@"/cai/choose" parameter:@{@"orderno":orderNo} success:success failure:failure];
    
}

////////////////////////////////////////
+ (void)createXPOrderWithOrderNo:(NSString *)orderno
                            items:(NSString *)items
                           spares:(NSString *)spares
                             memo:(NSString *)memo
                            addon:(NSString *)addon //2.2.0
                             name:(NSString *)name  //2.2.0
                           mobile:(NSString *)mobile//2.2.0
                          address:(NSString *)address//2.2.0
                          success:(void (^)(id response))success
                          failure:(void (^)(NSError *err))failure
{
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
    
    [parameter setObject:orderno forKey:@"orderno"];
    [parameter setObject:items forKey:@"items"];
    [parameter setObject:spares forKey:@"spares"];
    
    if (memo) {
        [parameter setObject:memo forKey:@"memo"];
    }
    
    if (addon) {
        [parameter setObject:addon forKey:@"addon"];
    }
    
    [parameter setObject:name forKey:@"name"];
    [parameter setObject:mobile forKey:@"mobile"];
    [parameter setObject:address forKeyedSubscript:@"address"];
    
    [parameter setObject:XSRFVALUE forKey:XSRF];
    
    [HTTPManager requestWithMethod:RequestMethodTypePost url:@"/cai/choose" parameter:parameter success:success failure:failure];
}

////////////////////////////////////////
+ (void)getCouponDataWithOrderNo:(NSString *)oderno
                         success:(void (^)(id response))success
                         failure:(void (^)(NSError *err))failure
{
    [HTTPManager requestWithMethod:RequestMethodTypePost url:@"/cai/coupon" parameter:@{@"orderno":oderno,XSRF:XSRFVALUE} success:success failure:failure];
}

////////////////////////////////////////
+ (void)caiMoreTcWithId:(NSString *)tid  //这个代表 start 开始数量，
                success:(void (^)(id response))success
                failure:(void (^)(NSError *err))failure
{
    //更改参数
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];//@{@"combo_id":cid};
    [parameter setObject:tid forKey:@"start"];
    [parameter setObject:@"20" forKey:@"length"];
    
    [HTTPManager requestWithMethod:RequestMethodTypeGet url:@"/cai/itemlist" parameter:parameter success:success failure:failure];
}

////////////////////////////////////////
+ (void)caiMyCombWithSuccess:(void (^)(id response))success
                     failure:(void (^)(NSError *err))failure
{
    [HTTPManager requestWithMethod:RequestMethodTypeGet url:@"/cai/mycombo" parameter:nil success:success failure:failure];
}

////////////////////////////////////////
+ (void)caiItemDetailWithCaiId:(NSString *)cid
                       success:(void (^)(id response))success
                       failure:(void (^)(NSError *err))failure
{
    [HTTPManager requestWithMethod:RequestMethodTypeGet url:@"/cai/itemdtl" parameter:@{@"id":cid} success:success failure:failure];
}


////////////////////////////////////////
+ (void)addV3AddressWithId:(NSString *)aid
                      name:(NSString *)name
                    mobile:(NSString *)mobile
                      city:(NSString *)city
                    region:(NSString *)region
                   address:(NSString *)address
                   success:(void (^)(id response))success
                   failure:(void (^)(NSError *err))failure
{
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
    
    if (aid) {
        [parameter setValue:aid forKey:@"id"];
    }
    
    
    [parameter setValue:name forKey:@"name"];
    [parameter setValue:mobile forKey:@"mobile"];
    [parameter setValue:city forKey:@"city"];
    [parameter setValue:region forKey:@"region"];
    
    [parameter setValue:address forKey:@"address"];
    [parameter setValue:XSRFVALUE forKey:XSRF];
    
    [HTTPManager requestWithMethod:RequestMethodTypePost
                               url:@"/user/v3/address"
                         parameter:parameter
                           success:success
                           failure:failure];

}

+ (void)addAddress:(NSString *)name
                   mobile:(NSString *)mobile
                   region:(NSString *)region
                   address:(NSString *)address
                   success:(void (^)(id response))success
                   failure:(void (^)(NSError *err))failure
{
    
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
    
    [parameter setValue:name forKey:@"name"];
    [parameter setValue:mobile forKey:@"mobile"];
    [parameter setValue:region forKey:@"region"];
    [parameter setValue:address forKey:@"address"];
    [parameter setValue:XSRFVALUE forKey:XSRF];
    
    [HTTPManager requestWithMethod:RequestMethodTypePost
                               url:@"/v1/addresses"
                         parameter:parameter
                           success:success
                           failure:failure];    
}

+ (void)getAddresses:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    [HTTPManager requestWithMethod:RequestMethodTypeGet
                               url:@"/v1/addresses"
                            parameter:nil
                           success:success
                           failure:failure];
    

}

+ (void)deleteAddress:(NSString *)addr_id
              success:(void (^)(id))success
              failure:(void (^)(NSError *))failure
{
    NSString *url = [NSString stringWithFormat:@"/v1/addresses/%@",addr_id];
    [HTTPManager requestWithMethod:RequestMethodTypeDelete
                               url:url
                         parameter:nil
                           success:success
                           failure:failure];
}
////////////////////////////////////////
+ (void)getUserV3AddressWithSuccess:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    [HTTPManager requestWithMethod:RequestMethodTypeGet
                               url:@"/user/v3/address"
                         parameter:nil
                           success:success
                           failure:failure];

}

////////////////////////////////////////
+ (void)changePassword:(NSString *)password
               smscode:(NSString *)smscode
               success:(void (^)(id response))success
               failure:(void (^)(NSError *err))failure
{
    [HTTPManager requestWithMethod:RequestMethodTypePost url:@"/user/chgpwd"
                         parameter:@{@"smscode":smscode,@"password":password,XSRF:XSRFVALUE}
                           success:success
                           failure:false];
}

////////////////////////////////////////
///delete user address
+ (void)deleteUserAddressWithId:(NSString *)aid
                        success:(void (^)(id response))success
                        failure:(void (^)(NSError *err))failure
{
    [HTTPManager requestWithMethod:RequestMethodTypePost url:@"/user/deladdr" parameter:@{@"id":aid,XSRF:XSRFVALUE} success:success failure:failure];
}

////////////////////////////////////////
////////////////////////////////////////
////////////////////////////////////////
////////////////////////////////////////
////////////////////////////////////////




@end

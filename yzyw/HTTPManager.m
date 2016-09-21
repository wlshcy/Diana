#import "HTTPManager.h"
#import "Lockbox.h"

static NSString *const BASE_URL = @"http://127.0.0.1:8888";

@implementation HTTPManager
+ (void)requestWithMethod:(RequestMethodType)methodType
                      url:(NSString *)url
                parameter:(NSDictionary *)parameter
                    token:(NSString *)token
                  success:(void (^)(id))success
                  failure:(void (^)(NSError *))failure
{
    AFHTTPRequestOperationManager* manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:BASE_URL]];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"text/plain",@"application/json",nil];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.requestSerializer.HTTPShouldHandleCookies = YES;
    [manager.requestSerializer setValue:[self userAgent] forHTTPHeaderField:@"User-Agent"];
    [manager.requestSerializer setValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"];
    [manager.requestSerializer setValue:[NSString stringWithFormat:@"%@", token] forHTTPHeaderField:@"X-Auth-Token"];
    
    manager.operationQueue.maxConcurrentOperationCount = 5;
    manager.requestSerializer.timeoutInterval = 10;
    
    
    switch (methodType) {
        case RequestMethodTypeGet:
        {
            //GET请求
            [manager GET:url parameters:parameter
                 success:^(AFHTTPRequestOperation* operation, NSDictionary* response) {
                     if (success) {
                         success(response);
                         
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
                  success:^(AFHTTPRequestOperation* operation, NSDictionary* response) {
                      if (success) {
                          success(response);
                          
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
                    success:^(AFHTTPRequestOperation* operation, NSDictionary* response) {
                        if (success) {
                            success(response);
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
    
    NSString *formatStr = [NSString stringWithFormat:@"yzyw/%@ ios/%@ device/%@",version,sysver,sysName];
    return formatStr;
    
}

+ (void) getItems:(NSString *)lastid

          success:(void (^)(id response))success
          failure:(void (^)(NSError *err))failure
{
    if (lastid != nil) {
        [HTTPManager requestWithMethod:RequestMethodTypeGet
                                   url:@"/v1/items"
                             parameter:@{@"lastid":lastid,@"length":@"10"}
                                 token:nil
                               success:success
                               failure:failure];
    }else{
        [HTTPManager requestWithMethod:RequestMethodTypeGet
                                   url:@"/v1/items"
                             parameter:@{@"length":@"10"}
                                 token:nil
                               success:success
                               failure:failure];
    }
    
}

+ (void)showItem:(NSString *)vid
        success:(void (^)(id response))success
        failure:(void (^)(NSError *err))failure
{
    NSString *url = [NSString stringWithFormat:@"/v1/items/%@",vid];
    [HTTPManager requestWithMethod:RequestMethodTypeGet
                               url:url
                         parameter:nil
                             token:nil
                           success:success
                           failure:failure];
}

+ (void) getOnsales:(void (^)(id response))success
              failure:(void (^)(NSError *err))failure
{
    [HTTPManager requestWithMethod:RequestMethodTypeGet
                               url:@"/v1/onsales"
                         parameter:nil
                             token:nil
                           success:success
                           failure:failure];
}

+ (void)getSMSCode:(NSString *)phone
                 success:(void (^)(id response))success
                 failure:(void (^)(NSError *err))failure
{
    NSDictionary *parameter = @{@"mobile":phone};
    [HTTPManager requestWithMethod:RequestMethodTypePost
                               url:@"/util/smscode"
                         parameter:parameter
                             token:nil
                           success:success
                           failure:failure];
}

+ (void)loginWithSMSCode:(NSString *)phone
                  code:(NSString *)code
               success:(void (^)(id response))success
               failure:(void (^)(NSError *err))failure
{
    
    NSDictionary *parameter;

    parameter = @{@"phone":phone,@"code":code};
    
    [HTTPManager requestWithMethod:RequestMethodTypePost
                               url:@"/v1/login"
                         parameter:parameter
                             token:nil
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
                             token:[Lockbox unarchiveObjectForKey:@"token"]
                           success:success
                           failure:failure];
}

+ (void)getAddresses:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    [HTTPManager requestWithMethod:RequestMethodTypeGet
                               url:@"/v1/addresses"
                         parameter:nil
                             token:[Lockbox unarchiveObjectForKey:@"token"]
                           success:success
                           failure:failure];
}

+ (void) getOrders:(NSString *)lastid
            length:(NSInteger)length
           success:(void (^)(id response))success
           failure:(void (^)(NSError *err))failure
{
    if (lastid != nil) {
        [HTTPManager requestWithMethod:RequestMethodTypeGet
                                   url:@"/v1/orders"
                             parameter:@{@"lastid":lastid,@"length":[NSString stringWithFormat:@"%ld", (long)length]}
                                 token:[Lockbox unarchiveObjectForKey:@"token"]
                               success:success
                               failure:failure];
    }else{
        [HTTPManager requestWithMethod:RequestMethodTypeGet
                                   url:@"/v1/orders"
                             parameter:@{@"length":[NSString stringWithFormat:@"%ld", (long)length]}
                                 token:[Lockbox unarchiveObjectForKey:@"token"]
                               success:success
                               failure:failure];
    }
    
}

+ (void)deleteAddress:(NSString *)addr_id
              success:(void (^)(id))success
              failure:(void (^)(NSError *))failure
{
    NSString *url = [NSString stringWithFormat:@"/v1/addresses/%@",addr_id];
    [HTTPManager requestWithMethod:RequestMethodTypeDelete
                               url:url
                         parameter:nil
                             token:[Lockbox unarchiveObjectForKey:@"token"]
                           success:success
                           failure:failure];
}

+ (void)defaultAddress:(NSString *)addr_id
               success:(void (^)(id))success
               failure:(void (^)(NSError *))failure
{
     NSString *url = [NSString stringWithFormat:@"/v1/addresses/%@/default",addr_id];
    [HTTPManager requestWithMethod:RequestMethodTypePost
                               url:url
                         parameter:nil
                             token:[Lockbox unarchiveObjectForKey:@"token"]
                           success:success
                           failure:failure];
}

+ (void)createOrder:(NSString *)name
             mobile:(NSString *)mobile
             region:(NSString *)region
            address:(NSString *)address
            paytype:(NSInteger)paytype
              items:(NSMutableArray *)items
            success:(void (^)(id response))success
            failure:(void (^)(NSError *err))failure
{
    
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
    
    [parameter setValue:name forKey:@"name"];
    [parameter setValue:mobile forKey:@"mobile"];
    [parameter setValue:region forKey:@"region"];
    [parameter setValue:address forKey:@"address"];
    [parameter setValue:items forKey:@"items"];
    [parameter setValue:XSRFVALUE forKey:XSRF];
    
    NSLog(@"%@", parameter);
    
    [HTTPManager requestWithMethod:RequestMethodTypePost
                               url:@"/v1/orders"
                         parameter:parameter
                             token:[Lockbox unarchiveObjectForKey:@"token"]
                           success:success
                           failure:failure];
}
@end

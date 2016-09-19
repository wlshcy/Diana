#import "HTTPManager.h"

static NSString *const BASE_URL = @"http://api.freshtaste.me:8080";

@implementation HTTPManager
+ (void)requestWithMethod:(RequestMethodType)methodType
                      url:(NSString *)url
                parameter:(NSDictionary *)parameter
                  success:(void (^)(id))success
                  failure:(void (^)(NSError *))failure
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
        [HTTPManager requestWithMethod:RequestMethodTypeGet url:@"/v1/items" parameter:@{@"lastid":lastid,@"length":@"10"} success:success failure:failure];
    }else{
        [HTTPManager requestWithMethod:RequestMethodTypeGet url:@"/v1/items" parameter:@{@"length":@"10"} success:success failure:failure];
    }
    
}

+ (void) getOnsales:(void (^)(id response))success
              failure:(void (^)(NSError *err))failure
{
    [HTTPManager requestWithMethod:RequestMethodTypeGet url:@"/v1/onsales" parameter:nil success:success failure:failure];
}

+ (void)getSMSCode:(NSString *)phone
                 success:(void (^)(id response))success
                 failure:(void (^)(NSError *err))failure
{
    NSDictionary *parameter = @{@"mobile":phone};
    [HTTPManager requestWithMethod:RequestMethodTypePost
                               url:@"/util/smscode"
                         parameter:parameter
                           success:success
                           failure:failure];
}

+ (void)loginWithSMSCode:(NSString *)phone
                  code:(NSString *)code
               success:(void (^)(id response))success
               failure:(void (^)(NSError *err))failure
{
    
    NSDictionary *parameter;

    parameter = @{@"mobile":phone,XSRF:XSRFVALUE,@"smscode":code};
    
    [HTTPManager requestWithMethod:RequestMethodTypePost
                               url:@"/auth/login"
                         parameter:parameter
                           success:success
                           failure:failure];
    
    
}

@end
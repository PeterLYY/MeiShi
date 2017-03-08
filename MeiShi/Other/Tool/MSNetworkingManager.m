//
//  MSNetworkingManager.m
//  MeiShi
//
//  Created by PeterLee on 2017/2/10.
//  Copyright © 2017年 PeterLee. All rights reserved.
//

#import "MSNetworkingManager.h"

@interface AFHTTPSessionManager (Shared)

+ (instancetype)sharedManager;

@end

@implementation AFHTTPSessionManager (Shared)

+ (instancetype)sharedManager {
    static AFHTTPSessionManager *_manager;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _manager = [AFHTTPSessionManager manager];
        _manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/plain", @"text/json", @"text/javascript", @"text/html", nil];
        //返回DATA类型
        _manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    });
    
    return _manager;
}

@end

@implementation MSNetworkingManager

+ (void)GET:(NSString *)URLString parameters:(id)parameters progress:(void (^)(NSProgress *downloadProgress))progress  success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager sharedManager];
    
    [manager GET:URLString parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        if (progress) {
            progress(downloadProgress);
        }
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (success) {
            failure(error);
        }
    }];
}

+ (void)POST:(NSString *)URLString parameters:(id)parameters progress:(void (^)(NSProgress *uploadProgress))progress success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager sharedManager];
    [manager.requestSerializer setValue:[self authorization] forHTTPHeaderField:@"Authorization"];
    [manager.requestSerializer setValue:[self cookie] forHTTPHeaderField:@"Cookie"];
    [manager POST:URLString parameters:[self params:parameters] progress:^(NSProgress * _Nonnull uploadProgress) {
        if (progress) {
            progress(uploadProgress);
        }
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (success) {
            failure(error);
        }
    }];
}

+ (NSString *)authorization {
    return @"Basic dG1wX3Nob3BfMTQ4NjY5NzAzODQ4NzlAbWVpc2hpamF1dG8uY29tOjczMDBmYzhjMjA5MWJjMzkzNTI1YzIwYmZlY2Q3Njc4";
}

+ (NSString *)cookie {
    return @"Hm_lvt_01dd6a7c493607e115255b7e72de5f40=1488251158,1488349301,1488777705,1488789312; UM_distinctid=15aa2c212101ad-02cb7a63381e4a8-20250c0d-2c600-15aa2c21211a8; MSCookieKey=78f75b4206e217502b35d6e557d5c08a.";
}

+ (id)params:(id)parameters {
    if ([parameters isKindOfClass:[NSDictionary class]]) {
        NSMutableDictionary *mutableParam = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"36.66589291821678",@"lat",@"117.0449348523378&",@"lon",@"iphone",@"source",@"json",@"format", nil];
        [mutableParam addEntriesFromDictionary:parameters];
        return mutableParam;
    }
    
    return parameters;
}


@end

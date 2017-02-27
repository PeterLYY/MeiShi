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
    
    [manager POST:URLString parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
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

@end

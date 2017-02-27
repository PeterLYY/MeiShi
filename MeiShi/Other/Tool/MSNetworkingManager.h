//
//  MSNetworkingManager.h
//  MeiShi
//
//  Created by PeterLee on 2017/2/10.
//  Copyright © 2017年 PeterLee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"


@interface MSNetworkingManager : NSObject

+ (void)GET:(NSString *)URLString parameters:(id)parameters progress:(void (^)(NSProgress *downloadProgress))progress  success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure;

+ (void)POST:(NSString *)URLString parameters:(id)parameters progress:(void (^)(NSProgress *uploadProgress))progress success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure;


@end

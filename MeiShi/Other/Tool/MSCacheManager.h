//
//  MSCacheManager.h
//  MeiShi
//
//  Created by PeterLee on 2017/2/10.
//  Copyright © 2017年 PeterLee. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MSCacheManager : NSObject

+ (BOOL)saveObject:(id)object byFileName:(NSString *)fileName;

+ (id)getObjectByFileName:(NSString *)fileName;

+ (void)removeObjectByFileName:(NSString *)fileName;

+ (void)saveUserInfo:(id)info forKey:(NSString *)key;

+ (id)getUserInfoForKey:(NSString *)key;

+ (void)removeUserInfoForKey:(NSString *)key;

@end

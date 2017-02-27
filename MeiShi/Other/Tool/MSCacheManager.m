//
//  MSCacheManager.m
//  MeiShi
//
//  Created by PeterLee on 2017/2/10.
//  Copyright © 2017年 PeterLee. All rights reserved.
//

#import "MSCacheManager.h"

@implementation MSCacheManager

//保存对象到归档文件
+ (BOOL)saveObject:(id)object byFileName:(NSString *)fileName {
    NSString *filePath = [self getFilePathByFileName:fileName];
    NSString *archiveFilePath = [filePath stringByAppendingString:@".archive"];
    return [NSKeyedArchiver archiveRootObject:object toFile:archiveFilePath];
}

//从归档文件中获取对象
+ (id)getObjectByFileName:(NSString *)fileName {
    NSString *filePath = [self getFilePathByFileName:fileName];
    return [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
}

//删除归档文件
+ (void)removeObjectByFileName:(NSString *)fileName {
    NSString *filePath = [self getFilePathByFileName:fileName];
    NSString *archiveFilePath = [filePath stringByAppendingString:@".archive"];
    [[NSFileManager defaultManager] removeItemAtPath:archiveFilePath error:nil];
}

//获取文件路径
+ (NSString *)getFilePathByFileName:(NSString *)fileName {
    NSString *cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *filePath = [cachePath stringByAppendingPathComponent:fileName];
    //判断文件是否存在
    if (![[NSFileManager defaultManager] fileExistsAtPath:filePath isDirectory:nil]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:filePath withIntermediateDirectories:NO attributes:nil error:nil];
    }
    return filePath;
}

//保存用户信息
+ (void)saveUserInfo:(id)info forKey:(NSString *)key {
    [[NSUserDefaults standardUserDefaults] setObject:info forKey:key];
}

//获取用户信息
+ (id)getUserInfoForKey:(NSString *)key {
    return [[NSUserDefaults standardUserDefaults] objectForKey:key];
}

//删除用户信息
+ (void)removeUserInfoForKey:(NSString *)key {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
}

@end

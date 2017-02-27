//
//  MSUtils.h
//  MeiShi
//
//  Created by PeterLee on 2017/2/10.
//  Copyright © 2017年 PeterLee. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MSUtils : NSObject

+ (NSString *)getDeviceTag;

+ (NSString *)getCurrentDeviceModel;

/**
 *  转化时间 时间戳转时间
 */
+ (NSString *)datestrFromDate:(NSDate *)date
               withDateFormat:(NSString *)format;

/**
 *  转化时间
 *  几天前，几分钟前
 */
+ (NSString *)updateTimeForTimeInterval:(NSInteger)timeInterval;

@end

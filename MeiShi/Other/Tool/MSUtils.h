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
+ (NSString *)datestrFromDate:(NSDate *)date
               withDateFormat:(NSString *)format;
+ (NSString *)updateTimeForTimeInterval:(NSInteger)timeInterval;
+ (UIImage *)createImageWithColor:(UIColor *)color Rect:(CGRect)rect;

+ (UIImage*)clipImageWithImage:(UIImage*)image inRect:(CGRect)rect;
+ (UIImage*)imageCompressImage:(UIImage *)sourceImage targetWidth:(CGFloat)defineWidth;

@end

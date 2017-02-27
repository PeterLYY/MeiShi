//
//  MSNavItemView.h
//  MeiShi
//
//  Created by PeterLee on 2017/2/17.
//  Copyright © 2017年 PeterLee. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^NavItemClickHandle)(NSUInteger index);

@interface MSNavItemView : UIScrollView

@property (nonatomic, copy) NSArray *items;
@property (nonatomic, copy) NavItemClickHandle clickHandle;
//默认选中项
@property (nonatomic, assign) NSInteger clickItemNum;

@end

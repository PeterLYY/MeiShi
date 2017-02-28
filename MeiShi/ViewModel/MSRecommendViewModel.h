//
//  MSRecommendViewModel.h
//  MeiShi
//
//  Created by PeterLee on 2017/2/14.
//  Copyright © 2017年 PeterLee. All rights reserved.
//

#import "MSViewModel.h"

@interface MSRecommendViewModel : MSViewModel

@property (nonatomic, strong) RACCommand *requestDataCommand;
@property (nonatomic, copy) NSDictionary *data;
@property (nonatomic, copy) NSDictionary *foodMaterialList;

@end

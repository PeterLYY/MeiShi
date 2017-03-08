//
//  MSRecipeDetailNewViewModel.h
//  MeiShi
//
//  Created by PeterLee on 2017/3/7.
//  Copyright © 2017年 PeterLee. All rights reserved.
//

#import "MSViewModel.h"

@interface MSRecipeDetailNewViewModel : MSViewModel

@property (nonatomic, copy) NSString *recipeId;
@property (nonatomic, copy) NSDictionary *recipeDetailNewData;
@property (nonatomic, strong) RACCommand *requestRecipeDetailNewData;

@end

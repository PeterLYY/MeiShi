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
@property (nonatomic, copy) NSDictionary *plListData;
@property (nonatomic, strong) RACCommand *requestPLListData;
@property (nonatomic, copy) NSDictionary *questionListData;
@property (nonatomic, strong) RACCommand *requestQuestionListData;
@property (nonatomic, copy) NSDictionary *recipeRecommendData;
@property (nonatomic, strong) RACCommand *requestRecipeRecommendData;
@property (nonatomic, copy) NSDictionary *goodsRecommendData;
@property (nonatomic, strong) RACCommand *requestGoodsRecommendData;

@end

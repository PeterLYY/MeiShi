//
//  MSRecipeDetailNewViewModel.m
//  MeiShi
//
//  Created by PeterLee on 2017/3/7.
//  Copyright © 2017年 PeterLee. All rights reserved.
//

#import "MSRecipeDetailNewViewModel.h"

@implementation MSRecipeDetailNewViewModel

- (void)initialize {
    [super initialize];
}

- (void)setRecipeId:(NSString *)recipeId {
    if (recipeId != nil) {
        //详情
        self.requestRecipeDetailNewData = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            RACSignal *signal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                NSDictionary *param = @{@"id":recipeId};
                [MSNetworkingManager POST:kMSRecipeDetailNew parameters:param progress:nil success:^(id responseObject) {
                    NSDictionary *data = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
                    if ([[data objectForKey:@"msg"] isEqualToString:@"成功"]) {
                        self.recipeDetailNewData = [data objectForKey:@"data"];
                        [subscriber sendNext:@"success"];
                    }
                } failure:^(NSError *error) {
                    
                }];
                [subscriber sendCompleted];
                return nil;
            }];
            return signal;
        }];
        //评论列表
        self.requestPLListData = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            RACSignal *signal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                NSDictionary *param = @{@"id":recipeId, @"type":@"1"};
                [MSNetworkingManager POST:kMSPLListNew2 parameters:param progress:nil success:^(id responseObject) {
                    NSDictionary *data = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
                    if ([[data objectForKey:@"msg"] isEqualToString:@"成功"]) {
                        self.plListData = [data objectForKey:@"data"];
                        [subscriber sendNext:@"success"];
                    }
                } failure:^(NSError *error) {
                    
                }];
                [subscriber sendCompleted];
                return nil;
            }];
            return signal;
        }];
        //问题
        self.requestQuestionListData = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            RACSignal *signal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                NSDictionary *param = @{@"id":recipeId, @"type":@"1"};
                [MSNetworkingManager POST:kMSQuestionList parameters:param progress:nil success:^(id responseObject) {
                    NSDictionary *data = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
                    if ([[data objectForKey:@"msg"] isEqualToString:@"成功"]) {
                        self.questionListData = [data objectForKey:@"data"];
                        [subscriber sendNext:@"success"];
                    }
                } failure:^(NSError *error) {
                    
                }];
                [subscriber sendCompleted];
                return nil;
            }];
            return signal;
        }];
        
        //商品推荐
        self.requestGoodsRecommendData = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            RACSignal *signal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                NSDictionary *params = @{@"pos":@"recipe_detail",@"id":recipeId};
                NSData *paramsData = [NSJSONSerialization dataWithJSONObject:params options:NSJSONWritingPrettyPrinted error:nil];
                NSString *paramsString = [[NSString alloc] initWithData:paramsData encoding:NSUTF8StringEncoding];
                NSDictionary *param = @{@"params":paramsString};
                [MSNetworkingManager POST:kMSGoodsRecommend parameters:param progress:nil success:^(id responseObject) {
                    NSDictionary *data = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
                    if ([[data objectForKey:@"msg"] isEqualToString:@"请求成功"]) {
                        self.goodsRecommendData = [data objectForKey:@"data"];
                        [subscriber sendNext:@"success"];
                    }
                } failure:^(NSError *error) {
                    
                }];
                [subscriber sendCompleted];
                return nil;
            }];
            return signal;
        }];
        
        //菜谱推荐
        self.requestRecipeRecommendData = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            RACSignal *signal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                NSDictionary *params = @{@"pos":@"recipe_detail",@"id":recipeId};
                NSData *paramsData = [NSJSONSerialization dataWithJSONObject:params options:NSJSONWritingPrettyPrinted error:nil];
                NSString *paramsString = [[NSString alloc] initWithData:paramsData encoding:NSUTF8StringEncoding];
                NSDictionary *param = @{@"params":paramsString};
                [MSNetworkingManager POST:kMSRecipeRecommend parameters:param progress:nil success:^(id responseObject) {
                    NSDictionary *data = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
                    if ([[data objectForKey:@"msg"] isEqualToString:@"请求成功"]) {
                        self.recipeRecommendData = [data objectForKey:@"data"];
                        [subscriber sendNext:@"success"];
                    }
                } failure:^(NSError *error) {
                    
                }];
                [subscriber sendCompleted];
                return nil;
            }];
            return signal;
        }];
        
    }
    _recipeId = recipeId;
}

@end

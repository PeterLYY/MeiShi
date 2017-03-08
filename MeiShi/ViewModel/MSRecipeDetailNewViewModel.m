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
        self.requestRecipeDetailNewData = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            RACSignal *signal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                NSDictionary *param = @{@"id":recipeId};
                [MSNetworkingManager POST:kMSRecipeDetailNew parameters:param progress:nil success:^(id responseObject) {
                    NSDictionary *data = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
                    if ([[data objectForKey:@"msg"] isEqualToString:@"成功"]) {
                        self.recipeDetailNewData = [data objectForKey:@"data"];
                    }
                } failure:^(NSError *error) {
                    NSLog(@"%@", error);
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

//
//  MSRecommendViewModel.m
//  MeiShi
//
//  Created by PeterLee on 2017/2/14.
//  Copyright © 2017年 PeterLee. All rights reserved.
//

#import "MSRecommendViewModel.h"

@interface MSRecommendViewModel()

@end

@implementation MSRecommendViewModel

- (void)initialize {
    [super initialize];
    //self.data = [NSMutableDictionary new]
    @weakify(self)
    self.requestDataCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        @strongify(self)
        return [self requestRecommendData];
    }];
}

- (RACSignal *)requestRecommendData {
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        [MSNetworkingManager GET:kMSRecommendApi parameters:nil progress:nil success:^(id responseObject) {
            NSError *error = nil;
            NSDictionary *xmlData = [XMLReader dictionaryForXMLData:responseObject error:&error];
            if ([[[[xmlData objectForKey:@"items"] objectForKey:@"msg"] objectForKey:@"text"] isEqualToString:@"成功"]) {
                self.data = [[xmlData objectForKey:@"items"] objectForKey:@"data"];
            }
            [subscriber sendCompleted];
        } failure:^(NSError *error) {
            [subscriber sendError:error];
        }];
        return nil;
    }];
}

@end

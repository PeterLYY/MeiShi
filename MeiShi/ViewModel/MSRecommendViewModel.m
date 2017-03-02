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
    
    self.sancanDataCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        @strongify(self)
        return [self requestSancanData];
    }];
    
    self.weatherDataCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        @strongify(self)
        return [self requestWeatherData];
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

- (RACSignal *)requestSancanData {
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        [MSNetworkingManager GET:kMSSancanApi parameters:nil progress:nil success:^(id responseObject) {
            NSError *error = nil;
            NSDictionary *xmlData = [XMLReader dictionaryForXMLData:responseObject error:&error];
            if ([[[[xmlData objectForKey:@"items"] objectForKey:@"msg"] objectForKey:@"text"] isEqualToString:@"成功"]) {
                self.sancanData = [[xmlData objectForKey:@"items"] objectForKey:@"data"];
            }
            [subscriber sendCompleted];
        } failure:^(NSError *error) {
            [subscriber sendError:error];
        }];
        return nil;
    }];
}

- (RACSignal *)requestWeatherData {
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        [MSNetworkingManager GET:kMSWeatherApi parameters:nil progress:nil success:^(id responseObject) {
            NSError *error = nil;
            NSDictionary *xmlData = [XMLReader dictionaryForXMLData:responseObject error:&error];
            if ([[[[xmlData objectForKey:@"items"] objectForKey:@"msg"] objectForKey:@"text"] isEqualToString:@"成功"]) {
                self.weatherData = [[xmlData objectForKey:@"items"] objectForKey:@"data"];
            }
            [subscriber sendCompleted];
        } failure:^(NSError *error) {
            [subscriber sendError:error];
        }];
        return nil;
    }];
}

//智能组菜
- (NSDictionary *)foodMaterialList {
    if (_foodMaterialList == nil) {
        NSMutableDictionary *foodMaterialList = [NSMutableDictionary new];
        NSString *filePath = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"foodMaterialList.txt"];
        NSData *jsonData = [NSData dataWithContentsOfFile:filePath];
        NSArray *foods = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:nil];
        [foods enumerateObjectsUsingBlock:^(NSDictionary *food, NSUInteger idx, BOOL * _Nonnull stop) {
            NSString *firstLetter = [food objectForKey:@"first_letter"];
            if ([foodMaterialList objectForKey:firstLetter] == nil) {
                NSMutableArray *array = [[NSMutableArray alloc] initWithArray:@[food]];
                [foodMaterialList setObject:array forKey:firstLetter];
            }else{
                [[foodMaterialList objectForKey:firstLetter] addObject:food];
            }
        }];
        _foodMaterialList = foodMaterialList;
        
    }
    return _foodMaterialList;
}

@end

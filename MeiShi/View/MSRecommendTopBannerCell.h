//
//  MSRecommendTopBannerCell.h
//  MeiShi
//
//  Created by PeterLee on 2017/2/20.
//  Copyright © 2017年 PeterLee. All rights reserved.
//

#import "MSTableViewCell.h"

typedef void (^ImageViewWithTapGetureHandle)(NSString *urlString);

@interface MSRecommendTopBannerCell : MSTableViewCell

@property (nonatomic, copy) NSArray *data;
@property (nonatomic, copy) ImageViewWithTapGetureHandle tapGetureHandle;

@end

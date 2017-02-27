//
//  MSScrollView.m
//  MeiShi
//
//  Created by PeterLee on 2017/2/27.
//  Copyright © 2017年 PeterLee. All rights reserved.
//

#import "MSScrollView.h"
#import "MSRecommendScrollView.h"
#import "MSRecommendTopBanner.h"

@interface MSScrollView()


@end

@implementation MSScrollView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

//- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
//    UIPanGestureRecognizer *pan = (UIPanGestureRecognizer *)gestureRecognizer;
//    CGPoint point = [pan translationInView:self];
//    UIGestureRecognizerState state = gestureRecognizer.state;
//    if (UIGestureRecognizerStateBegan == state || UIGestureRecognizerStatePossible == state) {
//        CGPoint location = [gestureRecognizer locationInView:self];
//        if([pan.delegate isMemberOfClass:[MSRecommendTopBanner class]]) {
//            
//        }
//        if (point.x > 0 && location.x < 10 && self.contentOffset.x <= 0) {
//            return YES;
//        }
//    }
//    return NO;
//}


//解决scrollview手势冲突
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    UIPanGestureRecognizer *pan = (UIPanGestureRecognizer *)gestureRecognizer;
    if ([pan.delegate isMemberOfClass:[MSRecommendTopBanner class]]){
        MSRecommendTopBanner *topbanner = (MSRecommendTopBanner *)pan.delegate;
        NSLog(@"%f-%f", topbanner.bounds.size.width, topbanner.bounds.size.height);
        return YES;
    }else if([pan.delegate isMemberOfClass:[MSRecommendScrollView class]]){
        MSRecommendScrollView *recommendScrollView = (MSRecommendScrollView *)pan.delegate;
        UITableView *tableview = (UITableView *)[[recommendScrollView.subviews objectAtIndex:0].subviews objectAtIndex:0];
        UITableViewCell *cell = [tableview cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        CGPoint location = [gestureRecognizer locationInView:self];
        CGPoint point = [self convertPoint:location toView:cell];
        if([cell pointInside:point withEvent:nil]) {
            return NO;
        }
        return YES;
    }
    
    return NO;
    
}


@end

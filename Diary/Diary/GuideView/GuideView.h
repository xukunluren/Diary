//
//  GuideView.h
//  Diary
//
//  Created by Hanser on 2/23/17.
//  Copyright © 2017 xukun. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GuideView;
@protocol GuideViewDelegate <NSObject>

- (void)GuideViewDelegate:(GuideView *)guideView;

@end

@interface GuideView : UIView

/** 存储动画用的图片*/
@property (strong, nonatomic) NSArray *imageArray;
@property (weak, nonatomic) id<GuideViewDelegate> delegate;

@end

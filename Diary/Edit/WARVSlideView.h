//
//  WARVSlideView.h
//  Diary
//
//  Created by xukun on 2017/3/23.
//  Copyright © 2017年 xukun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WARVSlideView : UIView
@property (nonatomic, strong) UILabel *textLabel;
@property (nonatomic, strong) UIImageView *arrowImageView;

- (void)updateLocation:(CGFloat)offsetX;

@end

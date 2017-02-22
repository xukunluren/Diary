//
//  UIView+UIView_Frame.m
//  Diary
//
//  Created by Hanser on 2/22/17.
//  Copyright © 2017 xukun. All rights reserved.
//

#import "UIView+Frame.h"

@implementation UIView (Frame)



+ (UIView *)drawBackLine:(CGRect)rect
                   color:(UIColor *)color
                 subView:(UIView *)subView {
    UIView *view = [[UIView alloc] initWithFrame:rect];
    view.backgroundColor = color;
    [subView addSubview:view];
    return view;
}

+ (UIView *)drawLine:(CGRect)rect
           color:(UIColor *)color
         subView:(UIView *)subView {
    return [self drawBackLine:rect color:color subView:subView];
}

@end

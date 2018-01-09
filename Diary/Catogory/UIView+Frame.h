//
//  UIView+UIView_Frame.h
//  Diary
//
//  Created by Hanser on 2/22/17.
//  Copyright © 2017 xukun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Frame)

/**  画线  **/
+ (UIView *)drawLine:(CGRect)rect
           color:(UIColor *)color
         subView:(UIView *)subView;

@end

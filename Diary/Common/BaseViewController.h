//
//  BaseViewController.h
//  Diary
//
//  Created by xukun on 2017/1/13.
//  Copyright © 2017年 xukun. All rights reserved.士大夫撒
//

#import <UIKit/UIKit.h>

@interface BaseViewController : UIViewController

-(void)setBack;
//设置导航条是否透明
-(void)setNavigtionBarTransparent:(BOOL)_transparent;
-(void)goBack;
-(UIView *)drawThreadWithFram:(CGRect)rect andColor:(UIColor *)color;
@end

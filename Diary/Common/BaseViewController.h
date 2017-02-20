//
//  BaseViewController.h
//  Diary
//
//  Created by xukun on 2017/1/13.
//  Copyright © 2017年 xukun. All rights reserved.士大夫撒
//

#import <UIKit/UIKit.h>

@interface BaseViewController : UIViewController
//返回上级页面分别以图标和文字两种样式
-(void)setBackWithImage;
-(void)setBackWithText:(NSString*)text;
//导航条右侧按钮设置文字或者图标
-(void)setRightWithImage;
-(void)setRightWithText:(NSString*)text;
//设置导航条是否透明
-(void)setNavigtionBarTransparent:(BOOL)_transparent;
-(void)goBack;
-(UIView *)drawThreadWithFram:(CGRect)rect andColor:(UIColor *)color;

-(void)showToastWithString:(NSString*)title;
@end

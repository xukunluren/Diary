//
//  BaseViewController.h
//  Diary
//
//  Created by xukun on 2017/1/13.
//  Copyright © 2017年 xukun. All rights reserved.士大夫撒
//

#import <UIKit/UIKit.h>



typedef enum
{
    //以下是枚举成员
    WeatherEqingtian = 0,
    WeatherEduoyun = 1,
    WeatherEfeng = 2,
    WeatherExiaoyu = 3,
    WeatherEdayu = 4,
    WeatherEshandian = 5,
    WeatherExue = 6,
    WeatherEwumai = 7,
    WeatherENoSelect = 8,
    
}WeatherType;//枚举名称


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
-(NSString *)UIImageToBase64Str:(UIImage *)image;
//字符串转图片
-(UIImage *)Base64StrToUIImage:(NSString *)_encodedImageStr;
-(void)showToastWithString:(NSString*)title;
@end

//
//  ConstDefine.h
//  SimpleCostWithOC
//
//  Created by joe on 2016/12/8.
//  Copyright © 2016年 joe. All rights reserved.
//

/** 定义常量 */
#ifndef ConstDefine_h
#define ConstDefine_h

#define kMainScreenBounds [UIScreen mainScreen].bounds
#define kScreenWidth kMainScreenBounds.size.width
#define kScreenHeight kMainScreenBounds.size.height
#define kNavigationBarHeight 64
#define kTabBarHeight 49
#define kTabBarBackgroundColor [UIColor colorWithHexString:@"#60C2EB"]
#define kTabBarTitleColor [UIColor colorWithHexString:@"#808284"]
//基本信息获取
#define ScreenHeight [[UIScreen mainScreen] bounds].size.height
#define ScreenWidth [[UIScreen mainScreen] bounds].size.width
//导航条高度
#define KNaviBarHeight self.navigationController.navigationBar.height
//底部tab高度
#define KTabBarHeight self.tabBarController.tabBar.height
//电池状态栏高度
#define KStustus [[UIApplication sharedApplication] statusBarFrame].size.height
//顶部总高度
#define KTopHeight self.navigationController.navigationBar.height+[[UIApplication sharedApplication] statusBarFrame].size.height

/** 动态计算textview的高度 */
#define VD_MULTILINE_TEXTSIZE(text, font, maxSize, mode) [text length] > 0 ? [text \
boundingRectWithSize:maxSize options:(NSStringDrawingUsesLineFragmentOrigin) \
attributes:@{NSFontAttributeName:font} context:nil].size : CGSizeZero;




#endif /* ConstDefine_h */

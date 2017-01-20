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
#define KNaviBarHeight self.navigationController.navigationBar.height
#define KTabBarHeight self.tabBarController.tabBar.height

/** 动态计算textview的高度 */
#define VD_MULTILINE_TEXTSIZE(text, font, maxSize, mode) [text length] > 0 ? [text \
boundingRectWithSize:maxSize options:(NSStringDrawingUsesLineFragmentOrigin) \
attributes:@{NSFontAttributeName:font} context:nil].size : CGSizeZero;


#endif /* ConstDefine_h */

//
//  CustomPageControl.h
//  Diary
//
//  Created by Hanser on 2/24/17.
//  Copyright © 2017 xukun. All rights reserved.
//

#import <UIKit/UIKit.h>

#define PAGECONTROL_BACKGROUND_HEIGHT 35
#define PAGECONTROL_HEIGHT 2           //自定义单个光标的高度
#define PAGECONTROL_WIDTH 15           //自定义单个光标的宽度
#define PAGECONTROL_SPACE 14           //光标之间的间隙
#define PAGECONTROL_TAG 10000


@interface CustomPageControl : UIView

- (instancetype)initWithFrame:(CGRect)frame pageCount:(NSInteger)count;
/*
 *        @param  选中的光标的编号
 */
- (void)changePageControlColor:(NSInteger)index;
@end

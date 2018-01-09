//
//  CustomPageControl.m
//  Diary
//
//  Created by Hanser on 2/24/17.
//  Copyright © 2017 xukun. All rights reserved.
//

#import "CustomPageControl.h"

#define PAGECONTROL_BACKGROUND_HEIGHT 35
#define PAGECONTROL_HEIGHT 2           //自定义单个光标的高度
#define PAGECONTROL_WIDTH 15           //自定义单个光标的宽度
#define PAGECONTROL_SPACE 14           //光标之间的间隙
#define PAGECONTROL_TAG 10000

#define SELECTED_COLOR [UIColor colorFromHexCode:@"#12B7F5"]
#define NOT_SELECTED_COLOR [UIColor colorFromHexCode:@"#FFFFFF"]

@interface CustomPageControl() {
    NSInteger _pageCount;
    UIView *_lastSelectedView;
}

@end

@implementation CustomPageControl

- (instancetype)initWithFrame:(CGRect)frame pageCount:(NSInteger)count {
    self = [super initWithFrame:frame];
    if (self) {
        _pageCount = count;
        [self initPageControl];
        
    }
    return self;
}


- (void)initPageControl {
    for (NSInteger i=0; i<_pageCount; i++) {
        UIView *pageView = [[UIView alloc] init];
        pageView.frame = CGRectMake(i*(PAGECONTROL_SPACE+PAGECONTROL_WIDTH), 0, PAGECONTROL_WIDTH, PAGECONTROL_HEIGHT);
        pageView.tag = PAGECONTROL_TAG + i;
        if (i==0) {
            pageView.backgroundColor = SELECTED_COLOR;
            _lastSelectedView = pageView;
        }else {
            pageView.backgroundColor = NOT_SELECTED_COLOR;
        }
        [self addSubview:pageView];
    }
}

#pragma mark -----------------------------------------------------
#pragma mark - 变化光标颜色
- (void)changePageControlColor:(NSInteger)index {
    if (index > _pageCount || index == _pageCount) {
        NSLog(@"page编号出错");
        return;
    }
    
    if (index == (_lastSelectedView.tag - PAGECONTROL_TAG)) {
        return;
    }
    
    UIView *selectView = [self viewWithTag:PAGECONTROL_TAG + index];
    selectView.backgroundColor = SELECTED_COLOR;
    _lastSelectedView.backgroundColor = NOT_SELECTED_COLOR;
    _lastSelectedView = selectView;
}








@end

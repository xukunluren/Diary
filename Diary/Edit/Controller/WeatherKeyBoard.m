//
//  WeatherKeyBoard.m
//  Diary
//
//  Created by xukun on 2017/2/9.
//  Copyright © 2017年 xukun. All rights reserved.
//

#import "WeatherKeyBoard.h"

@implementation WeatherKeyBoard

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor clearColor]];
    }
    return self;
}
@end

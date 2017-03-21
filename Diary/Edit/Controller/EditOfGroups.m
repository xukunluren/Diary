//
//  EditOfGroups.m
//  Diary
//
//  Created by xukun on 2017/2/9.
//  Copyright © 2017年 xukun. All rights reserved.
//

#import "EditOfGroups.h"

@implementation EditOfGroups



- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self setView];
    }
    return self;
}

-(void)setView{
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 8, 16, 16)];
    imageView.image = [UIImage imageNamed:@"rijiben"];
    [self addSubview:imageView];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(25, 5, 55, 20)];
    [label setText:@"当前分组:"];
    [label setTextColor:[UIColor colorWithHexString:@"12B7F5"]];
    [label setFont:[UIFont systemFontOfSize:12.0]];
    [self addSubview:label];
    
    _groupLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 5, ScreenWidth - 94, 20)];
    [_groupLabel setText:@"我的日记"];
    [_groupLabel setTextColor:[UIColor colorWithHexString:@"12B7F5"]];
    _groupLabel.textAlignment = NSTextAlignmentLeft;
    [_groupLabel setFont:[UIFont systemFontOfSize:12.0]];
    [self addSubview:_groupLabel];
    
    UIImageView *imageView1 = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth-25, 10, 13, 13)];
    imageView1.image = [UIImage imageNamed:@"right"];
    [self addSubview:imageView1];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(2, 34, ScreenWidth-10, 0.5)];
    view.backgroundColor = [UIColor colorWithHexString:@"e7e7e7"];
    [self addSubview:view];
    
//    UIButton *button = [[UIButton alloc] initWithFrame:self.bounds];
//    [button addTarget:self action:@selector(editorTouch) forControlEvents:UIControlEventTouchUpInside];
//    button.alpha = 0.0;	
//    [self addSubview:button];
    
    

}

-(void)editorTouch{
    NSLog(@"点击跳转");
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

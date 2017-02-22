//
//  audioImage.m
//  Diary
//
//  Created by xukun on 2017/2/6.
//  Copyright © 2017年 xukun. All rights reserved.
//

#import "audioImage.h"

@implementation audioImage

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor clearColor]];
    }
    return self;
}

- (void)builderViewWithSceond:(NSTimeInterval)second
{
    NSInteger time = second;
    CGFloat ViewWith = 300;
    CGFloat with = time/10+1;
    if (with>10) {
        ViewWith = 200 ;
    }else{
        ViewWith = ViewWith*with;
    }
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(10, 0, 200, 30)];
    backView.layer.cornerRadius = 2.0;
    [backView setBackgroundColor:[UIColor blackColor]];
    backView.alpha = 0.7;
    [self addSubview:backView];
    
    UIImageView *audioImage = [[UIImageView alloc] initWithFrame:CGRectMake(4, 5, 21, 20)];
    audioImage.image = [UIImage imageNamed:@"audioImage"];
    [backView addSubview:audioImage];
    
    UILabel *timelable = [[UILabel alloc] initWithFrame:CGRectMake(backView.frame.size.width-35, 0, 30, 30)];
    [timelable setText:[NSString stringWithFormat:@"%ld‘’",(long)time]];
    [timelable setTextColor:[UIColor whiteColor]];
    //[timelable setFont:[UIFont fontWithName:@"Helvetica-Bold" size:12.0]];
    [timelable setFont:[UIFont boldSystemFontOfSize:12.0]];
    [backView addSubview:timelable];
    
    //为录音添加点击事件
    UIButton *audioButton = [[UIButton alloc] initWithFrame:self.bounds];
    audioButton.alpha = 0.0;
    [audioButton setBackgroundColor:[UIColor clearColor]];
    [audioButton addTarget:self action:@selector(audioTouch) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:audioButton];
    
}
-(void)audioTouch{
    NSLog(@"录音点击事件");
    
}

 


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

//
//  videoView.m
//  Diary
//
//  Created by xukun on 2017/2/13.
//  Copyright © 2017年 xukun. All rights reserved.
//

#import "videoView.h"

@implementation videoView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //[self setBackgroundColor:[UIColor redColor]];
    }
    return self;
}


-(void)builderWithImage:(UIImage *)image{
    UIImageView *imageview = [[UIImageView alloc] initWithFrame:self.bounds];
    imageview.image = image;
    imageview.contentMode = UIViewContentModeScaleToFill;
    [self addSubview:imageview];
    
    UIView *backView = [[UIView alloc] initWithFrame:self.bounds];
    [backView setBackgroundColor:[UIColor blackColor]];
    backView.alpha = 0.5;
    [self addSubview:backView];
    
    //为录音添加点击事件
    UIButton *videoButton = [[UIButton alloc] initWithFrame:self.bounds];
    videoButton.alpha = 0.0;
    [videoButton setBackgroundColor:[UIColor clearColor]];
    [videoButton addTarget:self action:@selector(videoTouch) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:videoButton];
    
    
    
    UIImageView *playImage = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth*0.5-16, self.frame.size.height*0.5-16, 32, 32)];
    playImage.image = [UIImage imageNamed:@"playVideo"];
    [backView addSubview:playImage];
    
    
}

-(void)videoTouch{
    NSLog(@"播放");
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

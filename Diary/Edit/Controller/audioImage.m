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
    _secondTime = second;
    
    CGFloat ViewWith = 100;
    ViewWith = ViewWith+_secondTime*3;
    
       _backView = [[UIView alloc] initWithFrame:CGRectMake(10, 0, ViewWith, 30)];
    _backView.layer.cornerRadius = 2.0;
    [_backView setBackgroundColor:[UIColor blackColor]];
    _backView.alpha = 0.7;
    [self addSubview:_backView];
    

    
    _audioBtn = [[UIButton alloc] initWithFrame:CGRectMake(4, 5, 21, 20)];
    [_audioBtn setImage:[UIImage imageNamed:@"audio_icon_3"] forState:UIControlStateNormal];
    _audioBtn.userInteractionEnabled = YES;
    [_audioBtn addSubview:self.animationview];
    [_backView addSubview:_audioBtn];
    
    UILabel *timelable = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_backView.frame)+5, 5, 30, 20)];
    
    [timelable setText:[NSString stringWithFormat:@"%ld''",(long)_secondTime]];
//    [timelable setTextColor:[UIColor blueColor]];
    [timelable setTextColor:[UIColor grayColor]];
    [timelable setFont:[UIFont systemFontOfSize:12.0]];
//    [timelable setFont:[UIFont boldSystemFontOfSize:15.0]];
    [self addSubview:timelable];
    
    
}


//动画的imageview
- (UIImageView *)animationview{
    if (!_animationview) {
        _animationview = [[UIImageView alloc] initWithFrame:_audioBtn.bounds];
        NSArray *myImages = [NSArray arrayWithObjects: [UIImage imageNamed:@"audio_icon_3"],[UIImage imageNamed:@"audio_icon_1"],[UIImage imageNamed:@"audio_icon_2"],[UIImage imageNamed:@"audio_icon_3"],nil];
        
        _animationview.animationImages = myImages;
        _animationview.animationDuration = 1;
        _animationview.animationRepeatCount = 0; //动画重复次数，0表示无限循环
  
    }
    return _animationview;
}


-(void)audioTapEvent{
    NSLog(@"录音点击事件");
    
    _time = [NSTimer scheduledTimerWithTimeInterval:_secondTime target:self selector:@selector(stop) userInfo:nil repeats:NO];
    //点击播放按钮时，动画开始
    [self.animationview startAnimating];
    [self.audioBtn setImage:nil forState:UIControlStateNormal];
    
}


-(void)stop{
    [_time invalidate];
    [self.animationview stopAnimating];
    [self.audioBtn setImage:[UIImage imageNamed:@"audio_icon_3"] forState:UIControlStateNormal];
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

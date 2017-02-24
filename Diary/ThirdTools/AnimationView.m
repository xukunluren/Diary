//
//  AnimationView.m
//  Test
//
//  Created by 路准晴 on 16/11/8.
//  Copyright © 2016年 luzhunqing. All rights reserved.
//

#import "AnimationView.h"
#import <UIKit/UIKit.h>

@implementation AnimationView

-(void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    NSInteger pulsingCount = 8;
    double animationDuration = 5;
    CALayer * animationLayer = [CALayer layer];
    for (int i = 0; i < pulsingCount; i++)
    {
        CALayer * pulsingLayer = [CALayer layer];
        pulsingLayer.frame = CGRectMake(0, 0, rect.size.width, rect.size.height);
        float red = arc4random()%255 + 1;
        float green = arc4random()%255 +1;
        float blue = arc4random()%255 +1;
        pulsingLayer.borderColor = [[UIColor colorWithRed:red/255.0 green:green/255.0 blue:blue/255.0 alpha:1] CGColor];
        pulsingLayer.borderWidth = 1;
        pulsingLayer.cornerRadius = rect.size.height / 2;
        
        CAMediaTimingFunction * defaultCurve = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
        
        CAAnimationGroup * animationGroup = [CAAnimationGroup animation];
        animationGroup.fillMode = kCAFillModeBackwards;
        animationGroup.beginTime = CACurrentMediaTime() + (double)i * animationDuration / (double)pulsingCount;
        animationGroup.duration = animationDuration;
        animationGroup.repeatCount = HUGE;
        animationGroup.timingFunction = defaultCurve;
        
        CABasicAnimation * scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
        scaleAnimation.fromValue = @1.0;
        scaleAnimation.toValue = @2.2;
        
        CAKeyframeAnimation * opacityAnimation = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
        opacityAnimation.values = @[@1, @0.9, @0.8, @0.7, @0.6, @0.5, @0.4, @0.3, @0.2, @0.1, @0];
        opacityAnimation.keyTimes = @[@0, @0.1, @0.2, @0.3, @0.4, @0.5, @0.6, @0.7, @0.8, @0.9, @1];
        
        animationGroup.animations = @[scaleAnimation, opacityAnimation];
        [pulsingLayer addAnimation:animationGroup forKey:@"plulsing"];
        [animationLayer addSublayer:pulsingLayer];
    }
    [self.layer addSublayer:animationLayer];
    
    
}

@end

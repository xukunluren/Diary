//
//  WMFPSLabel.m
//  WeiKe
//
//  Created by js on 16/8/3.
//  Copyright © 2016年 WeiMob. All rights reserved.
//

#import "WMFPSLabel.h"

@interface WMFPSLabel ()
@property (nonatomic, strong) CADisplayLink *displayLink;
@property (nonatomic, assign) NSTimeInterval lastTime;
@property (nonatomic, assign) NSInteger count;
@end

@implementation WMFPSLabel

- (void)dealloc{
    [self.displayLink invalidate];
}

- (void)didMoveToSuperview{
    [super didMoveToSuperview];
    [self run];
}

- (void)run {
    [self.displayLink invalidate];
    self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(tick:)];
    [self.displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
}


- (void)tick:(id) sender {
    
    if (self.lastTime == 0) {
        self.lastTime = self.displayLink.timestamp;
        return;
    }
    
    self.count += 1;
    
    NSTimeInterval timeDelta = self.displayLink.timestamp - self.lastTime;
    
    if (timeDelta < 0.25) {
        return;
    }
    
    self.lastTime = self.displayLink.timestamp;
    
    double fps = self.count * 1.0 / timeDelta;
    
    self.count = 0;
    
    self.text = [NSString stringWithFormat:@"fps: %.0f",fps];
}

@end

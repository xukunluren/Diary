//
//  ZFJWaveView.h
//  JSWaveDemo1
//
//  Created by ZFJ on 2017/1/3.
//  Copyright © 2017年 我要学. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^JSWaveBlock)(CGFloat currentY);

@interface ZFJWaveView : UIView

//浪弯曲度
@property (nonatomic, assign) CGFloat waveCurvature;
//浪速
@property (nonatomic, assign) CGFloat waveSpeed;
//浪高
@property (nonatomic, assign) CGFloat waveHeight;
//实浪颜色
@property (nonatomic, strong) UIColor *realWaveColor;
//遮罩浪颜色
@property (nonatomic, strong) UIColor *maskWaveColor;

@property (nonatomic, copy) JSWaveBlock waveBlock;

- (void)stopWaveAnimation;

- (void)startWaveAnimation;

@end

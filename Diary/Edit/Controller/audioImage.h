//
//  audioImage.h
//  Diary
//
//  Created by xukun on 2017/2/6.
//  Copyright © 2017年 xukun. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface audioImage : UIView

-(void)builderViewWithSceond:(NSTimeInterval)second;
-(void)audioTapEvent;
@property (nonatomic,strong) UIView *backView;
@property (nonatomic,strong) NSTimer *time;
@property (nonatomic,assign) long secondTime;

@property (nonatomic,strong) UIButton *audioBtn;

@property (nonatomic,strong) UIImageView *animationview;

@end

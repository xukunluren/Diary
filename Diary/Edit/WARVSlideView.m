//
//  WARVSlideView.m
//  Diary
//
//  Created by xukun on 2017/3/23.
//  Copyright © 2017年 xukun. All rights reserved.
//

#import "WARVSlideView.h"
#import <CoreText/CoreText.h>
#import "FBShimmeringView.h"

@implementation WARVSlideView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        [self createSubViews];
    }
    
    return self;
}

- (void)createSubViews
{
    self.clipsToBounds = YES;
    
    UILabel *label = [[UILabel alloc] initWithFrame:self.bounds];
    label.text = @"滑动删除";
    label.font = [UIFont systemFontOfSize:13.0f];
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = [UIColor clearColor];
    [self addSubview:label];
    self.textLabel = label;
    
    UIImageView *bkimageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"SlideArrow"]];
    CGRect frame = bkimageView.frame;
    frame.origin.x = self.frame.size.width / 2.0 + 33;
    frame.origin.y += 5;
    [bkimageView setFrame:frame];
    [self addSubview:bkimageView];
    self.arrowImageView = bkimageView;
}

- (void)updateLocation:(CGFloat)offsetX
{
    CGRect labelFrame = self.textLabel.frame;
    labelFrame.origin.x += offsetX;
    self.textLabel.frame = labelFrame;
    
    CGRect imageFrame = self.arrowImageView.frame;
    imageFrame.origin.x += offsetX;
    self.arrowImageView.frame = imageFrame;
}


@end

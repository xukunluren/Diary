//
//  WARVGarbageView.m
//  Diary
//
//  Created by xukun on 2017/3/23.
//  Copyright © 2017年 xukun. All rights reserved.
//

#import "WARVGarbageView.h"

@implementation WARVGarbageView

#define kFloatRecordImageUpTime (0.5f)
#define kFloatRecordImageRotateTime (0.17f)
#define kFloatRecordImageDownTime (0.5f)
#define kFloatGarbageAnimationTime (.3f)
#define kFloatGarbageBeginY (45.0f)
#define kFloatCancelRecordingOffsetX  (100.0f)

void setViewFixedAnchorPoint(CGPoint anchorPoint, UIView *view)
{
    CGPoint newPoint = CGPointMake(view.bounds.size.width * anchorPoint.x, view.bounds.size.height * anchorPoint.y);
    CGPoint oldPoint = CGPointMake(view.bounds.size.width * view.layer.anchorPoint.x, view.bounds.size.height * view.layer.anchorPoint.y);
    
    newPoint = CGPointApplyAffineTransform(newPoint, view.transform);
    oldPoint = CGPointApplyAffineTransform(oldPoint, view.transform);
    
    CGPoint position = view.layer.position;
    
    position.x -= oldPoint.x;
    position.x += newPoint.x;
    
    position.y -= oldPoint.y;
    position.y += newPoint.y;
    
    view.layer.position = position;
    view.layer.anchorPoint = anchorPoint;
}


- (instancetype)init
{
    self = [super initWithFrame:CGRectMake(0, 0, 18, 26)];
    if (self) {
        self.bodyView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"BucketBodyTemplate"]];
        self.headerView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"BucketLidTemplate"]];
        CGRect frame = self.bodyView.frame;
        frame.origin.y = 1;
        [self.bodyView setFrame:frame];
        [self addSubview:self.headerView];
        setViewFixedAnchorPoint(CGPointMake(0, 1), self.headerView);
        [self addSubview:self.bodyView];
    }
    return self;
}

@end

 

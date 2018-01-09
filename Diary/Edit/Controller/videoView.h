//
//  videoView.h
//  Diary
//
//  Created by xukun on 2017/2/13.
//  Copyright © 2017年 xukun. All rights reserved.
//

#import "BaseView.h"

@interface videoView : BaseView

@property(nonatomic,strong) NSURL *url;

-(void)builderWithImage:(UIImage *)image;
@end

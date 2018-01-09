//
//  tansuoBottomButton.m
//  Diary
//
//  Created by xukun on 2017/1/19.
//  Copyright © 2017年 xukun. All rights reserved.
//

#import "tansuoBottomButton.h"

@implementation tansuoBottomButton

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initView];
    }
    return self;
}


-(void)initView{
    _imageview = [[UIImageView alloc] initWithFrame:CGRectMake(self.frame.size.width*0.5-27, 14, 24, 24)];
//    _imageview.image = [UIImage imageNamed:self.imageName];
    [self addSubview:_imageview];
    _titlelabel = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width*0.5+7, 14, 24, 24)];
    [_titlelabel setTextColor:[UIColor blackColor]];
    [_titlelabel setFont:[UIFont systemFontOfSize:16.0]];
    [self addSubview:_titlelabel];
    
    
}
@end

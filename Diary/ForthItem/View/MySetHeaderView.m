//
//  MySetHeaderView.m
//  Diary
//
//  Created by xukun on 2017/1/16.
//  Copyright © 2017年 xukun. All rights reserved.
//

#import "MySetHeaderView.h"

@implementation MySetHeaderView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        UIView *contentView = [[[NSBundle mainBundle]
                                loadNibNamed:@"MySetHeaderView" owner:self options:nil] firstObject];
        
        contentView.frame = self.bounds;
        
        [self setSpecalUI];
        
        [self addSubview:contentView];
    }
    return self;
}

-(void)setSpecalUI{
    //设置图片为圆角
    _headerImage.layer.borderWidth = 2.0;
    
    // _headImageView.image = [UIImage imageNamed:@"personcenterbg.png"];
    
    _headerImage.layer.borderColor = [UIColor whiteColor].CGColor;
    
    _headerImage.layer.masksToBounds =YES;
    
    _headerImage.layer.cornerRadius = _headerImage.frame.size.height*0.5;
}
@end

//
//  LoginView.m
//  Diary
//
//  Created by xukun on 2017/1/17.
//  Copyright © 2017年 xukun. All rights reserved.
//

#import "LoginView.h"

@implementation LoginView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
 
*/


- (void)awakeFromNib{
    [super awakeFromNib];
}
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"LoginView" owner:self options:nil] firstObject];
        
    }
    return self;
}
 
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    //    __block BOOL specialTouch = NO;
    
    if (CGRectContainsPoint(self.cancelButton.frame, point) ) {
        [self.delegate cancelEvent];
    }
    //点击我是萌团长部分
    if (CGRectContainsPoint(self.loginButton.frame, point) ) {
        NSLog(@"点击我是萌团长部分");
        [self.delegate loginEvent];
    }
    //点击累计奖金部分
    if (CGRectContainsPoint(self.registerButton.frame, point) ) {
        NSLog(@"点击累计奖金部分");
        [self.delegate registerEvent];
        
    }
}


- (IBAction)login:(id)sender {
    [_delegate loginEvent];
}

- (IBAction)registerAccount:(id)sender {
    [_delegate registerEvent];
}

- (IBAction)cancel:(id)sender {
    
    [_delegate cancelEvent];
}
@end

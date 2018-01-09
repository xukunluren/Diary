//
//  AdaptionTextView.m
//  Diary
//
//  Created by Hanser on 1/19/17.
//  Copyright © 2017 xukun. All rights reserved.
//

/**
  自适应textView
 */

#import "AdaptionTextView.h"

@interface AdaptionTextView()<UITextViewDelegate> {
    CGFloat _height;
}

@end

@implementation AdaptionTextView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.delegate = self;
        self.backgroundColor = [UIColor greenColor];
        
        _height = frame.size.height;
    }
    
    return self;
}

#pragma mark ---------------------------------------------------------------------
#pragma mark - UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView {
    CGRect frame = textView.frame;
    CGSize size = VD_MULTILINE_TEXTSIZE(textView.text, textView.font, CGSizeMake(CGRectGetWidth(textView.frame) - 2 * textView.textContainer.lineFragmentPadding, MAXFLOAT),0);
    CGFloat newHeihgt = size.height + 8;
    
    if (newHeihgt <= _height) {
        newHeihgt = _height;
    }
        

    [UIView animateWithDuration:0.5 animations:^{
        self.frame = CGRectMake(frame.origin.x,frame.origin.y  ,frame.size.width,newHeihgt);
        
    }];
    
    NSLog(@"dafd:%@-%@",textView.text,@(size.height));
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
 


}

- (void)textViewDidEndEditing:(UITextView *)textView {
    
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{

    
    
    return YES;
}

@end

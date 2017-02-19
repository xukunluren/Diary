//
//  exploreView.m
//  Diary
//
//  Created by xukun on 2017/1/19.
//  Copyright © 2017年 xukun. All rights reserved.
//

#import "exploreView.h"
#import "tansuoBottomButton.h"
#import "CardHeader.h"

@implementation exploreView

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
        [self initView];
        [self setBackgroundColor:[UIColor colorFromHexCode:@"FDFDFD"]];
    }
    return self;
}

-(void)initView{
    _textView = [[UITextView alloc] initWithFrame:CGRectMake(5, 15, self.frame.size.width-10, self.frame.size.height-25)];
    _textView.showsVerticalScrollIndicator = NO;
    _textView.showsHorizontalScrollIndicator = NO;
    _textView.backgroundColor = [UIColor colorFromHexCode:@"FDFDFD"];
    _textView.text = @"人物、情节、环境是小说的三要素。情节一般包括开端、发展、高潮、结局四部分，有的包括序幕、尾声。环境包括自然环境和社会环境。 小说按照篇幅及容量可分为长篇、中篇、短篇和微型小说（小小说）。按照表现的内容可分为科幻、公案、传奇、武侠、言情、同人、官宦等。按照体制可分为章回体小说、日记体小说、书信体小说、自传体小说。按照语言形式可分为文言小说和白话小说人物、情节、环境是小说的三要素。情节一般包括开端、发展、高潮、结局四部分，有的包括序幕、尾声。环境包括自然环境和社会环境。 小说按照篇幅及容量可分为长篇、中篇、短篇和微型小说（小小说）。按照表现的内容可分为科幻、公案、传奇、武侠、言情、同人、官宦等。按照体制可分为章回体小说、日记体小说、书信体小说、自传体小说。按照语言形式可分为文言小说和白话小说人物、情节、环境是小说的三要素。情节一般包括开端、发展、高潮、结局四部分，有的包括序幕、尾声。环境包括自然环境和社会环境。 小说按照篇幅及容量可分为长篇、中篇、短篇和微型小说（小小说）。按照表现的内容可分为科幻、公案、传奇、武侠、言情、同人、官宦等。按照体制可分为章回体小说、日记体小说、书信体小说、自传体小说。按照语言形式可分为文言小说和白话小说人物、情节、环境是小说的三要素。情节一般包括开端、发展、高潮、结局四部分，有的包括序幕、尾声。环境包括自然环境和社会环境。 小说按照篇幅及容量可分为长篇、中篇、短篇和微型小说（小小说）。按照表现的内容可分为科幻、公案、传奇、武侠、言情、同人、官宦等。按照体制可分为章回体小说、日记体小说、书信体小说、自传体小说。按照语言形式可分为文言小说和白话小说人物、情节、环境是小说的三要素。情节一般包括开端、发展、高潮、结局四部分，有的包括序幕、尾声。环境包括自然环境和社会环境。 小说按照篇幅及容量可分为长篇、中篇、短篇和微型小说（小小说）。按照表现的内容可分为科幻、公案、传奇、武侠、言情、同人、官宦等。按照体制可分为章回体小说、日记体小说、书信体小说、自传体小说。按照语言形式可分为文言小说和白话小说。";
    _textView.scrollEnabled = YES;
    _textView.editable = NO;
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 3;// 字体的行间距
    
    NSDictionary *attributes = @{
                                 NSFontAttributeName:[UIFont systemFontOfSize:15],
                                 NSParagraphStyleAttributeName:paragraphStyle
                                 };
    _textView.attributedText = [[NSAttributedString alloc] initWithString:_textView.text attributes:attributes];
    _textView.scrollsToTop = YES;
    //self.autoresizesSubviews = N0;;
    [self addSubview:_textView];
    
    
//    
//    UIView *buttonview = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height-50, self.frame.size.width, 50)];
//    [buttonview setBackgroundColor: [UIColor colorFromHexCode:@"FFFFFF"]];
//    
//    [self addSubview:buttonview];
//    
//    [buttonview addSubview:[self drawThreadWithFram:CGRectMake(buttonview.frame.size.width*0.5, 5, 0.5, 40) andColor:[UIColor colorFromHexCode:@"e7e7e7"]]];
//   tansuoBottomButton *supportButton = [[tansuoBottomButton alloc] initWithFrame:CGRectMake(0, 0, buttonview.frame.size.width*0.5-1, 50)];
//    supportButton.titlelabel.text = @"赞";
//    [supportButton addTarget:self action:@selector(dianzan) forControlEvents:UIControlEventTouchUpInside];
//    [supportButton.titleLabel setFont:[UIFont systemFontOfSize:14.0]];
//    supportButton.imageview.image = [UIImage imageNamed:@"dayu"];
//    [buttonview addSubview:supportButton];
//    
//   tansuoBottomButton *changeButton = [[tansuoBottomButton alloc] initWithFrame:CGRectMake(buttonview.frame.size.width*0.5+2, 0, buttonview.frame.size.width*0.5-1, 50)];
//    changeButton.titlelabel.text = @"换";
//    [changeButton addTarget:self action:@selector(huan) forControlEvents:UIControlEventTouchUpInside];
//    [changeButton.titleLabel setFont:[UIFont systemFontOfSize:14.0]];
//    changeButton.imageview.image =[UIImage imageNamed:@"dayu"];
//    [buttonview addSubview:changeButton];
    
 
    
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height-25, self.frame.size.width, 25)];
    [bottomView setBackgroundColor:[UIColor colorFromHexCode:@"FDFDFD"]];
    [self addSubview:bottomView];
    _imageview = [[UIImageView alloc] initWithFrame:CGRectMake(5, 0, 22, 22)];
    _imageview.image = [UIImage imageNamed:@"user_icon_default@2x"];
    //设置图片为圆角
    _imageview.layer.borderWidth = 2.0;
    
    _imageview.layer.borderColor = [UIColor whiteColor].CGColor;
    
    _imageview.layer.masksToBounds =YES;
    
    _imageview.layer.cornerRadius = _imageview.frame.size.height*0.5;
    [bottomView addSubview:_imageview];
    
    
    _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_imageview.frame)+5, 0, self.frame.size.width - 100, 22)];
    _nameLabel.text = @"路人许";
    [_nameLabel setFont:[UIFont systemFontOfSize:10.0]];
    [bottomView addSubview:_nameLabel];
    
    
    _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width - 75, 0, 70, 22)];
    _timeLabel.contentMode = UIViewContentModeRight;
    _timeLabel.text = @"2017-1-20";
    [_timeLabel setFont:[UIFont systemFontOfSize:10.0]];
    [bottomView addSubview:_timeLabel];
    

}
-(UIView *)drawThreadWithFram:(CGRect)rect andColor:(UIColor *)color{
    UIView *view = [[UIView alloc] initWithFrame:rect];
    view.backgroundColor = color;
    return view;
}

-(void)dianzan{
    if ([_delegate respondsToSelector:@selector(bottomButtonEvent:)]) {
        [_delegate bottomButtonEvent:0];
    }
    NSLog(@"dianzan");
}
-(void)huan{
    if ([_delegate respondsToSelector:@selector(bottomButtonEvent:)]) {
        [_delegate bottomButtonEvent:1];
    }
    NSLog(@"huan");
}

-(void)loadCardViewWithDictionary:(NSDictionary *)dictionary
{
    self.backgroundColor = RGBCOLOR([[dictionary objectForKey:@"red"] floatValue], [[dictionary objectForKey:@"green"] floatValue], [[dictionary objectForKey:@"blue"] floatValue]);
}

-(void)rightButtonClickAction {
    if (!self.canPan) {
        return;
    }
    CGPoint finishPoint = CGPointMake([[UIScreen mainScreen]bounds].size.width+CARD_WIDTH*2/3, 2*PAN_DISTANCE+self.frame.origin.y);
    [UIView animateWithDuration:CLICK_ANIMATION_TIME
                     animations:^{
                         //self.yesButton.transform = CGAffineTransformMakeScale(1.5, 1.5);
                         self.center = finishPoint;
                         self.transform = CGAffineTransformMakeRotation(-ROTATION_ANGLE);
                     } completion:^(BOOL finished) {
                         //self.yesButton.transform = CGAffineTransformMakeScale(1, 1);
                         //[self.delegate swipCard:self Direction:YES];
                     }];
    if ([self.delegate respondsToSelector:@selector(adjustOtherCards)]) {
        [self.delegate adjustOtherCards];
    }
    
}
-(void)leftButtonClickAction {
    if (!self.canPan) {
        return;
    }
    CGPoint finishPoint = CGPointMake(-CARD_WIDTH*2/3, 2*PAN_DISTANCE + self.frame.origin.y);
    [UIView animateWithDuration:CLICK_ANIMATION_TIME
                     animations:^{
                         //self.noButton.transform = CGAffineTransformMakeScale(1.5, 1.5);
                         self.center = finishPoint;
                         self.transform = CGAffineTransformMakeRotation(-ROTATION_ANGLE);
                     } completion:^(BOOL finished) {
                        // self.noButton.transform = CGAffineTransformMakeScale(1, 1);
                         //[self.delegate swipCard:self Direction:NO];
                     }];
    if ([self.delegate respondsToSelector:@selector(adjustOtherCards)]) {
        [self.delegate adjustOtherCards];
    }
}


@end

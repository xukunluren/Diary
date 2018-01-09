//
//  functionKeyView.m
//  Diary
//
//  Created by xukun on 2017/2/18.
//  Copyright © 2017年 xukun. All rights reserved.
//

#import "functionKeyView.h"

@implementation functionKeyView


- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self setView];
    }
    return self;
}


-(void)setView{
    UIView *openOrNot = [[UIView alloc] initWithFrame:CGRectMake(-1, 0, ScreenWidth+1, 35)];
    openOrNot.layer.borderWidth = 0.5;
    [openOrNot setBackgroundColor:[UIColor whiteColor]];
    openOrNot.layer.borderColor = [UIColor lightGrayColor].CGColor;
    [self addSubview:openOrNot];
    UILabel *textlabel = [[UILabel alloc] initWithFrame:CGRectMake(7, 3, ScreenWidth*0.5-6, openOrNot.frame.size.height-6)];
    textlabel.text = @"公开这篇日记";
    [textlabel setFont:[UIFont systemFontOfSize:12.0]];
    [textlabel setTextColor:[UIColor blackColor]];
    [openOrNot addSubview:textlabel];
    
    _openOrNotButton = [[UISwitch alloc] initWithFrame:CGRectMake(ScreenWidth-50, 0,50,0 )];
    _openOrNotButton.transform = CGAffineTransformMakeScale(0.75, 0.65);
    _openOrNotButton.onTintColor = [UIColor colorWithHexString:@"12B7F5"];
    [_openOrNotButton setOn:YES];
    [_openOrNotButton addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
    [openOrNot addSubview:_openOrNotButton];
    NSMutableArray *picture = [[NSMutableArray alloc] initWithObjects:@"keyboard.png",@"sound.png",@"video.png",@"picture.png",@"myphoto.png",@"weather.png", nil];
    
    UIView *functionKeyView = [[UIView alloc] initWithFrame:CGRectMake(0, 35.5, ScreenWidth, 35)];
    [functionKeyView setBackgroundColor:[UIColor whiteColor]];
     CGFloat  bTWith = ScreenWidth/6;
    for (int i=0; i<5; i++) {
       
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(i*bTWith, 5, bTWith, 25)];
        button.tag = i;
        [button addTarget:self action:@selector(functionBT:) forControlEvents:UIControlEventTouchUpInside];
        [button setImage:[UIImage imageNamed:picture[i]] forState:UIControlStateNormal];
        button.imageView.contentMode = UIViewContentModeScaleAspectFill;
        [functionKeyView addSubview:button];
    }
    _weatherBT = [[UIButton alloc] initWithFrame:CGRectMake(5*bTWith, 5, bTWith, 25)];
    _weatherBT.tag = 5;
    [_weatherBT addTarget:self action:@selector(functionBT:) forControlEvents:UIControlEventTouchUpInside];
    [_weatherBT setImage:[UIImage imageNamed:picture[5]] forState:UIControlStateNormal];
    _weatherBT.imageView.contentMode = UIViewContentModeScaleAspectFill;
    [functionKeyView addSubview:_weatherBT];
    [self addSubview:functionKeyView];
}
-(void)setweatherIconPicture:(long)icon{
   NSMutableArray  *weatherImageselect = [[NSMutableArray alloc] initWithObjects:@"qingtian",@"tianqi",@"feng",@"xiaoyu",@"dayu",@"lei",@"xue",@"wu",@"weather", nil];
    [_weatherBT setImage:[UIImage imageNamed:weatherImageselect[icon]] forState:UIControlStateNormal];
}
-(void)functionBT:(id)sender
{
    
    NSLog(@"按钮点击事件");
    
    [_delegate sendFunctionClick:sender] ;

}
-(void)switchAction:(id)sender{
    NSLog(@"是否公开这篇日记");
    [_delegate sendswitchAction:sender];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

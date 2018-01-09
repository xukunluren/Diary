//
//  MyHeaderTableViewCell.m
//  Diary
//
//  Created by xukun on 2017/1/18.
//  Copyright © 2017年 xukun. All rights reserved.
//

#import "MyHeaderTableViewCell.h"

@implementation MyHeaderTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(ScreenWidth*0.5, 5, 0.5, 40)];
    view.backgroundColor = [UIColor colorFromHexCode:@"e7e7e7"];
    [self addSubview:view];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

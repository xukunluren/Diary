//
//  MyMeansTableViewCell.m
//  Diary
//
//  Created by xukun on 2017/1/17.
//  Copyright © 2017年 xukun. All rights reserved.
//

#import "MyMeansTableViewCell.h"

@implementation MyMeansTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _headerImage.layer.borderWidth = 1.0;
    
    // _headImageView.image = [UIImage imageNamed:@"personcenterbg.png"];
    
    _headerImage.layer.borderColor = [UIColor whiteColor].CGColor;
    
    _headerImage.layer.masksToBounds =YES;
    
    _headerImage.layer.cornerRadius = _headerImage.frame.size.height*0.5;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

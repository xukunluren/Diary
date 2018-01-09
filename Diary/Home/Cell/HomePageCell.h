//
//  HomePageCell.h
//  Diary
//
//  Created by Hanser on 1/16/17.
//  Copyright © 2017 xukun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomePageCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *monthDayLabel;
@property (weak, nonatomic) IBOutlet UILabel *yearLabel;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (weak, nonatomic) IBOutlet UIImageView *weatherImageView;
@property (weak, nonatomic) IBOutlet UIImageView *videoImageView;
@property (weak, nonatomic) IBOutlet UIImageView *pictureImageView;
@property (weak, nonatomic) IBOutlet UIImageView *soundsImageView;

@property (weak, nonatomic) IBOutlet UILabel *assistNumLabel;
@property (weak, nonatomic) IBOutlet UIImageView *assistImageView;

@end

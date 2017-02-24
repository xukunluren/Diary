//
//  RichTextViewController.h
//  RichTextView
//
//
//  Copyright © 2017年 innos-campus. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "editDiaryModel.h"
#import "AnimationView.h"
@interface RichTextViewController : BaseViewController

@property (nonatomic,strong)AnimationView *centerRadarView;


@property (assign, nonatomic)   BOOL NewDiary;

@property(nonatomic,strong) NSData *diaryData;
@property(nonatomic,strong) editDiaryModel *editDiary;
@property(nonatomic,assign) long diaryId;
@property(nonatomic,assign) long atGroup;
@property(nonatomic,strong) NSString *groupTitle;

@property (nonatomic,copy) void (^finished)(id  content);
//+(instancetype)ViewController;

@end

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

@interface RichTextViewController : BaseViewController
@property (weak, nonatomic)   UIButton *fontBtn;
@property (weak, nonatomic)   UIButton *colorBtn;
@property (weak, nonatomic)   UIButton *boldBtn;
@property (weak, nonatomic)   UIButton *imageBtn;
@property (weak, nonatomic)   UIButton *previewBtn;
@property (assign, nonatomic)   BOOL NewDiary;

@property(nonatomic,strong) NSData *diaryData;
@property(nonatomic,strong) editDiaryModel *editDiary;
@property(nonatomic,assign) long diaryId;
@property(nonatomic,assign) long atGroup;

@property (nonatomic,copy) void (^finished)(id  content);
+(instancetype)ViewController;

@end

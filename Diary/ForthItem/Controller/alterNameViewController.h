//
//  alterNameViewController.h
//  Diary
//
//  Created by xukun on 2017/1/20.
//  Copyright © 2017年 xukun. All rights reserved.
//

#import "BaseViewController.h"

typedef void (^ReturnText)(NSString *name);

@interface alterNameViewController : BaseViewController
@property(nonatomic,strong) UITextField *name;
@property(nonatomic,copy) ReturnText returnText;
-(void)returnText:(ReturnText)name;
@end

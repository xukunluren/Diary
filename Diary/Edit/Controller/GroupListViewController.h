//
//  GroupListViewController.h
//  Diary
//
//  Created by xukun on 2017/2/16.
//  Copyright © 2017年 xukun. All rights reserved.
//

#import "BaseViewController.h"
#import "groupModel.h"
typedef void (^ReturnText)(groupModel *model);


@interface GroupListViewController : BaseViewController
@property(nonatomic,assign)NSIndexPath *selectedIndexPath;
@property(nonatomic,copy) ReturnText returnText;
-(void)returnText:(ReturnText)model;

@end

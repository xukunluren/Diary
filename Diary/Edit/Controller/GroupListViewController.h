//
//  GroupListViewController.h
//  Diary
//
//  Created by xukun on 2017/2/16.
//  Copyright © 2017年 xukun. All rights reserved.
//

#import "BaseViewController.h"

typedef void (^ReturnText)(NSDictionary *nameAndRow);


@interface GroupListViewController : BaseViewController
@property(nonatomic,assign)NSIndexPath *selectedIndexPath;
@property(nonatomic,copy) ReturnText returnText;
-(void)returnText:(ReturnText)nameAndRow;

@end

//
//  LoginController.h
//  Diary
//
//  Created by xukun on 2017/1/17.
//  Copyright © 2017年 xukun. All rights reserved.
//

#import "BaseViewController.h"

@interface LoginController : BaseViewController

- (IBAction)cancelButtonEvent:(id)sender;
- (IBAction)loginEvent:(id)sender;
- (IBAction)registerEvent:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *accountNum;
@property (weak, nonatomic) IBOutlet UITextField *secretNum;

@end
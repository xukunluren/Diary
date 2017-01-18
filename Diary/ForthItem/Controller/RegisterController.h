//
//  LoginController.h
//  Diary
//
//  Created by xukun on 2017/1/17.
//  Copyright © 2017年 xukun. All rights reserved.
//

#import "BaseViewController.h"

@interface RegisterController : BaseViewController

- (IBAction)cancelButtonEvent:(id)sender;
- (IBAction)loginEvent:(id)sender;
- (IBAction)registerEvent:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *accountNum;
@property (weak, nonatomic) IBOutlet UITextField *secretNum;
@property (weak, nonatomic) IBOutlet UIButton *registerButton;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;

@end

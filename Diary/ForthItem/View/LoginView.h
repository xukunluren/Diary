//
//  LoginView.h
//  Diary
//
//  Created by xukun on 2017/1/17.
//  Copyright © 2017年 xukun. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol turnToOtherViewDelegate <NSObject>
-(void)cancelEvent;
-(void)loginEvent;
-(void)registerEvent;
@end
@interface LoginView : UIView

@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UITextField *accountNum;
@property (weak, nonatomic) IBOutlet UITextField *secretNum;
- (IBAction)login:(id)sender;
- (IBAction)registerAccount:(id)sender;
- (IBAction)cancel:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIButton *registerButton;

@property (nonatomic, retain) id <turnToOtherViewDelegate> delegate;
@end

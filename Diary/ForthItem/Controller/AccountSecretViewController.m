//
//  AccountSecretViewController.m
//  Diary
//
//  Created by xukun on 2017/1/18.
//  Copyright © 2017年 xukun. All rights reserved.
//

#import "AccountSecretViewController.h"

#define KToY 80
#define kHeight 45
@interface AccountSecretViewController ()



@end

@implementation AccountSecretViewController
{
    UITextField *oldSecretField;
    UITextField *newSecretField;
    UITextField *_confirmCodeField;
}

- (void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"账号安全";
    [self initView];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
}
-(void)initView{
    UILabel *old = [[UILabel alloc] initWithFrame:CGRectMake(15, KToY, 50, kHeight)];
    [old setContentMode:UIViewContentModeCenter];
    [old setText:@"原密码"];
    [old setFont:[UIFont systemFontOfSize:16.0]];
    [self.view addSubview:old];
    oldSecretField = [[UITextField alloc] initWithFrame:CGRectMake(110, KToY, ScreenWidth*0.6 - 30, kHeight)];
    oldSecretField.placeholder = @"请填写注册时设置的密码";
    [oldSecretField setFont:[UIFont systemFontOfSize:15.0]];
    [self.view addSubview:oldSecretField];
    
    [self.view addSubview:[self drawThreadWithFram:CGRectMake(10, KToY+kHeight+1, ScreenWidth-20, 0.5) andColor:[UIColor colorFromHexCode:@"e7e7e7"]]];
    UILabel *new = [[UILabel alloc] initWithFrame:CGRectMake(15,KToY + kHeight+3, 50, kHeight)];
    [new setContentMode:UIViewContentModeCenter];
    [new setText:@"新密码"];
    [new setFont:[UIFont systemFontOfSize:16.0]];
    [self.view addSubview:new];
    
    newSecretField = [[UITextField alloc] initWithFrame:CGRectMake(110, KToY + kHeight+3, ScreenWidth*0.6 - 30, kHeight)];
    newSecretField.placeholder = @"请填写注册时设置的密码";
    [newSecretField setFont:[UIFont systemFontOfSize:15.0]];
    [self.view addSubview:newSecretField];
   [self.view addSubview: [self drawThreadWithFram:CGRectMake(10, CGRectGetMaxY(new.frame)+1, ScreenWidth-20, 0.5) andColor:[UIColor colorFromHexCode:@"e7e7e7"]]];
    
    UILabel *confirm = [[UILabel alloc] initWithFrame:CGRectMake(15, KToY + kHeight*2 + 2, 70, kHeight)];
    confirm.contentMode = UIViewContentModeCenter;
    confirm.font = [UIFont systemFontOfSize:16];
    confirm.text = @"确认密码";
    [self.view addSubview:confirm];
    
    _confirmCodeField = [[UITextField alloc] initWithFrame:CGRectMake(110,confirm.frame.origin.y , kScreenWidth*0.6 -30, kHeight)];
    _confirmCodeField.font = [UIFont systemFontOfSize:15];
    _confirmCodeField.placeholder = @"再次输入密码";
    [self.view addSubview:_confirmCodeField];
    
    [UIView drawLine:CGRectMake(10, CGRectGetMaxY(_confirmCodeField.frame)+0.5, kScreenWidth-20, 0.5) color:[UIColor colorFromHexCode:@"#e7e7e7"] subView:self.view];
    
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

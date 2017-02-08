//
//  LoginController.m
//  Diary
//
//  Created by xukun on 2017/1/17.
//  Copyright © 2017年 xukun. All rights reserved.
//

#import "LoginController.h"
#import "LoginView.h"
#import "RegisterController.h"

@interface LoginController ()

@property(nonatomic,strong)UIView *loginView;

@property (nonatomic, strong) UITextField *IDtextField;
@property (nonatomic, strong) UITextField *codeTextField;

@end

@implementation LoginController

 
- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self initView];
    
    [self addBackButton];
    
    self.view.backgroundColor = [UIColor whiteColor];
 
    
}


#pragma mark --------------------------------------------------------------------------
#pragma mark - init
- (void)initView{
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.frame = CGRectMake(0, 115, kScreenWidth, 30);
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"欢迎使用好记";
    titleLabel.font = [UIFont systemFontOfSize:20];
    [self.view addSubview:titleLabel];
    
    UILabel *titleIDLabel = [[UILabel alloc] init];
    titleIDLabel.frame = CGRectMake(20, CGRectGetMaxY(titleLabel.frame)+65, 35, 20);
    titleIDLabel.font = [UIFont systemFontOfSize:15];
    titleIDLabel.text = @"账号";
    titleIDLabel.textColor = [UIColor blackColor];
    [self.view addSubview:titleIDLabel];
    
    _IDtextField = [[UITextField alloc] init];
    _IDtextField.font = [UIFont systemFontOfSize:15];
    _IDtextField.placeholder = @"请输入邮箱";
    _IDtextField.frame = CGRectMake(CGRectGetMaxX(titleIDLabel.frame)+15, titleIDLabel.frame.origin.y, kScreenWidth-100, 20);
    [self.view addSubview:_IDtextField];
    
    
    UILabel *titleCodeLabel = [[UILabel alloc] init];
    titleCodeLabel.frame = CGRectMake(20, CGRectGetMaxY(titleIDLabel.frame)+30, 35, 20);
    titleCodeLabel.font = [UIFont systemFontOfSize:15];
    titleCodeLabel.text = @"密码";
    titleCodeLabel.textColor = [UIColor blackColor];
    [self.view addSubview:titleCodeLabel];
    
    _codeTextField = [[UITextField alloc] init];
    _codeTextField.font = [UIFont systemFontOfSize:15];
    _codeTextField.placeholder = @"请输入密码";
    _codeTextField.frame = CGRectMake(CGRectGetMaxX(titleCodeLabel.frame)+15, titleCodeLabel.frame.origin.y, kScreenWidth-100, 20);
    [self.view addSubview:_codeTextField];

    

    _loginButton = [[UIButton alloc] initWithFrame:CGRectMake(10, kScreenHeight/2, self.view.frame.size.width-20, 45)];
    [_loginButton setTitle:@"登录" forState:UIControlStateNormal];
    [_loginButton setBackgroundColor:[UIColor colorFromHexCode:@"12B7F5"]];
    [_loginButton addTarget:self action:@selector(loginEvent:) forControlEvents:UIControlEventTouchUpInside];
    [_loginButton setContentMode:UIViewContentModeCenter];
    [self.view addSubview:_loginButton];
    
    _registerButton = [[UIButton alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_loginButton.frame)+5, ScreenWidth, 30)];
    [_registerButton setTitle:@"注册" forState:UIControlStateNormal];
    [_registerButton.titleLabel setTextColor:[UIColor blackColor]];
    [_registerButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_registerButton addTarget:self action:@selector(registerEvent:) forControlEvents:UIControlEventTouchUpInside];
    [_registerButton setContentMode:UIViewContentModeCenter];
    [_registerButton.titleLabel setFont:[UIFont systemFontOfSize:12.0]];
    [self.view addSubview:_registerButton];
    
    
    _loginButton.layer.cornerRadius = 4.0;
    _loginView.frame = CGRectMake(10, 0, ScreenWidth-20, 45);
    

}

- (void)addBackButton {
    
    CGRect rect = CGRectMake(5, 20, 46, 30);
    UIButton *btn = [[UIButton alloc] initWithFrame:rect];
    [btn addTarget:self action:@selector(cancelButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitle:@"取消" forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:15];
    [btn setTitleColor:[UIColor colorFromHexCode:@"#12B7F5"] forState:UIControlStateNormal];
    [self.view addSubview:btn];
}



-(void)viewWillAppear:(BOOL)animated{
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    
}


- (void)cancelButtonEvent:(id)sender {
    [self goBack];
}

- (IBAction)loginEvent:(id)sender {
}

- (IBAction)registerEvent:(id)sender {
    RegisterController *registerView = [[RegisterController alloc] init];
    [self.navigationController pushViewController:registerView animated:YES];
}
@end

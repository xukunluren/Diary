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
@end

@implementation LoginController

 
- (void)viewDidLoad {
    [super viewDidLoad];
    
    _loginView = [[[NSBundle mainBundle] loadNibNamed:@"LoginView" owner:self options:nil] firstObject];
    [self initView];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_loginView];
    
}
 
- (void)initView{
    _loginButton.layer.cornerRadius = 4.0;
}
 
-(void)viewWillAppear:(BOOL)animated{
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)cancelButtonEvent:(id)sender {
    [self goBack];
}

- (IBAction)loginEvent:(id)sender {
}

- (IBAction)registerEvent:(id)sender {
    RegisterController *registerView = [[RegisterController alloc] init];
    [self.navigationController pushViewController:registerView animated:YES];
}
@end

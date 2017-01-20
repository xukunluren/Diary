//
//  LoginController.m
//  Diary
//
//  Created by xukun on 2017/1/17.
//  Copyright © 2017年 xukun. All rights reserved.
//

#import "RegisterController.h"


@interface RegisterController ()
@property(nonatomic,strong)UIView *loginView;
@end

@implementation RegisterController

 
- (void)viewDidLoad {
    [super viewDidLoad];
    
    _loginView = [[[NSBundle mainBundle] loadNibNamed:@"RegisterView" owner:self options:nil] firstObject];
    
    
  
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_loginView];
    [self initView];
    
}
 

-(void)initView{
    _registerButton.layer.cornerRadius = 4.0;
    
    
    _loginButton = [[UIButton alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(_middleView.frame)+30, self.view.frame.size.width-20, 45)];
    [_loginButton setTitle:@"注册" forState:UIControlStateNormal];
    [_loginButton setBackgroundColor:[UIColor colorFromHexCode:@"12B7F5"]];
    [_loginButton addTarget:self action:@selector(loginEvent:) forControlEvents:UIControlEventTouchUpInside];
    [_loginButton setContentMode:UIViewContentModeCenter];
    [self.view addSubview:_loginButton];
    
    _registerButton = [[UIButton alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_loginButton.frame)+5, ScreenWidth, 30)];
    [_registerButton setTitle:@"立即登录" forState:UIControlStateNormal];
    [_registerButton.titleLabel setTextColor:[UIColor blackColor]];
    [_registerButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_registerButton addTarget:self action:@selector(registerEvent:) forControlEvents:UIControlEventTouchUpInside];
    [_registerButton setContentMode:UIViewContentModeCenter];
    [_registerButton.titleLabel setFont:[UIFont systemFontOfSize:12.0]];
    [self.view addSubview:_registerButton];
    
    
    _loginButton.layer.cornerRadius = 4.0;
    _loginView.frame = CGRectMake(10, 0, ScreenWidth-20, 45);
    
    [self.middleView addSubview:[self drawThreadWithFram:CGRectMake(20, CGRectGetMaxY(_accountNum.frame)+5, ScreenWidth-40, 0.5) andColor:[UIColor colorFromHexCode:@"e7e7e7"]]];
    [self.middleView addSubview:[self drawThreadWithFram:CGRectMake(20, CGRectGetMaxY(_secretNum.frame)+5, ScreenWidth-40, 0.5) andColor:[UIColor colorFromHexCode:@"e7e7e7"]]];
    
    
    
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
        [self goBack];
   }
@end

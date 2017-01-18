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
    self.view.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_loginView];
    [self initView];
    
}
 

-(void)initView{
    _registerButton.layer.cornerRadius = 4.0;
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

//
//  LoginController.m
//  Diary
//
//  Created by xukun on 2017/1/17.
//  Copyright © 2017年 xukun. All rights reserved.
//

#import "RegisterController.h"


@interface RegisterController ()<UITextFieldDelegate> {
    NSString *_ID;
}

@property (nonatomic, strong) UITextField *IDtextField;
@property (nonatomic, strong) UITextField *codeTextField;
@property (nonatomic, strong) UITextField *confirmCodeTextField;

@end

@implementation RegisterController

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
    _IDtextField.delegate = self;
    _IDtextField.placeholder = @"请输入邮箱";
    _IDtextField.frame = CGRectMake(CGRectGetMaxX(titleIDLabel.frame)+50, titleIDLabel.frame.origin.y, kScreenWidth-150, 20);
    [self.view addSubview:_IDtextField];
    
    
    UILabel *titleCodeLabel = [[UILabel alloc] init];
    titleCodeLabel.frame = CGRectMake(20, CGRectGetMaxY(titleIDLabel.frame)+30, 35, 20);
    titleCodeLabel.font = [UIFont systemFontOfSize:15];
    titleCodeLabel.text = @"密码";
    titleCodeLabel.textColor = [UIColor blackColor];
    [self.view addSubview:titleCodeLabel];
    
    _codeTextField = [[UITextField alloc] init];
    _codeTextField.delegate = self;
    _codeTextField.font = [UIFont systemFontOfSize:15];
    _codeTextField.placeholder = @"请输入密码";
    _codeTextField.frame = CGRectMake(CGRectGetMaxX(titleCodeLabel.frame)+50, titleCodeLabel.frame.origin.y, kScreenWidth-150, 20);
    [self.view addSubview:_codeTextField];
    
    
    UILabel *confirmCodeTitleLabel = [[UILabel alloc] init];
    confirmCodeTitleLabel.frame = CGRectMake(20, CGRectGetMaxY(titleCodeLabel.frame)+30, 65, 20);
    confirmCodeTitleLabel.font = [UIFont systemFontOfSize:15];
    confirmCodeTitleLabel.text = @"确认密码";
    confirmCodeTitleLabel.textColor = [UIColor blackColor];
    [self.view addSubview:confirmCodeTitleLabel];

    _confirmCodeTextField = [[UITextField alloc] init];
    _confirmCodeTextField.delegate = self;
    _confirmCodeTextField.font = [UIFont systemFontOfSize:15];
    _confirmCodeTextField.placeholder = @"请确认密码";
    _confirmCodeTextField.frame = CGRectMake(CGRectGetMaxX(titleCodeLabel.frame)+50, confirmCodeTitleLabel.frame.origin.y, kScreenWidth-150, 20);
    [self.view addSubview:_confirmCodeTextField];

    
    
    
    
    
    _registerButton = [[UIButton alloc] initWithFrame:CGRectMake(10, kScreenHeight/2 + 50, self.view.frame.size.width-20, 45)];
    [_registerButton setTitle:@"注册" forState:UIControlStateNormal];
    [_registerButton setBackgroundColor:[UIColor colorFromHexCode:@"12B7F5"]];
    [_registerButton addTarget:self action:@selector(registerButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_registerButton setContentMode:UIViewContentModeCenter];
    [self.view addSubview:_registerButton];
    
//    _registerButton = [[UIButton alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_loginButton.frame)+5, ScreenWidth, 30)];
//    [_registerButton setTitle:@"注册" forState:UIControlStateNormal];
//    [_registerButton.titleLabel setTextColor:[UIColor blackColor]];
//    [_registerButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    [_registerButton addTarget:self action:@selector(registerEvent:) forControlEvents:UIControlEventTouchUpInside];
//    [_registerButton setContentMode:UIViewContentModeCenter];
//    [_registerButton.titleLabel setFont:[UIFont systemFontOfSize:12.0]];
//    [self.view addSubview:_registerButton];
    
    
    _registerButton.layer.cornerRadius = 4.0;
   // _loginView.frame = CGRectMake(10, 0, ScreenWidth-20, 45);
    
    
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

- (void)registerButtonClick:(id)sender {
    
    //检查两次输入的密码是否相同
    NSString *username = _IDtextField.text;
    NSString *one = _codeTextField.text;
    NSString *two = _confirmCodeTextField.text;
    if (![one isEqualToString:two]) {
        UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"提示" message:@"您两次输入的密码不一致,请确认" preferredStyle:UIAlertControllerStyleAlert];
        [ac addAction:[UIAlertAction actionWithTitle:@"确定" style:0 handler:^(UIAlertAction * _Nonnull action) {
        }]];
        [self presentViewController:ac animated:YES completion:^{
        }];
    }
    //存储账号数据
    NSLog(@"%@",_ID);
//    NSArray *data= [[NSArray alloc]initWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"UserData"ofType:@"plist"]];
//    NSMutableArray *muArray = [NSMutableArray arrayWithArray:data];
//    // 获取沙盒路径,这里"/demo.plist"是指新建的沙盒里plist文件路径，一定要加“/”!!!
//    NSString *filePath= [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES)lastObject]stringByAppendingPathComponent:@"/UserData.plist"];
////    NSString *path = [[NSBundle mainBundle]pathForResource:@"UserData"ofType:@"plist"];
////    //将工程中的数据新字典写入沙盒
//    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@"zhangsan",@"1",@"lisi",@"2", nil];
//    [muArray addObject:dic];
//    [muArray writeToFile:filePath atomically:YES];
    // 创建文件管理器
    
    //获取当前.plist文件的目录
    NSString *configPath = [[NSBundle mainBundle] pathForResource:@"UserData" ofType:@"plist"];
    //通过目录获取里面的存储数组
    NSArray *configData = [[NSArray alloc] initWithContentsOfFile:configPath];
    //另建一个数组作为添加数组aa
    NSMutableArray *muarr = [NSMutableArray arrayWithArray:configData];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:_ID,@"id", nil];
    [muarr addObject:dic];
    //把内容写入数组里面
    [muarr writeToFile:configPath atomically:YES];
    
    
}

#pragma mark ---------------------------------------------------------------------
#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if (textField == _IDtextField) {
        _ID = textField.text;
    }
    return YES;

}
@end

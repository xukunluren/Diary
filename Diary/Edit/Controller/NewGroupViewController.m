//
//  NewGroupViewController.m
//  Diary
//
//  Created by xukun on 2017/2/16.
//  Copyright © 2017年 xukun. All rights reserved.
//

#import "NewGroupViewController.h"

@interface NewGroupViewController ()
@property(nonatomic,strong)UITextField *textField;

@end

@implementation NewGroupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorFromHexCode:@"EFEFF4"];
    [self setBackWithText:@"取消"];
    self.title = @"新增分类";
     self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStyleDone target:self action:@selector(rightButtonClick)];
    [self initView];
    
}

-(void)initView{
    _textField = [[UITextField alloc] initWithFrame:CGRectMake(0, 100, ScreenWidth, 40)];
    _textField.placeholder = @"分类名称";
    _textField.backgroundColor = [UIColor whiteColor];
    _textField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 0)];
    _textField.leftViewMode = UITextFieldViewModeAlways;
    [_textField setFont:[UIFont systemFontOfSize:14.0]];
    [self.view addSubview:_textField];
}
-(void)rightButtonClick{
    NSLog(@"保存");
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

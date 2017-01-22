//
//  alterNameViewController.m
//  Diary
//
//  Created by xukun on 2017/1/20.
//  Copyright © 2017年 xukun. All rights reserved.
//

#import "alterNameViewController.h"

@interface alterNameViewController ()

@end

@implementation alterNameViewController

- (void)viewWillDisappear:(BOOL)animated {
    if (self.returnText != nil) {
        self.returnText(self.name.text);
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initView];
    self.view.backgroundColor = [UIColor colorFromHexCode:@"EFEFF4"];
    [self setBackWithImage];
}
-(void)initView{
    _name = [[UITextField alloc] initWithFrame:CGRectMake(0, 70, ScreenWidth, 40)];
    _name.placeholder = @"新的昵称";
    _name.backgroundColor = [UIColor whiteColor];
    _name.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 0)];
    _name.leftViewMode = UITextFieldViewModeAlways;
    [_name setFont:[UIFont systemFontOfSize:14.0]];
    [self.view addSubview:_name];
}
- (void)returnText:(ReturnText)name{
    self.returnText = name;
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

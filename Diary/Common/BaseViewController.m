//
//  BaseViewController.m
//  Diary
//
//  Created by xukun on 2017/1/13.
//  Copyright © 2017年 xukun. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //设置窗口样式
    self.navigationController.navigationBar.backgroundColor = [UIColor colorWithHexString:@"12B7F5"];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithHexString:@"12B7F5"];
    [self.navigationController.navigationBar setBarStyle:UIBarStyleBlackTranslucent];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    
    /**  防止系统自动调节UI的位置 */
    self.automaticallyAdjustsScrollViewInsets = NO;
}

-(void)goBack{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)setRightWithImage{
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithNorImage:@"left" higImage:@"leftSelect" targe:self action:@selector(rightButtonClick)];
}

-(void)setRightWithText:(NSString *)text{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:text style:UIBarButtonItemStyleDone target:self action:@selector(rightButtonClick)];;
}

- (void)setBackWithImage{
  self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithNorImage:@"left" higImage:@"leftSelect" targe:self action:@selector(leftDown)];
}

-(void)setBackWithText:(NSString *)text{
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:text style:UIBarButtonItemStyleDone target:self action:@selector(leftDown)];;
}

- (void)leftDown
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)rightButtonClick{
    NSLog(@"右边按钮点击事件");
}
//设置导航条是否透明
-(void)setNavigtionBarTransparent:(BOOL)_transparent{
    if(_transparent){
        self.navigationController.navigationBar.hidden = YES;
    }else{
        self.navigationController.navigationBar.hidden = NO;

    }
}
-(UIView *)drawThreadWithFram:(CGRect)rect andColor:(UIColor *)color{
    UIView *view = [[UIView alloc] initWithFrame:rect];
    view.backgroundColor = color;
    return view;
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

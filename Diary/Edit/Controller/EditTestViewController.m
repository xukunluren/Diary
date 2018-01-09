//
//  EditTestViewController.m
//  Diary
//
//  Created by xukun on 2017/2/13.
//  Copyright © 2017年 xukun. All rights reserved.
//

#import "EditTestViewController.h"

@interface EditTestViewController ()



@end

@implementation EditTestViewController
{
  
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 60, ScreenWidth, ScreenHeight-60)];
    _textView.backgroundColor =[UIColor grayColor] ;
    [self.view addSubview:_textView];
    
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

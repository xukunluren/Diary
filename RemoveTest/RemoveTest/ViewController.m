//
//  ViewController.m
//  RemoveTest
//
//  Created by xukun on 2017/2/10.
//  Copyright © 2017年 xukun. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController
{
    NSInteger count;
    UIView *viewDelete;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self initView];
    count = 4;
    
}


-(void)initView{
    
    for(int i = 1;i<5;i++){
    viewDelete = [[UIView alloc] initWithFrame:CGRectMake(10, 40*i, 40, 20)];
    [viewDelete setBackgroundColor:[UIColor redColor]];
    viewDelete.tag = i;
    [self.view addSubview:viewDelete];
    
//    
//    UIView *view2 = [[UIView alloc] initWithFrame:CGRectMake(10, 80, 40, 20)];
//    [view2 setBackgroundColor:[UIColor redColor]];
//    view2.tag=2;
//    [self.view addSubview:view2];
//    
//    UIView *view3 = [[UIView alloc] initWithFrame:CGRectMake(10, 160, 40, 20)];
//    [view3 setBackgroundColor:[UIColor redColor]];
//    view3.tag = 1;
//    [self.view addSubview:view3];
//    
//    UIView *view4 = [[UIView alloc] initWithFrame:CGRectMake(10, 300, 40, 20)];
//    [view4 setBackgroundColor:[UIColor redColor]];
//    view4.tag=4;
//    [self.view addSubview:view4];
    }
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(70, 40, 50, 40)];
    [button setTitle:@"删除" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(delete:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:button];
    
}

-(void)delete:(id)sender
{
    NSInteger iiii = self.view.subviews.count-2;
    
    [self.view.subviews[iiii--] removeFromSuperview];
    
//    for (id objec in self.view.subviews) {
//        [objec removeFromSuperview];
//    }
//    NSLog(@"%ld",(long)count);
//    [[viewDelete viewWithTag:count -- ] removeFromSuperview];
    
   
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

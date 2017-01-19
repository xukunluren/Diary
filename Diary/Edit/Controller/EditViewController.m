//
//  PublishViewController.m
//  ProjectGenericFramework
//
//  Created by joe on 2016/12/14.
//  Copyright © 2016年 joe. All rights reserved.
//

#import "EditViewController.h"

@interface EditViewController ()

@end

@implementation EditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}


@end

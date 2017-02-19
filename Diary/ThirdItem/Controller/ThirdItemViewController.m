//
//  ThirdItemViewController.m
//  Diary
//
//  Created by xukun on 2017/1/13.
//  Copyright © 2017年 xukun. All rights reserved.
//

#import "ThirdItemViewController.h"
#import "exploreView.h"
#import <QuartzCore/QuartzCore.h>


@interface ThirdItemViewController ()


@end

@implementation ThirdItemViewController
{
    exploreView *holdView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self initView];
   
}
-(void)initView{
    holdView = [[exploreView alloc] initWithFrame:CGRectMake(15, 10+ KNaviBarHeight+20, ScreenWidth-30, ScreenHeight-20-KNaviBarHeight-KTabBarHeight-20)];
    holdView.layer.shadowOpacity = 0.5;// 阴影透明度
    holdView.layer.shadowColor = [UIColor colorFromHexCode:@"C9C9C9"].CGColor;// 阴影的颜色
    holdView.layer.shadowRadius = 6;// 阴影扩散的范围控制
    holdView.layer.shadowOffset  = CGSizeMake(2, 2);// 阴影的范围
    [self.view addSubview:holdView];
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

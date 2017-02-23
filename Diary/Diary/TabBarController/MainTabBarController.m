//
//  MainTabBarController.m
//  ProjectGenericFramework
//
//  Created by joe on 2016/12/14.
//  Copyright © 2016年 joe. All rights reserved.
//

#import "MainTabBarController.h"
#import "FirstItemViewController.h"
#import "ProfileViewController.h"
 
#import "MainNavigationController.h"
#import "MainTabBarControllerTabBar.h"
#import "SecondItemViewController.h"
#import "ThirdItemViewController.h"
#import "MySetViewController.h"


@interface MainTabBarController () <MainTabBarControllerTabBarDelegate>
@property (nonatomic, strong) FirstItemViewController *firstItem;
@property (nonatomic, strong) SecondItemViewController *secondtem;
@property (nonatomic, strong) ThirdItemViewController *thirdItem;
@property (nonatomic, strong) MySetViewController *fourthItem;
@property (nonatomic, strong) ProfileViewController *profileVc;
@end

@implementation MainTabBarController

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    //self.view.backgroundColor = [UIColor redColor];
    // 添加子控制器
    [self addChildVc:self.firstItem title:@"好记" image:@"first" selectedImage:@"first_select"];
    [self addChildVc:self.secondtem title:@"分组" image:@"second" selectedImage:@"second_select"];
    [self addChildVc:self.thirdItem title:@"探索" image:@"tansuo" selectedImage:@"tansuo_select"];
    [self addChildVc:self.fourthItem title:@"我" image:@"wo" selectedImage:@"wo_select"];
    
    MainTabBarControllerTabBar *tabBar = [[MainTabBarControllerTabBar alloc] init];
    tabBar.customDelegate = self;
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    // app版本
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    NSLog(@"%@---",app_Version);
    
    
    NSLog(@"%@----",app_Version);

    // app build版本
    /** KVC */
    //[self setValue:tabBar forKey:@"tabBar"];
}



#pragma mark - delegate
// MainTabBarControllerTabBarDelegate 加号按钮代理
- (void)tabBarDidClickPlusButton:(MainTabBarControllerTabBar *)tabBar
{
//    EditViewController *vc = [[EditViewController alloc] init];
//    [self presentViewController:vc animated:YES completion:nil];
}
#pragma mark - event response
#pragma mark - private methods
- (void)addChildVc:(UIViewController *)childVc title:(NSString *)title image:(NSString *)image selectedImage:(NSString *)selectedImage
{
    
    /** 设置tabbar title  和 navigationbar title */
    childVc.title = title;
    [childVc.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor colorWithHexString:@"12B7F5"]} forState:UIControlStateSelected];
    /** 设置图片 */
    childVc.tabBarItem.image = [UIImage imageNamed:image];
    childVc.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    /** 添加子控制器 */
    //UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:childVc];
    MainNavigationController *navigationVc = [[MainNavigationController alloc] initWithRootViewController:childVc];
    [self addChildViewController:navigationVc];
}
#pragma mark - getters and setters
- (FirstItemViewController *)firstItem
{
    if (_firstItem == nil) {
        _firstItem = [[FirstItemViewController alloc] init];
        
    }
    return _firstItem;
}
- (SecondItemViewController *)secondtem
{
    if (_secondtem == nil) {
        _secondtem = [[SecondItemViewController alloc] init];
    }
    return _secondtem;
}
- (ThirdItemViewController *)thirdItem
{
    if (_thirdItem == nil) {
        _thirdItem = [[ThirdItemViewController alloc] init];
    }
    return _thirdItem;
}
- (MySetViewController *)fourthItem
{
    if (_fourthItem == nil) {
        _fourthItem = [[MySetViewController alloc] init];
    }
    return _fourthItem;
}
- (ProfileViewController *)profileVc
{
    if (_profileVc == nil) {
        _profileVc = [[ProfileViewController alloc] init];
    }
    return _profileVc;
}

@end

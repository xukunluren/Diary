//
//  AppDelegate.m
//  Diary
//
//  Created by xukun on 2017/1/13.
//  Copyright © 2017年 xukun. All rights reserved.
//

#import "AppDelegate.h"
#import "MainTabBarController.h"
#import "UIViewController+ClassName.h"
#import "GuideView.h"

#define LAST_RUN_VERSION_KEY @"last_run_version_of_application"
#define IS_iOS8 ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0)
@interface AppDelegate ()<GuideViewDelegate>

@property (strong, nonatomic) NSArray *imageArray;


@end

@implementation AppDelegate



- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [self registerLocalNotification];
    [self setNotification];
    //显示当前类名
    BOOL b = [self isFirstLoad];
    NSLog(@"%d",b);
//    [UIViewController displayClassName:YES];
    GuideView *guideView = [[GuideView alloc] initWithFrame:self.window.bounds count:self.imageArray.count];
    guideView.delegate = self;
    guideView.imageArray = self.imageArray;
    [self.window.rootViewController.view addSubview:guideView];

    if (b) {
        GuideView *guideView = [[GuideView alloc] initWithFrame:self.window.bounds];
        guideView.delegate = self;
        guideView.imageArray = self.imageArray;
        [self.window.rootViewController.view addSubview:guideView];
        
    }else {
        [self setRootViewController];
    }
  
    
    return YES;
}

-(void)setNotification{
    UILocalNotification *notification=[[UILocalNotification alloc] init];
    if (notification!=nil) {//判断系统是否支持本地通知
        notification.fireDate = [NSDate dateWithTimeIntervalSince1970:17*60*60*24];//本次开启立即执行的周期
        notification.repeatInterval=kCFCalendarUnitWeekday;//循环通知的周期
        notification.timeZone=[NSTimeZone defaultTimeZone];
        notification.alertBody=@"哇哇哇";//弹出的提示信息
        notification.applicationIconBadgeNumber=0; //应用程序的右上角小数字
        notification.soundName= UILocalNotificationDefaultSoundName;//本地化通知的声音
        //notification.alertAction = NSLocalizedString(@"美女呀", nil);  //弹出的提示框按钮
        notification.hasAction = NO;
        [[UIApplication sharedApplication]   scheduleLocalNotification:notification];
    }
}
- (void)registerLocalNotification
{
    //创建UIUserNotificationSettings，并设置消息的显示类类型
    UIUserNotificationSettings *uns = [UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound) categories:nil];
    
    [[UIApplication sharedApplication] registerUserNotificationSettings:uns];
}

// 本地通知回调函数，当应用程序在前台时调用
- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    NSLog(@"%@", notification.userInfo);
    [self showAlertView:@"用户没点击按钮直接点的推送消息进来的/或者该app在前台状态时收到推送消息"];
    NSInteger badge = [UIApplication sharedApplication].applicationIconBadgeNumber;
    badge -= notification.applicationIconBadgeNumber;
    badge = badge >= 0 ? badge : 0;
    [UIApplication sharedApplication].applicationIconBadgeNumber = badge;
}
- (void)showAlertView:(NSString *)message
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:action];
    [self.window.rootViewController showDetailViewController:alert sender:nil];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark -------------------------------------------------------
#pragma mark - 判断是否是第一次安装进入，或者是更新之后第一进入
- (BOOL) isFirstLoad{
    NSString *currentVersion = [[[NSBundle mainBundle] infoDictionary]
                                objectForKey:@"CFBundleShortVersionString"];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSString *lastRunVersion = [defaults objectForKey:LAST_RUN_VERSION_KEY];
    
    if (!lastRunVersion) {
        [defaults setObject:currentVersion forKey:LAST_RUN_VERSION_KEY];
        return YES;
    }
    else if (![lastRunVersion isEqualToString:currentVersion]) {
        [defaults setObject:currentVersion forKey:LAST_RUN_VERSION_KEY];
        return YES;
    }
    return NO;
}

- (void)setRootViewController {
    self.window = [[UIWindow alloc] initWithFrame:kMainScreenBounds];
    
    self.window.backgroundColor = [UIColor whiteColor];
    
    self.window.rootViewController = [[MainTabBarController alloc] init];
    
    [self.window makeKeyAndVisible];

}

- (NSArray *)imageArray {
    if (!_imageArray) {
        _imageArray = [[NSArray alloc] initWithObjects:@"welcome1",@"welcome2",@"welcome3", nil];
        return _imageArray;
    }
    return _imageArray;
}

- (void)GuideViewDelegate:(GuideView *)guideView {
    [guideView removeFromSuperview];
    [self setRootViewController];
}
@end

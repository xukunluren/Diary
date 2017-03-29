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

#import "RichTextViewController.h"
#import "RichTextViewController.h"
#import "CoreNewFeatureVC.h"

#define LAST_RUN_VERSION_KEY @"last_run_version_of_application"
#define IS_iOS8 ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0)

#define LAST_RUN_VERSION_KEY @"last_run_version_of_application"

@interface AppDelegate ()

@property (strong, nonatomic) NSArray *imageArray;


@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    //显示当前类名
    BOOL b = [self isFirstLoad];
    NSLog(@"%d",b);
    [UIViewController displayClassName:YES];
    UIWindow *window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    self.window = window;
    
    BOOL canShow = [CoreNewFeatureVC canShowNewFeature];

    if (canShow) {
        NewFeatureModel *m1 = [NewFeatureModel model:[UIImage imageNamed:@"welcome1"]];
        
        NewFeatureModel *m2 = [NewFeatureModel model:[UIImage imageNamed:@"welcome2"]];
        
        NewFeatureModel *m3 = [NewFeatureModel model:[UIImage imageNamed:@"welcome3"]];
        
        window.rootViewController = [CoreNewFeatureVC newFeatureVCWithModels:@[m1,m2,m3] enterBlock:^{
            
            NSLog(@"进入主页面");
            [self setRootViewController];
        }];
        
    }else {
        [self setRootViewController];
    }
    
    return YES;
}

-(void)setNotification{
    UILocalNotification *localNotification = [[UILocalNotification alloc] init];
    //设置时区（跟随手机的时区）
    localNotification.timeZone = [NSTimeZone defaultTimeZone];
    if (localNotification) {
        localNotification.alertBody = @"今天发生了哪些有趣的事情呢？ -- 好记，记录好时光";
//        localNotification.alertAction = @"";
        //小图标数字
        localNotification.applicationIconBadgeNumber = 1;
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"HH:mm:ss"];
        NSDate *date = [formatter dateFromString:@"11:20:00"];
 
        //通知发出的时间
        localNotification.fireDate = date;
    }
    //循环通知的周期
    localNotification.repeatInterval = kCFCalendarUnitDay;
    
    //设置userinfo方便撤销
    NSDictionary *info = [NSDictionary dictionaryWithObject:@"name" forKey:@"key"];
    localNotification.userInfo = info;
    //启动任务
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
}
- (void)registerLocalNotification
{
    //创建UIUserNotificationSettings，并设置消息的显示类类型
 
    UIUserNotificationSettings *uns = [UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound) categories:nil];
    
}


// 本地通知回调函数，当应用程序在前台时调用
- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    NSLog(@"%@", notification.userInfo);
    [self showAlertView:@"只属于您的秘密日记。-- 好记，记录好时光"];
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

@end

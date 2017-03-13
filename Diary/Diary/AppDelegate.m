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

@interface AppDelegate ()<GuideViewDelegate>

@property (strong, nonatomic) NSArray *imageArray;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
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

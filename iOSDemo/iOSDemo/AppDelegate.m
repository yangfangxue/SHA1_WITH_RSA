//
//  AppDelegate.m
//  iOSDemo
//
//  Created by 杨芳学 on 2021/6/11.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import <SVProgressHUD/SVProgressHUD.h>

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    // MARK: 指示器
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    [SVProgressHUD setDefaultAnimationType:SVProgressHUDAnimationTypeNative];
    [SVProgressHUD setMaximumDismissTimeInterval:7.f];
    [SVProgressHUD setMinimumDismissTimeInterval:1.5f];
    
    // MARK: Window
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    if (@available(iOS 13.0, *)) self.window.overrideUserInterfaceStyle = UIUserInterfaceStyleLight;
    self.window.backgroundColor = [UIColor whiteColor];
    self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:[[ViewController alloc] init]];
    [self.window makeKeyAndVisible];
    
    return YES;
}



@end

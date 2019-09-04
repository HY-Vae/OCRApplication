//
//  AppDelegate.m
//  OCRApplication
//
//  Created by 李志刚 on 2019/9/3.
//  Copyright © 2019 李志刚. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    ViewController *homeVC = [[ViewController alloc]init];
    UINavigationController *naviControl = [[UINavigationController alloc]initWithRootViewController:homeVC];
    self.window.rootViewController = naviControl;
    [self.window makeKeyAndVisible];
    
    return YES;
}

@end

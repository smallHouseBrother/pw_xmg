//
//  AppDelegate.m
//  XMG
//
//  Created by 小马哥 on 2018/1/24.
//  Copyright © 2018年 小马哥. All rights reserved.
//

#import "AppDelegate.h"
#import <UMMobClick/MobClick.h>
#import <UShareUI/UShareUI.h>
#import <Bugly/Bugly.h>
#import "RootViewController.h"
#import "AuthViewController.h"

@interface AppDelegate () <AuthViewControllerDelegate>
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [self setUMShare];
    [self setUMMoblic];
    [self setBugly];
    [GADMobileAds configureWithApplicationID:AdMobId];
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    RootViewController * rootVC = [[RootViewController alloc] init];
    XGNavigationController * rootNavi = [[XGNavigationController alloc] initWithRootViewController:rootVC];
    self.window.rootViewController = rootNavi;
    [self.window makeKeyAndVisible];

    [self requestFingerAuth];
    
    return YES;
}

- (void)requestFingerAuth
{
    return;
    AuthViewController * auth = [[AuthViewController alloc] init];
    
    auth.delegate = self;
    
    [self.window.rootViewController presentViewController:auth animated:YES completion:nil];
}

#pragma mark - AuthViewControllerDelegate
- (void)returnAuthResult:(BOOL)isSuccess
{
    ///解锁成功
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    [self requestFingerAuth];
}

#pragma mark - 友盟分享
- (void)setUMShare {
    [[UMSocialManager defaultManager] setUmSocialAppkey:UM_AppKey];
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:WeChat_AppKey appSecret:WeChat_Secret redirectURL:RedirectURL];
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_QQ appKey:QQ_AppKey appSecret:nil redirectURL:RedirectURL];
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_Sina appKey:Sina_AppKey  appSecret:Sina_Secret redirectURL:RedirectURL];
}

#pragma mark - 友盟统计
- (void)setUMMoblic {
    UMConfigInstance.appKey = UM_AppKey;
    [MobClick setAppVersion:[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]];
    [MobClick startWithConfigure:UMConfigInstance];
}

#pragma mark - bugly
- (void)setBugly {
    [Bugly startWithAppId:Bugly_Key];
    BuglyConfig *config = [[BuglyConfig alloc] init];
    config.debugMode = IsDebug;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{///支持所有iOS系统
    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url sourceApplication:sourceApplication annotation:annotation];
    if (!result) {
        // 其他如支付等SDK的回调
    }
    return result;
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options
{///仅支持iOS9以上系统，iOS8及以下系统不会回调
    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url options:options];
    if (!result) {
        // 其他如支付等SDK的回调
    }
    return result;
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{///支持目前所有iOS系统
    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url];
    if (!result) {
        // 其他如支付等SDK的回调
    }
    return result;
}

@end

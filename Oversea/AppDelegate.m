//
//  AppDelegate.m
//  Oversea
//
//  Created by Zhouboli on 15/10/29.
//  Copyright © 2015年 Bankwel. All rights reserved.
//

#import "AppDelegate.h"
#import "OSChatListViewController.h"
#import <RongIMKit/RongIMKit.h>

//暂时使用API调试器生成的token
static NSString *RONGCLOUD_IM_USER_TOKEN = @"fBuDHDfihoRm2QVfO8eZhuCa9u6Wz+0Z+0vIpP8q7KfUFDM0xM0w0SchcVSb4j+hoF2FkCOXNn/bXTcqxsRsLg==";
static NSString *RONGCLOUD_IM_APPKEY = @"vnroth0kr9zho";
static NSString *RONGCLOUD_USER_ID = @"testid";
static NSString *RONGCLOUD_NAME = @"testname";

@interface AppDelegate () <RCIMUserInfoDataSource> //RCIMConnectionStatusDelegate

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [self setupRongCloud];
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    OSChatListViewController *clvc = [[OSChatListViewController alloc] initWithDisplayConversationTypes:@[@(0)] collectionConversationType:@[@(0)]]; //默认会话类型
    clvc.view.backgroundColor = [UIColor whiteColor];
    UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:clvc];
    self.window.rootViewController = nvc;
    [self.window makeKeyAndVisible];
    
    //推送处理
    if ([application respondsToSelector:@selector(registerUserNotificationSettings:)])
    {
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge|UIUserNotificationTypeSound|UIUserNotificationTypeAlert categories:nil];
        [application registerUserNotificationSettings:settings];
    }
    else
    {
        NSLog(@"推送处理错误");
    }
    
    return YES;
}

-(void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    //注册用户通知设置
    [application registerForRemoteNotifications];
}

-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSLog(@"device token: %@", deviceToken.description);
    
    //首先处理接收到的token
    NSString *token = [[[deviceToken.description
                         stringByReplacingOccurrencesOfString:@"<" withString:@""]
                        stringByReplacingOccurrencesOfString:@">" withString:@""]
                       stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    //给客户端设置deviceToken
    [[RCIMClient sharedRCIMClient] setDeviceToken:token];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

-(void)setupRongCloud
{
    //设置AppKey
    [[RCIM sharedRCIM] initWithAppKey:RONGCLOUD_IM_APPKEY];
    
    //设置本地用户信息
    RCUserInfo *userInfo = [[RCUserInfo alloc] initWithUserId:RONGCLOUD_USER_ID name:RONGCLOUD_NAME portrait:nil];
    [[RCIM sharedRCIM] setCurrentUserInfo:userInfo];
    
    //设置获取用户信息数据源
    [[RCIM sharedRCIM] setUserInfoDataSource:self];
    
    //设置连接代理
    //[[RCIM sharedRCIM] setConnectionStatusDelegate:self];
    
    //使用获取到的token连接融云服务器
    [[RCIM sharedRCIM] connectWithToken:RONGCLOUD_IM_USER_TOKEN
                                success:^(NSString *userId)
     {
         NSLog(@"success: %@", userId);
     }
                                  error:^(RCConnectErrorCode status)
     {
         NSLog(@"error: %ld", (long)status);
     }
                         tokenIncorrect:^
     {
         NSLog(@"token incorrect");
     }];
}

#pragma mark - RCIMUserInfoDataSource

-(void)getUserInfoWithUserId:(NSString *)userId completion:(void (^)(RCUserInfo *))completion
{
    NSLog(@"getUserInfoWithUserId: %@", userId);
}

#pragma mark - RCIMConnectionStatusDelegate



@end

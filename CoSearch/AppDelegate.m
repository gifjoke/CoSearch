//
//  AppDelegate.m
//  CoSearch
//
//  Created by Fnoz on 15/9/10.
//  Copyright (c) 2015年 Fnoz. All rights reserved.
//

#import "AppDelegate.h"
#import "SearchType.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

static AppDelegate *lofterApp = nil;

+ (AppDelegate *)sharedAppDelegate {
    if (!lofterApp) {
        lofterApp = [[AppDelegate alloc] init];
    }
    return lofterApp;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    AppDelegate *appDelegate = [AppDelegate sharedAppDelegate];
    appDelegate.searchTypeArray = [NSMutableArray array];
    
    
    SearchType *searchType0 = [[SearchType alloc] init];
    searchType0.searchTypeName = @"百度";
    searchType0.searchTypeModel = @"https://www.baidu.com/s?wd=%@";
    searchType0.searchTypeImageName = @"baidu";
    searchType0.searchTypeId = 0;
    searchType0.offsetY = 92;
    [appDelegate.searchTypeArray addObject:searchType0];
    
    SearchType *searchType1 = [[SearchType alloc] init];
    searchType1.searchTypeName = @"必应";
    searchType1.searchTypeModel = @"http://cn.bing.com/search?q=%@";
    searchType1.searchTypeImageName = @"bing";
    searchType1.searchTypeId = 1;
    searchType1.offsetY = 133;
    [appDelegate.searchTypeArray addObject:searchType1];
    
    SearchType *searchType2 = [[SearchType alloc] init];
    searchType2.searchTypeName = @"谷歌";
    searchType2.searchTypeModel = @"http://google.sidney-aldebaran.me/search?q=%@";
    searchType2.searchTypeImageName = @"google";
    searchType2.searchTypeId = 2;
    searchType2.offsetY = 105;
    [appDelegate.searchTypeArray addObject:searchType2];
    
    SearchType *searchType3 = [[SearchType alloc] init];
    searchType3.searchTypeName = @"好搜";
    searchType3.searchTypeModel = @"http://www.haosou.com/s?q=%@";
    searchType3.searchTypeImageName = @"haosou";
    searchType3.searchTypeId = 3;
    searchType3.offsetY = 97;
    [appDelegate.searchTypeArray addObject:searchType3];
    
    SearchType *searchType4 = [[SearchType alloc] init];
    searchType4.searchTypeName = @"微博";
    searchType4.searchTypeModel = @"http://s.weibo.com/weibo/%@";
    searchType4.searchTypeImageName = @"weibo";
    searchType4.searchTypeId = 4;
    searchType4.offsetY = 52;
    [appDelegate.searchTypeArray addObject:searchType4];
    
    SearchType *searchType5 = [[SearchType alloc] init];
    searchType5.searchTypeName = @"搜狗";
    searchType5.searchTypeModel = @"http://wap.sogou.com/web/searchList.jsp?keyword=%@";
    searchType5.searchTypeImageName = @"sougou";
    searchType5.searchTypeId = 5;
    searchType5.offsetY = 92;
    [appDelegate.searchTypeArray addObject:searchType5];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end

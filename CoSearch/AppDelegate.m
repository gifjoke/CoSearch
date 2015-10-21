//
//  AppDelegate.m
//  CoSearch
//
//  Created by Fnoz on 15/9/10.
//  Copyright (c) 2015年 Fnoz. All rights reserved.
//

#import "AppDelegate.h"
#import "SearchType.h"
#import "AFNetworking.h"
#import "Database.h"

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
    
    [self getAdjustedGoogleUrl];
    
    Database *db = [Database sharedFMDBSqlite];
    appDelegate.searchTypeArray = [[db getSearchTypeInDB] copy];
    
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

- (void)getAdjustedGoogleUrl
{
    NSString *str=[NSString stringWithFormat:@"http://7xl2dx.com1.z0.glb.clouddn.com/coSearch_adjustedGoogleUrl.txt"];
    NSURL *url = [NSURL URLWithString:[str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc]initWithRequest:request];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *adjustedGoogleUrlStr = operation.responseString;
        SearchType *searchType = [[SearchType alloc] init];
        searchType.searchTypeName = @"谷歌";
        searchType.searchTypeModel = adjustedGoogleUrlStr;
        searchType.searchTypeImageName = @"google";
        searchType.searchTypeId = 2;
        searchType.offsetY = 105;
        Database *db = [Database sharedFMDBSqlite];
        [db insertOrUpdateSearchType:searchType];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        ;
    }];
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [queue addOperation:operation];
}

@end

//
//  AppDelegate.h
//  CoSearch
//
//  Created by Fnoz on 15/9/10.
//  Copyright (c) 2015年 Fnoz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) NSMutableArray *searchTypeArray;
@property (strong, nonatomic) NSMutableDictionary *searchTypeAndSearchStringDic;

+ (AppDelegate *)sharedAppDelegate;

@end


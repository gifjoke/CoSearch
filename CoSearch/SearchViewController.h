//
//  SearchViewController.h
//  CoSearch
//
//  Created by Fnoz on 15/9/11.
//  Copyright (c) 2015年 Fnoz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchViewController : UIViewController

@property (nonatomic, strong) NSString *urlFormatStr;
@property (nonatomic, strong) NSString *oriSearchKey;
@property (nonatomic, assign) NSInteger searchTypeIndex;

@end

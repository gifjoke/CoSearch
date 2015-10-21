//
//  Datebase.h
//  CoSearch
//
//  Created by Fnoz on 15/10/21.
//  Copyright © 2015年 Fnoz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDB.h"

@class SearchType;

@interface Database : NSObject

+ (Database *)sharedFMDBSqlite;

- (NSArray *)getSearchTypeInDB;
- (void)insertOrUpdateSearchType:(SearchType *)searchType;

@end

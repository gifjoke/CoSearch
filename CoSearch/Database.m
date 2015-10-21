//
//  Datebase.m
//  CoSearch
//
//  Created by Fnoz on 15/10/21.
//  Copyright © 2015年 Fnoz. All rights reserved.
//

#import "Database.h"
#import "SearchType.h"

@interface Database()
{
    FMDatabase *db;
}
@end

@implementation Database

static Database *sharedSqlite = nil;

+ (Database *)sharedFMDBSqlite
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedSqlite = [[Database alloc] initDB];
    });
    
    return sharedSqlite;
}

- (id)initDB
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [paths objectAtIndex: 0];
    NSString *dbPath = [documentDirectory stringByAppendingPathComponent: @"coSearch.sqlite"];
    db = [[FMDatabase alloc] initWithPath:dbPath];
    if (![self openDb:db])
    {
        NSLog(@"Database open failed!");
        return nil;
    }
    [db setShouldCacheStatements:YES];
    if (![self isTableOK:@"coSearch_searchType_list" inDB:db]) {
        [db executeUpdate:@"CREATE TABLE coSearch_searchType_list(`searchTypeName` varchar(128), `searchTypeImageName` varchar(128), `searchTypeModel` varchar(128), `searchTypeId` integer, `offsetY` float);"];
        NSArray *array = [self originSearchType];
        [self insertOrUpdateSearchTypeList:array];
    }
    return self;
}

- (NSArray *)originSearchType
{
    NSMutableArray *array = [NSMutableArray array];
    
    SearchType *searchType = [[SearchType alloc] init];
    searchType.searchTypeName = @"百度";
    searchType.searchTypeModel = @"https://www.baidu.com/s?wd=%@";
    searchType.searchTypeImageName = @"baidu";
    searchType.searchTypeId = 0;
    searchType.offsetY = 92;
    [array addObject:searchType];
    
    searchType = [[SearchType alloc] init];
    searchType.searchTypeName = @"必应";
    searchType.searchTypeModel = @"http://cn.bing.com/search?q=%@";
    searchType.searchTypeImageName = @"bing";
    searchType.searchTypeId = 1;
    searchType.offsetY = 133;
    [array addObject:searchType];
    
    searchType = [[SearchType alloc] init];
    searchType.searchTypeName = @"谷歌";
    searchType.searchTypeModel = @"http://google.sidney-aldebaran.me/search?q=%@";
    searchType.searchTypeImageName = @"google";
    searchType.searchTypeId = 2;
    searchType.offsetY = 105;
    [array addObject:searchType];
    
    searchType = [[SearchType alloc] init];
    searchType.searchTypeName = @"Yahoo";
    searchType.searchTypeModel = @"https://search.yahoo.com/search?p=%@";
    searchType.searchTypeImageName = @"yahoo";
    searchType.searchTypeId = 3;
    searchType.offsetY = 46;
    [array addObject:searchType];
    
    searchType = [[SearchType alloc] init];
    searchType.searchTypeName = @"微信文章";
    searchType.searchTypeModel = @"http://weixin.sogou.com/weixinwap?type=2&query=%@";
    searchType.searchTypeImageName = @"wechatArticle";
    searchType.searchTypeId = 4;
    searchType.offsetY = 100;
    [array addObject:searchType];
    
    searchType = [[SearchType alloc] init];
    searchType.searchTypeName = @"微博";
    searchType.searchTypeModel = @"http://s.weibo.com/weibo/%@";
    searchType.searchTypeImageName = @"weibo";
    searchType.searchTypeId = 5;
    searchType.offsetY = 52;
    [array addObject:searchType];
    
    return array;
}

- (BOOL)openDb:(FMDatabase *)database
{
    return [database open];
}

- (BOOL)closeDb:(FMDatabase *)database
{
    BOOL result = [database close];
    return result;
}

- (void)insertOrUpdateSearchType:(SearchType *)searchType
{
    [db setShouldCacheStatements:YES];
    FMResultSet *rs = [db executeQuery:@"SELECT * FROM coSearch_searchType_list WHERE `searchTypeId` = ?", [NSNumber numberWithInteger:searchType.searchTypeId]];
    if ([rs next])
    {
        [db executeUpdate:@"UPDATE coSearch_searchType_list SET `searchTypeName` = ?, `searchTypeImageName` = ?, `searchTypeModel` = ?, `offsetY` = ? WHERE `searchTypeId` = ?;", searchType.searchTypeName, searchType.searchTypeImageName, searchType.searchTypeModel, [NSNumber numberWithFloat:searchType.offsetY], [NSNumber numberWithInteger:searchType.searchTypeId]];
    }
    else
    {
        [db executeUpdate:@"INSERT INTO coSearch_searchType_list(`searchTypeName`, `searchTypeImageName`, `searchTypeModel`, `searchTypeName`, `offsetY`) VALUES (?, ?, ?, ?, ?);", searchType.searchTypeName, searchType.searchTypeImageName, searchType.searchTypeModel, [NSNumber numberWithInteger:searchType.searchTypeId], [NSNumber numberWithFloat:searchType.offsetY]];
    }
}

- (void)insertOrUpdateSearchTypeList:(NSArray *)list
{
    for (SearchType *searchType in list) {
        [self insertOrUpdateSearchType:searchType];
    }
}

- (NSArray *)getSearchTypeInDB
{
    NSMutableArray *list = [[NSMutableArray alloc] init];
    [db setShouldCacheStatements:YES];
    FMResultSet *rs = [db executeQuery:@"SELECT * FROM coSearch_searchType_list;"];
    while ([rs next])
    {
        SearchType *searchType = [[SearchType alloc] init];
        searchType.searchTypeName = [rs stringForColumn:@"searchTypeName"];
        searchType.searchTypeImageName = [rs stringForColumn:@"searchTypeImageName"];
        searchType.searchTypeModel = [rs stringForColumn:@"searchTypeModel"];
        searchType.searchTypeId = [[rs stringForColumn:@"searchTypeName"] integerValue];
        searchType.offsetY = [[rs stringForColumn:@"offsetY"] floatValue];
        [list addObject:searchType];
    }
    return list;
}

- (BOOL)isTableOK:(NSString *)tableName inDB:(FMDatabase *)dbTmp
{
    FMResultSet *rs = [dbTmp executeQuery:@"select count(*) as 'count' from sqlite_master where type ='table' and name = ?", tableName];
    while ([rs next])
    {
        NSInteger count = [rs intForColumn:@"count"];
        if (0 == count)
        {
            return NO;
        }
        else
        {
            return YES;
        }
    }
    return NO;
}

@end

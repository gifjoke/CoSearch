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
        [db executeUpdate:@"CREATE TABLE coSearch_searchType_list(`searchTypeName` varchar(128), `searchTypeImageName` varchar(128), `searchTypeModel` varchar(128), `searchTypeId` varchar(128), `offsetY` float);"];
        NSArray *array = [self originSearchType];
        [self insertOrUpdateSearchTypeList:array];
    }
    return self;
}

- (NSArray *)originSearchType
{
    NSMutableArray *array = [NSMutableArray array];
    NSInteger typeId = 0;
    
    SearchType *searchType = [[SearchType alloc] init];
    searchType.searchTypeName = @"百度";
    searchType.searchTypeModel = @"https://www.baidu.com/s?wd=%@";
    searchType.searchTypeImageName = @"baidu";
    searchType.searchTypeId = typeId++;
    searchType.offsetY = 92;
    [array addObject:searchType];
    
    searchType = [[SearchType alloc] init];
    searchType.searchTypeName = @"必应";
    searchType.searchTypeModel = @"http://cn.bing.com/search?q=%@";
    searchType.searchTypeImageName = @"bing";
    searchType.searchTypeId = typeId++;
    searchType.offsetY = 135;
    [array addObject:searchType];
    
    searchType = [[SearchType alloc] init];
    searchType.searchTypeName = @"谷歌";
    searchType.searchTypeModel = @"http://google.sidney-aldebaran.me/search?q=%@";
    searchType.searchTypeImageName = @"google";
    searchType.searchTypeId = typeId++;
    searchType.offsetY = 105;
    [array addObject:searchType];
    
    searchType = [[SearchType alloc] init];
    searchType.searchTypeName = @"Yahoo";
    searchType.searchTypeModel = @"https://search.yahoo.com/search?p=%@";
    searchType.searchTypeImageName = @"yahoo";
    searchType.searchTypeId = typeId++;
    searchType.offsetY = 48;
    [array addObject:searchType];
    
    searchType = [[SearchType alloc] init];
    searchType.searchTypeName = @"微博";
    searchType.searchTypeModel = @"http://s.weibo.com/weibo/%@";
    searchType.searchTypeImageName = @"weibo";
    searchType.searchTypeId = typeId++;
    searchType.offsetY = 52;
    [array addObject:searchType];
    
    searchType = [[SearchType alloc] init];
    searchType.searchTypeName = @"文章";
    searchType.searchTypeModel = @"http://weixin.sogou.com/weixinwap?type=2&query=%@";
    searchType.searchTypeImageName = @"wechatArticle";
    searchType.searchTypeId = typeId++;
    searchType.offsetY = 100;
    [array addObject:searchType];
    
    searchType = [[SearchType alloc] init];
    searchType.searchTypeName = @"知乎";
    searchType.searchTypeModel = @"http://www.zhihu.com/search?type=question&q=%@";
    searchType.searchTypeImageName = @"zhihu";
    searchType.searchTypeId = typeId++;
    searchType.offsetY = 65;
    [array addObject:searchType];
    
    searchType = [[SearchType alloc] init];
    searchType.searchTypeName = @"词典";
    searchType.searchTypeModel = @"http://wap.iciba.com/cword/%@";
    searchType.searchTypeImageName = @"dictionary";
    searchType.searchTypeId = typeId++;
    searchType.offsetY = 115;
    [array addObject:searchType];
    
    searchType = [[SearchType alloc] init];
    searchType.searchTypeName = @"淘宝";
    searchType.searchTypeModel = @"http://s.m.taobao.com/h5?q=%@";
    searchType.searchTypeImageName = @"taobao";
    searchType.searchTypeId = typeId++;
    searchType.offsetY = 85;
    [array addObject:searchType];
    
    searchType = [[SearchType alloc] init];
    searchType.searchTypeName = @"丁香";
    searchType.searchTypeModel = @"http://m.dxy.com/search/index?keyword=%@";
    searchType.searchTypeImageName = @"dingxiang";
    searchType.searchTypeId = typeId++;
    searchType.offsetY = 52;
    [array addObject:searchType];
    
    searchType = [[SearchType alloc] init];
    searchType.searchTypeName = @"小说";
    searchType.searchTypeModel = @"http://book.easou.com/ta/search.m?q=%@";
    searchType.searchTypeImageName = @"novel";
    searchType.searchTypeId = typeId++;
    searchType.offsetY = 75;
    [array addObject:searchType];
    
    searchType = [[SearchType alloc] init];
    searchType.searchTypeName = @"图片";
    searchType.searchTypeModel = @"http://image.baidu.com/search/wiseala?tn=wiseala&fmpage=search&word=%@";
    searchType.searchTypeImageName = @"baiduImage";
    searchType.searchTypeId = typeId++;
    searchType.offsetY = 90;
    [array addObject:searchType];
    
    searchType = [[SearchType alloc] init];
    searchType.searchTypeName = @"音乐";
    searchType.searchTypeModel = @"http://m.xiami.com/#!/search/result/?key=%@";
    searchType.searchTypeImageName = @"xiamiMusic";
    searchType.searchTypeId = typeId++;
    searchType.offsetY = 100;
    [array addObject:searchType];
    
    searchType = [[SearchType alloc] init];
    searchType.searchTypeName = @"视频";
    searchType.searchTypeModel = @"http://m.iqiyi.com/search.html?source=input&key=%@";
    searchType.searchTypeImageName = @"aiqiyiVideo";
    searchType.searchTypeId = typeId++;
    searchType.offsetY = 100;
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
    [db setShouldCacheStatements:NO];
//    FMResultSet *rs = [db executeQuery:[NSString stringWithFormat:@"SELECT * FROM coSearch_searchType_list WHERE `searchTypeId` = %@;",[NSNumber numberWithInteger:searchType.searchTypeId]]];
    FMResultSet *rs = [db executeQuery:@"SELECT * FROM coSearch_searchType_list WHERE `searchTypeId` = ?;",[NSString stringWithFormat:@"%ld",(long)searchType.searchTypeId]];
    if ([rs next])
    {
        [db executeUpdate:@"UPDATE coSearch_searchType_list SET `searchTypeName` = ?, `searchTypeImageName` = ?, `searchTypeModel` = ?, `offsetY` = ? WHERE `searchTypeId` = ?;", searchType.searchTypeName, searchType.searchTypeImageName, searchType.searchTypeModel, [NSNumber numberWithFloat:searchType.offsetY], [NSString stringWithFormat:@"%ld",(long)searchType.searchTypeId]];
    }
    else
    {
        [db executeUpdate:@"INSERT INTO coSearch_searchType_list (`searchTypeName`, `searchTypeImageName`, `searchTypeModel`, `searchTypeId`, `offsetY`) VALUES (?, ?, ?, ?, ?);", searchType.searchTypeName, searchType.searchTypeImageName, searchType.searchTypeModel, [NSString stringWithFormat:@"%ld",(long)searchType.searchTypeId], [NSNumber numberWithFloat:searchType.offsetY]];
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
        searchType.searchTypeId = [[rs stringForColumn:@"searchTypeId"] integerValue];
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

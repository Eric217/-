//
//  SQLiteManager.m
//  DS_playgound
//
//  Created by Eric on 2018/7/25.
//  Copyright © 2018 SDU_iOS_LAB. All rights reserved.
//

#import "SQLiteManager.h"
#import <sqlite3.h>
#import "Common.h"

@interface SQLiteManager ()

@property (nonatomic, assign) sqlite3 *db;


@end

@implementation SQLiteManager

static SQLiteManager *_sharedInstance;



+ (id)shared {
    @synchronized (self) {
        if (!_sharedInstance) {
            _sharedInstance = [[self alloc] init];
            _sharedInstance.sqlOpened = [_sharedInstance openDB];
        }
    
        return _sharedInstance;
    }
}

- (void)setSqlOpened:(bool)sqlOpened {
    _sqlOpened = sqlOpened;
}

/// 程序打开或第一次初始化本单例类时，open 一次，程序退出时 close
- (BOOL)openDB {
    // 获取沙盒路径,将数据库放入沙盒中
    NSString *filePath  = [[Config documentPath] stringByAppendingPathComponent:SQLiteFile];
 
    if (sqlite3_open(filePath.UTF8String, &_db) != SQLITE_OK)
        return 0; // file open error
  
    NSArray *result = [self querySQL:@"select count(1) c from sqlite_master where type = 'table' and name = 'graph';"];
    if (!result || result.count == 0)
        return 0;
    bool created = [result[0][@"c"] boolValue];
    if (!created)
        [self initAllTables];
    return 1;

}

- (void)initAllTables {
    
    // for graph:
    [self execSQL:@"create table graph (gid integer primary key autoincrement, gname text unique, nodecount integer);"];
    [self execSQL:@"create table graph_node (nid integer primary key autoincrement, gid integer not null, nname text, centerx real, centery real, gorder integer);"];
    [self execSQL:@"create table graph_edge (eid integer primary key autoincrement, gid integer not null, n_s_o integer, n_e_o integer, weight integer);"];
    
    [self execSQL:[NSString stringWithFormat:@"insert into graph (gid, gname, nodecount) values (0, '%@', 10);", DefaultGraph]];
    
    [self execSQL:@"insert into graph_node (gid,nname,centerx,centery,gorder) select 0,1,0.12,0.13,1 union all select 0,2,0.12,0.5,2 union all select 0,3,0.78,0.5,3 union all select 0,4,0.42,0.82,4 union all select 0,5,0.48,0.5,5 union all select 0,6,0.48,0.14,6 union all select 0,7,0.82,0.88,7 union all select 0,8,0.94,0.4,8 union all select 0,9,0.14,0.84,9 union all select 0,10,0.83,0.13,10"];
    
    [self execSQL:@"insert into graph_edge (gid,n_s_o,n_e_o,weight) select 0,1,2,12 union all select 0,1,5,10 union all select 0,1,6,9 union all select 0,2,5,26 union all select 0,2,9,16 union all select 0,3,5,18 union all select 0,3,4,22 union all select 0,3,7,28 union all select 0,4,9,5 union all select 0,4,7,13 union all select 0,3,8,15 union all select 0,4,5,7 union all select 0,5,6,8 union all select 0,6,10,15 union all select 0,8,10,18"];
   
   
}

- (BOOL)execSQL:(NSString *)sql {
    // 1> 参数一:数据库sqlite3对象
    // 2> 参数二:执行的sql语句
    return sqlite3_exec(self.db, sql.UTF8String, nil, nil, nil) == SQLITE_OK;
}

#pragma mark - 查询数据
- (NSArray *)querySQL:(NSString *)querySQL
{
    // 定义游标对象
    sqlite3_stmt *stmt = nil;
    
    // 准备工作(获取查询的游标对象)
    // 1> 参数三:查询语句的长度, -1自动计算
    // 2> 参数四:查询的游标对象地址
    if (sqlite3_prepare_v2(self.db, querySQL.UTF8String, -1, &stmt, nil) != SQLITE_OK) {
        return 0;
    }
    
    // 取出某一个行数的数据
    NSMutableArray *tempArray = [NSMutableArray array];
    // 获取字段的个数
    int count = sqlite3_column_count(stmt);
    while (sqlite3_step(stmt) == SQLITE_ROW) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        for (int i = 0; i < count; i++) {
            // 1.取出当前字段的名称(key)
            NSString *key = [NSString stringWithUTF8String:sqlite3_column_name(stmt, i)];
            
            // 2.取出当前字段对应的值(value)
            const char *cValue = (const char *)sqlite3_column_text(stmt, i);
            NSString *value = [NSString stringWithUTF8String:cValue];
            
            // 3.将键值对放入字典中
            [dict setObject:value forKey:key];
        }
        
        [tempArray addObject:dict];
    }
    
    // 不再使用游标时,需要释放对象
    sqlite3_finalize(stmt);
    
    return tempArray;
}

- (void)dealloc {
    sqlite3_close(_db);
}

@end

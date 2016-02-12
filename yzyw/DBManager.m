//
//  DBManager.m
//  Garden
//
//  Created by 金学利 on 9/8/15.
//  Copyright (c) 2015 Kingxl. All rights reserved.
//

#import "DBManager.h"
#import <FMDatabase.h>
#import <FMResultSet.h>


#define DBNAME @"Lynp.sqlite"


@implementation DBManager

+ (instancetype)instance
{
    static DBManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[DBManager alloc] init];
    });
    
    return manager;
}


- (void)createDB
{
    FMDatabase *db= [FMDatabase databaseWithPath:[self getDBPath]] ;
    if (![db open]) {
        return ;
    }
    
//    [db executeUpdate:@"CREATE TABLE IF NOT EXISTS ITEMS (ID INTEGER PRIMARY KEY AUTOINCREMENT, id text, name text,photo text,price float,size integer,count integer)"];
    [db executeUpdate:@"CREATE TABLE IF NOT EXISTS ITEMS (id text, name text,photo text,price float,size integer,count integer)"];
    
    [db close];

}

- (void)saveItem:data count:(NSInteger)count
{
    
    FMDatabase *db= [FMDatabase databaseWithPath:[self getDBPath]] ;
    if (![db open]) {
        return ;
    }

    [db executeUpdate:[NSString stringWithFormat:@"insert into ITEMS (id, name, photo, size, price,count) VALUES('%@', '%@', '%@', '%@', '%@', '%ld')",data[@"id"], data[@"name"], data[@"photo"], data[@"size"], data[@"price"], (long)count]];
    
    [db close];
}


- (void)deleteItem:data
{
    FMDatabase *db= [FMDatabase databaseWithPath:[self getDBPath]];
    if (![db open]) {
        return;
    }
   
    [db executeUpdate:[NSString stringWithFormat:@"delete from ITEMS where id = '%@'",data[@"id"]]];
    
    [db close];
}

- (void)updateItem:data count:(NSInteger)count
{
    FMDatabase *db= [FMDatabase databaseWithPath:[self getDBPath]] ;
    
    if (![db open]) {
        return;
    }
    
    if (count == 0) {
        
        NSString *sql = [NSString stringWithFormat:@"delete from ITEMS where id = '%@'",data[@"id"]];
        [db executeUpdate:sql];
        
    }else{
    
        NSString *sql = [NSString stringWithFormat:@"update ITEMS set count = '%@' where id = '%@'",@(count),data[@"id"]];
        
        [db executeUpdate:sql];
    }
    
    [db close];
}


//- (NSInteger)countWithData:data
//{
//    FMDatabase *db= [FMDatabase databaseWithPath:[self getDBPath]] ;
//    
//    NSInteger count = 0;
//    
//    if (![db open]) {
//        return count;
//    }
//    
//    NSString *sql = [NSString stringWithFormat:@"select * from GOODS where id= '%@'",@(data.tid)];
//    
//    FMResultSet *rs = [db executeQuery:sql];
//
//    
//    while ([rs next]) {
//        count = [rs intForColumn:@"buycount"];
//    }
//    
//    [rs close];
//    [db close];
//    
//    return count;
//
//}


- (NSMutableArray *)getAllItems
{
    NSMutableArray *allData = [NSMutableArray arrayWithCapacity:10];

    
    FMDatabase *db= [FMDatabase databaseWithPath:[self getDBPath]] ;
    
    if (![db open]) {
        return allData;
    }

    
    
    NSString *sql = [NSString stringWithFormat:@"select * from ITEMS"];
    
    FMResultSet *rs = [db executeQuery:sql];

    while ([rs next]) {

        NSString *id = [rs stringForColumn:@"id" ];
        NSString  *name = [rs stringForColumn:@"name"];
        NSString  *photo = [rs stringForColumn:@"photo"];
        NSInteger size = [rs intForColumn:@"size"];
        NSString  *price =  [rs stringForColumn:@"price"];
        NSInteger count =  [rs intForColumn:@"count"];
        
        [allData addObject:[NSMutableDictionary dictionaryWithObjects:@[id,name,photo,@(size),price,@(count)] forKeys:@[@"id",@"name",@"photo",@"size",@"price",@"count"]]];
    }
    
    [rs close];
    
    [db close];
    
    return allData;
    
}


- (void)clearAllItem
{
    FMDatabase *db= [FMDatabase databaseWithPath:[self getDBPath]] ;
    
    if (![db open]) {
        return;
    }
    
    [db executeUpdate:@"delete from ITEMS"];
    
    [db close];

}


//path for db
- (NSString *)getDBPath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documents = [paths objectAtIndex:0];
    NSString *database_path = [documents stringByAppendingPathComponent:DBNAME];
    
    return database_path;
}


@end

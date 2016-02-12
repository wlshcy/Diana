//
//  DBManager.h
//  Garden
//
//  Created by 金学利 on 9/8/15.
//  Copyright (c) 2015 Kingxl. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface DBManager : NSObject

+ (instancetype)instance;
- (void)createDB;

- (void)saveItem:data count:(NSInteger)count;
- (void)deleteItem:data;
- (void)updateItem:data count:(NSInteger)count;



- (NSMutableArray *)getAllItems; /// tcdata array

- (void)clearAllItem;


@end

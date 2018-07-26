//
//  SQLiteManager.h
//  DS_playgound
//
//  Created by Eric on 2018/7/25.
//  Copyright © 2018 SDU_iOS_LAB. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SQLiteManager : NSObject

@property (nonatomic, assign, readonly) bool sqlOpened;

+ (instancetype)shared;

- (BOOL)openDB;

- (BOOL)execSQL:(NSString *)sql;

- (NSArray *)querySQL:(NSString *)querySQL;

@end

//
//  SorterProtocol.h
//  SortReveal
//
//  Created by Eric on 2018/4/25.
//  Copyright © 2018 Eric. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Common.h"

///排序类 必须遵循的接口
@protocol Sorter <NSObject>

@property (nonatomic, assign) SortOrder sortOrder;
 
- (void)initializeWithArray:(NSMutableArray *)array order:(SortOrder)order;

- (void)lastStep;

- (NSDictionary *)nextTurn:(BOOL *)finished;
- (NSDictionary *)nextRow:(BOOL *)finished;
- (NSDictionary *)initialSortData;

@end

 



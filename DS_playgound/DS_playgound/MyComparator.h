//
//  MyComparator.h
//  SortReveal
//
//  Created by Eric on 2018/5/15.
//  Copyright © 2018 Eric. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Compare.h"
 
@interface MyComparator : NSObject <Comparator>

+ (MyComparator *)shared;

@end

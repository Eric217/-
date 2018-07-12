//
//  SorterProtocol.h
//  SortReveal
//
//  Created by Eric on 2018/4/25.
//  Copyright © 2018 Eric. All rights reserved.
//

#import <Foundation/Foundation.h>
 
@protocol Comparable <NSObject>

- (bool)compareTo:(id <Comparable>)b;

@end


@protocol Comparator <NSObject>

- (bool)compareCustomObj:(id <Comparable>)a with:(id <Comparable>)b order:(bool)lower;

- (bool)compareByNumber:(double)a with:(double)b order:(bool)lower;
- (bool)compareByChar:(NSString *)a with:(NSString *)b order:(bool)lower;
- (bool)compareByDict:(NSString *)a with:(NSString *)b order:(bool)lower;
- (bool)compareByAutomatic:(NSString *)a with:(NSString *)b order:(bool)lower;

@end



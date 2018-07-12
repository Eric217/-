//
//  SortBaseClass.m
//  SortReveal
//
//  Created by Eric on 2018/4/25.
//  Copyright © 2018 Eric. All rights reserved.
//

#import "SortBaseClass.h"
#import "MyComparator.h"
 
@implementation SortBaseClass

- (id)init {
    self = [super init];
    historyArr = [NSMutableArray new];
    return self;
}

- (void)initializeWithArray:(NSMutableArray *)array order:(SortOrder)order {
    self.sortOrder = order;
    dataArr = [[NSMutableArray alloc] initWithArray:array];
}

///返回1则要交换
- (bool)compareIndex:(int)a with:(int)b {
    NSString *x = dataArr[a];
    NSString *y = dataArr[b];
    return [self compareValue:x with:y];
}

///返回1则要交换
- (bool)compareValue:(NSString *)x with:(NSString *)y {
    SortOrder order = self.sortOrder;
    bool asc = order % 10; //降序为true
    NSUInteger i = order/10; //0 num, 1 char, 2 dict, 3 auto
    
    if (i == 0) {
        double x1 = x.doubleValue, y1 = y.doubleValue;
        return [MyComparator.shared compareByNumber:x1 with:y1 order:asc];
    } else if (i == 1) { //二竟然比三大: 20108 VS 19977
        return [MyComparator.shared compareByChar:x with:y order:asc];
    } else if (i == 2) {
        return [MyComparator.shared compareByDict:x with:y order:asc];
    } else if (i == 3) {
        asc = [NSUserDefaults.standardUserDefaults boolForKey:kAutomaticOrderASD];
        return [MyComparator.shared compareByAutomatic:x with:y order:asc];
    }
    return 0;
}

- (void)swap:(int)i with:(int)j {
    NSString *temp = dataArr[i];
    dataArr[i] = dataArr[j];
    dataArr[j] = temp;
}


@synthesize sortOrder;
- (NSDictionary *)initialSortData {
    return 0;
}
- (void)lastStep {
}
- (NSDictionary *)nextRow:(BOOL *)finished {
    return 0;
}
- (NSDictionary *)nextTurn:(BOOL *)finished {
    return 0;
}

@end


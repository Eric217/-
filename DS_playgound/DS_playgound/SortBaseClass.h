//
//  SortReveal
//
//  Created by Eric on 2018/4/18.
//  Copyright © 2018 Eric. All rights reserved.
//

#import "Sorter.h"

@interface SortBaseClass : NSObject <Sorter> {
@public
    
    ///历史数据，每个子类自行处理
    NSMutableArray *historyArr;
    
    ///输入框内容的数组
    NSMutableArray<NSString *> *dataArr;
    
}

- (void)swap:(int)i with:(int)j;

- (bool)compareIndex:(int)a with:(int)b;

- (bool)compareValue:(NSString *)x with:(NSString *)y;

@end








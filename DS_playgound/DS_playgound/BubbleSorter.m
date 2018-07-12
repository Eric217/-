//
//  BubbleSorter.m
//  SortReveal
//
//  Created by Eric on 2018/4/18.
//  Copyright © 2018 Eric. All rights reserved.
//

#import "Sorters.h"

@interface BubbleSorter ()

@end

//historyArr内容格式：NSDictionary, kDataArr: dataArr & kPosition: CGPoint
//注意dataArr是deep copy到sorting的，hist中是reference，从hist中恢复时需要deep copy
@implementation BubbleSorter

- (NSDictionary *)nextTurn:(BOOL *)finished { //整体思路先把 *.* 去掉，只看 *
    int i = self.currentI, j = self.currentJ; //1
    NSMutableArray *toBeSavedArray = [[NSMutableArray alloc] initWithArray:dataArr];
    if (dataArr.count == 2) { //1.1
        if ([self compareIndex:0 with:1]) {
            [self swap:0 with:1];
        }
        *finished = 1;
    } else {
        
        bool needSwap = [self compareIndex:j with:j+1]; //2

        if (j == i - 2) { //3
            self.currentJ = 0;
            --self.currentI;
            if (self.currentI == 1 && self.currentJ == 0) {//5
                *finished = 1;
            }
        } else { //4
            ++self.currentJ;
        }
       
        if (needSwap) {//6
            [self swap:j with:j+1];
        } else if (!(*finished) && [NSUserDefaults.standardUserDefaults boolForKey:kSkipNullStep]) {//6.1
            return [self nextTurn:finished];
        }
    }
    
    //尽管会使sortingvc的view data全是同一片数组的引用，但不影响😄
    NSArray *data = [[NSArray alloc] initWithArray:dataArr]; //7
    [historyArr addObject:@{kDataArr: toBeSavedArray, kHistoryPosition: NSStringFromCGPoint(CGPointMake(i, j))}]; //10
    
    if (*finished) {//8
        NSDictionary *d = @{kDataArr: data};
        return d;
    } else {//9
        NSString *num0 = String(self.currentJ);
        NSString *num1 = String(self.currentJ+1);
        NSString *numI = String(self.currentI);
        //TODO: - color
        //NSArray *color = [NSArray arrayWithObjects:NSString stri UIColor.blackColor count:1];
        return @{kDataArr: data, kPositionArr: @[num0, num1, numI], kTitleArr: @[@"j", @"j+1", @"i"]};
    }
}

- (NSDictionary *)nextRow:(BOOL *)finished {
    int j = self.currentJ, i = self.currentI; //1
    NSMutableArray *toBeSavedArray = [[NSMutableArray alloc] initWithArray:dataArr];
    bool swapped = 0; //1.1
    
    for (int m = j; m < i - 1; m++) { //2
        if ([self compareIndex:m with:m+1]) {
            swapped = 1;
            [self swap:m with:m+1];
        }
    }
    self.currentI--;
    self.currentJ = 0;
    
    if (self.currentI == 1) {
        *finished = 1;
    }
    
    if (!swapped && !(*finished) && [NSUserDefaults.standardUserDefaults boolForKey:kSkipNullStep]) {
        return [self nextRow:finished];
    }
    
    [historyArr addObject:@{kDataArr: toBeSavedArray, kHistoryPosition: NSStringFromCGPoint(CGPointMake(i, j))}];
    NSArray *data = [[NSArray alloc] initWithArray:dataArr]; //
    if (*finished) {
        return @{kDataArr: data};
    } else {
        NSString *num0 = String(self.currentJ);
        NSString *num1 = String(self.currentJ+1);
        NSString *numI = String(self.currentI);
        //TODO: - color
        return @{kDataArr: data, kPositionArr: @[num0, num1, numI], kTitleArr: @[@"j", @"j+1", @"i"]};
    }
}

- (void)lastStep {
    NSDictionary *d = [historyArr lastObject];
    CGPoint p = CGPointFromString(d[kHistoryPosition]);
    dataArr = d[kDataArr];
    [historyArr removeLastObject];
    self.currentJ = p.y;
    self.currentI = p.x;
}
 

- (void)initializeWithArray:(NSMutableArray *)array order:(SortOrder)order {
    [super initializeWithArray:array order:order];
    self.currentI = (int)(array.count);
    self.currentJ = 0;
    
}

- (NSDictionary *)initialSortData {
    int c = (int)dataArr.count;
    if (c == 1) {
        return @{kDataArr: dataArr.copy};
    }
    return @{kPositionArr: @[@"0", @"1", String(c)],
             kTitleArr: @[@"j", @"j+1", @"i"],
             kDataArr: dataArr.copy};
    
}


@end


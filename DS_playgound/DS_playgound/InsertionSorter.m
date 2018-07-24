//
//  InsertionSorter.m
//  SortReveal
//
//  Created by Eric on 2018/4/18.
//  Copyright © 2018 Eric. All rights reserved.
//

#import "Sorters.h"
@interface InsertionSorter ()

//@property (nonatomic, assign) bool willSwap;
@property (nonatomic, copy) NSMutableArray *turnArray;
@end
 

///对于插入排序，currentI只是象征性的，currentJ+1才是与J比较的对象。
@implementation InsertionSorter

- (NSDictionary *)nextRow:(BOOL *)finished {
    
    int i = self.currentI, j = self.currentJ; //1
    int len = (int)(dataArr.count);
    NSMutableArray *toBeSavedArray = [[NSMutableArray alloc] initWithArray:dataArr];

    int m;
    NSString *t = dataArr[j+1];
    for (m = j; m >= 0 && [self compareIndex:m with:m+1]; m--) {
        [self swap:m with:m+1];
    }
    dataArr[m+1] = t;
    
    [self nextLine:len finish:finished whichArray:dataArr];
    
    [historyArr addObject:@{kDataArr: toBeSavedArray, kHistoryPosition: NSStringFromCGPoint(CGPointMake(i, j))}]; //10
    
    if (*finished) {
        return @{kDataArr: dataArr.copy};
    } else {
        int t = self.currentI;
        NSMutableArray *data = [NSMutableArray arrayWithCapacity: t];
        for (int k = 0; k < t; k++) {
            [data addObject:_turnArray[_turnArray.count-1][k]];
        }
        NSString *num1 = String(self.currentJ);
        //TODO: - color
        NSString *comming = historyArr[0][kDataArr][t];
        return @{kDataArr: data, kPositionArr: @[num1], kTitleArr: @[@"j"], kCommingText: comming};
    }
    return 0;
}

- (void)nextLine:(int)len finish:(BOOL *)finished whichArray:(NSArray *)which {
    self.currentI++;
    NSArray *turnArrayUnit = [[NSArray alloc] initWithArray:which];
    [_turnArray addObject:turnArrayUnit];
    self.currentJ = self.currentI-1;
    if (self.currentI == len) {
        *finished = 1;
    }
}

- (NSDictionary *)nextTurn:(BOOL *)finished {
    int i = self.currentI, j = self.currentJ; //1
    int len = (int)(dataArr.count);
    NSMutableArray *toBeSavedArray = [[NSMutableArray alloc] initWithArray:dataArr];

    if (len == 2) {
        if ([self compareIndex:0 with:1])
            [self swap:0 with:1];
        *finished = 1;        
    } else {
        bool _willSwap = [self compareIndex:j with:j+1]; //返回1要交换
        if (!_willSwap) {
            [self nextLine:len finish:finished whichArray:toBeSavedArray];
        } else {
            [self swap:j with:j+1];
            self.currentJ--;
            if (self.currentJ < 0) {
                [self nextLine:len finish:finished whichArray:dataArr];
            }
        }
    }
  
    [historyArr addObject:@{kDataArr: toBeSavedArray, kHistoryPosition: NSStringFromCGPoint(CGPointMake(i, j))}]; //10
    
    if (*finished) {
        return @{kDataArr: dataArr.copy};
    } else {
        int t = self.currentI;
        NSMutableArray *data = [NSMutableArray arrayWithCapacity: t];
        for (int k = 0; k < t; k++) {
            [data addObject:_turnArray[_turnArray.count-1][k]];
        }
        NSString *num1 = String(self.currentJ);
        //TODO: - color
        NSString *comming = historyArr[0][kDataArr][t];
        return @{kDataArr: data, kPositionArr: @[num1], kTitleArr: @[@"j"], kCommingText: comming};
    }
   
}



- (void)lastStep {
    NSDictionary *d = [historyArr lastObject];
    CGPoint p = CGPointFromString(d[kHistoryPosition]);
    dataArr = d[kDataArr];
    [historyArr removeLastObject];
 
    if (self.currentI != p.x) {
        [_turnArray removeLastObject];
    }
    self.currentJ = p.y;
    self.currentI = p.x;
    
}


- (void)initializeWithArray:(NSMutableArray *)array order:(SortOrder)order {
    self.sortOrder = order;
    dataArr = [[NSMutableArray alloc] initWithArray:array];
    _turnArray = [[NSMutableArray alloc] init];
    self.currentI = 1;
    self.currentJ = 0; // = i - 1
}

- (NSDictionary *)initialSortData {
    if (dataArr.count == 1) {
        return @{kDataArr: dataArr.copy};
    }
    return @{kPositionArr: @[@"0"],
             kTitleArr: @[@"j"],
             kDataArr: @[dataArr[0]],
             kCommingText: dataArr[1]};
}


@end


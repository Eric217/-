//
//  SortReveal
//
//  Created by Eric on 2018/4/26.
//  Copyright © 2018 Eric. All rights reserved.
//

#import "Sorters.h"

#define ELVec4 CGRect

@interface QuickSorter ()

@property (nonatomic, assign) BOOL whileI;
@property (nonatomic, assign) BOOL shouldSwap;

@property (nonatomic, assign) int justGrouped;  //!< 不用记录到 history

@property (nonatomic, copy) NSMutableArray<NSString *> *scopeStack;

@end
 
@implementation QuickSorter

- (NSDictionary *)nextRow:(BOOL *)finished {
    
    ELVec4 histV = CGRectMake(self.currentI, self.currentJ, _whileI, _shouldSwap);
   
    NSMutableArray *toBeSavedArray = [[NSMutableArray alloc] initWithArray:dataArr];
    NSMutableArray *toBeSavedStack = [[NSMutableArray alloc] initWithArray:_scopeStack];
    
    if (_whileI) {
        
        if (_shouldSwap) {
            [self shouldSwap:finished];
        } else {
            int stackTopJ = [self stackTop].y;
            do {
                self.currentI++;
            } while (self.currentI != stackTopJ && [self compareValue:[self pivot] with:dataArr[self.currentI]]);
            
            _whileI = 0;
            if (self.currentI == stackTopJ) {
                self.currentI--;
                return [self nextRow:finished lastValues:histV];
            }
        }
    
    } else { //While J
        int stackBottomI = [self stackTop].x-1;
        do {
            self.currentJ--;
        } while (self.currentJ != stackBottomI && ![self compareValue:[self pivot] with:dataArr[self.currentJ]]);
        
        _whileI = 1;
        _shouldSwap = 1;
        if (self.currentJ == stackBottomI) {
            self.currentJ++;
            return [self nextTurn:finished lastValues:histV];
        }
    }
    
    [historyArr addObject:@{kDataArr: toBeSavedArray, kHistoryPosition: NSStringFromCGRect(histV), kStackArr: toBeSavedStack}]; //10
    
    return [self shouldReturn:finished];
    
}

- (void)shouldSwap:(BOOL *)finished {
    if (self.currentJ <= self.currentI) {
        NSString *t = [self pivot];
        CGPoint p = [self stackTop];
        dataArr[int(p.x)] = dataArr[self.currentJ];
        dataArr[self.currentJ] = t;
        [_scopeStack removeLastObject];
        if (self.currentJ+1 < p.y-1)
            [_scopeStack addObject:NSStringFromCGPoint(CGPointMake(self.currentJ+1, p.y))];
        if (p.x < self.currentJ-1)
            [_scopeStack addObject:NSStringFromCGPoint(CGPointMake(p.x, self.currentJ))];
        if (_scopeStack.count == 0) {
            *finished = 1;
        } else {
            p = [self stackTop];
            _justGrouped = self.currentJ;
            self.currentI = int(p.x);
            self.currentJ = int(p.y);
        }
        
    } else {
        [self swap:self.currentJ with:self.currentI];
    }
    _shouldSwap = 0;
}

- (NSDictionary *)nextRow:(BOOL *)finished lastValues:(CGRect)values {
    
    NSMutableArray *toBeSavedArray = [[NSMutableArray alloc] initWithArray:dataArr];
    NSMutableArray *toBeSavedStack = [[NSMutableArray alloc] initWithArray:_scopeStack];
    
    int stackBottomI = [self stackTop].x-1;
    do {
        self.currentJ--;
        
    } while (self.currentJ != stackBottomI && ![self compareValue:[self pivot] with:dataArr[self.currentJ]]);
    _whileI = 1;
    _shouldSwap = 1;
    if (self.currentJ == stackBottomI) {
        self.currentJ++;
        return [self nextTurn:finished lastValues:values];
    }
    [historyArr addObject:@{kDataArr: toBeSavedArray, kHistoryPosition: NSStringFromCGRect(values), kStackArr: toBeSavedStack}];
    
    return [self shouldReturn:finished];
}

- (NSDictionary *)shouldReturn:(BOOL *)finished {
    NSArray *data = dataArr.copy;
    if (*finished) {
        return @{kDataArr: data};
    } else {
        NSString *num0 = String(self.currentI);
        NSString *num1 = String(self.currentJ);
        NSString *colors;
        if (_justGrouped) {
            colors = String(_justGrouped);
            _justGrouped = 0;
        }
        if (colors)
            return @{kDataArr: data, kPositionArr: @[num0, num1], kTitleArr: @[@"i", @"j"], kColorArr: @[colors]};
        return @{kDataArr: data, kPositionArr: @[num0, num1], kTitleArr: @[@"i", @"j"]};
    }
}

- (NSDictionary *)nextTurn:(BOOL *)finished {
    
    ELVec4 histV = CGRectMake(self.currentI, self.currentJ, _whileI, _shouldSwap);
    //int len = (int)(dataArr.count);
    NSMutableArray *toBeSavedArray = [[NSMutableArray alloc] initWithArray:dataArr];
    NSMutableArray *toBeSavedStack = [[NSMutableArray alloc] initWithArray:_scopeStack];
    
    if (_whileI) {
        
        if (_shouldSwap) {
            [self shouldSwap:finished];
        } else {
            ++self.currentI;
            if (self.currentI == [self stackTop].y) {
                self.currentI--;
                _whileI = 0;
                return [self nextTurn:finished lastValues:histV];
            } else if (![self compareValue:[self pivot] with:dataArr[self.currentI]]) {
                _whileI = 0;
            }
        }
        
    } else { //While J
        
        --self.currentJ;
        if (self.currentJ == [self stackTop].x-1) {
            self.currentJ++;
            _whileI = 1;
            _shouldSwap = 1;
            return [self nextTurn:finished lastValues:histV];
        } else if ([self compareValue:[self pivot] with:dataArr[self.currentJ]]) {
            _whileI = 1;
            _shouldSwap = 1;
        }
        
    }
    
    [historyArr addObject:@{kDataArr: toBeSavedArray, kHistoryPosition: NSStringFromCGRect(histV), kStackArr: toBeSavedStack}]; //10
    
    return [self shouldReturn:finished];
     
}

- (CGPoint)stackTop {
    return CGPointFromString(_scopeStack.lastObject);
}

- (NSDictionary *)initialSortData {
    int c = (int)dataArr.count;
    if (c == 1)
        return @{kDataArr: dataArr.copy};
    return @{kDataArr: dataArr.copy, kTitleArr: @[@"i", @"j"],
             kPositionArr: @[@"0", String(c)]};
}

- (void)lastStep {
    NSDictionary *d = [historyArr lastObject];
    CGRect r = CGRectFromString(d[kHistoryPosition]);
    dataArr = d[kDataArr];
    _scopeStack = d[kStackArr];
    [historyArr removeLastObject];
    
    self.currentI = r.origin.x;
    self.currentJ = r.origin.y;
    self.whileI   = r.size.width;
    self.shouldSwap = r.size.height;
}

- (NSString *)pivot {
    return dataArr[int(CGPointFromString(_scopeStack.lastObject).x)];
}

- (void)initializeWithArray:(NSMutableArray *)array order:(SortOrder)order {
    [super initializeWithArray:array order:order];
    self.currentI = 0;
    self.currentJ = (int)(array.count);
    _whileI = 1;
    _shouldSwap = 0;
    _justGrouped = 0;
    _scopeStack = [[NSMutableArray alloc] init];
    [_scopeStack addObject:NSStringFromCGPoint(CGPointMake(0, self.currentJ))];
   
}

- (NSDictionary *)nextTurn:(BOOL *)finished lastValues:(ELVec4)values {
    NSMutableArray *toBeSavedArray = [[NSMutableArray alloc] initWithArray:dataArr];
    NSMutableArray *toBeSavedStack = [[NSMutableArray alloc] initWithArray:_scopeStack];

    if (_whileI) {
        
        if (_shouldSwap) {
            [self shouldSwap:finished];
        } else {
            ++self.currentI;
            if (self.currentI == [self stackTop].y) { //not exec.
                self.currentI--; _whileI = 0;
                return [self nextTurn:finished lastValues:values];
                
            } else if (![self compareValue:[self pivot] with:dataArr[self.currentI]]) {
                _whileI = 0;
            }
        }
        
    } else {
        --self.currentJ;
        if (self.currentJ == [self stackTop].x-1) { //not exec.
            self.currentJ++;_whileI = 1;_shouldSwap = 1;
            return [self nextTurn:finished lastValues:values];
        
        } else if ([self compareValue:[self pivot] with:dataArr[self.currentJ]]) {
            _whileI = 1;
            _shouldSwap = 1;
        }
    }
    
    [historyArr addObject:@{kDataArr: toBeSavedArray, kHistoryPosition: NSStringFromCGRect(values), kStackArr: toBeSavedStack}]; //10

    return [self shouldReturn:finished];
}

@end


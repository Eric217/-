//
//  MyComparator.m
//  SortReveal
//
//  Created by Eric on 2018/5/15.
//  Copyright © 2018 Eric. All rights reserved.
//

#import "MyComparator.h"
#import "Common.h"
#import "PinyinHelper.h"

static MyComparator *_shared;

@implementation MyComparator

+ (MyComparator *)shared {
    if (!_shared) {
        _shared = [MyComparator new];
    }
    return _shared;
}

- (bool)compareCustomObj:(id<Comparable>)a with:(id<Comparable>)b order:(bool)lower {
    bool r = [a compareTo:b];
    return lower ? !r : r;
}

- (bool)compareByDict:(NSString *)a with:(NSString *)b order:(bool)lower {
   
    HanyuPinyinOutputFormat *outputFormat = [HanyuPinyinOutputFormat commonFormat];
    //TODO: - 每提取出一个char比较一次，比较省时间
    NSString *a1 = [PinyinHelper toHanyuPinyinStringWithSourceString:a withPinyinFormat:outputFormat bySeperator:@""];
    NSString *a2 = [PinyinHelper toHanyuPinyinStringWithSourceString:b withPinyinFormat:outputFormat bySeperator:@""];
 
    return [self compareByChar:a1 with:a2 order:lower];
}

- (bool)compareByChar:(NSString *)a with:(NSString *)b order:(bool)lower {
    int numeric = [NSUserDefaults.standardUserDefaults boolForKey:kNumericCompare] ? 64 : 0;
    int caseInsensitive = [UserDefault boolForKey: kIgnoringCases];
    NSUInteger r = [a compare:b options:numeric|caseInsensitive]; //打开位
    return [self yihuo_r:r lower:lower];
}

- (bool)yihuo_r:(NSUInteger)r lower:(bool)lower {
    if (r == 0)
        return 0;
    bool m = r == -1;
    return (m && lower) || !(m || lower);
}

- (bool)compareByNumber:(double)a with:(double)b order:(bool)lower {
    return lower ? a < b : a > b;
}

- (bool)compareByAutomatic:(NSString *)a with:(NSString *)b order:(bool)lower {
    
    return [self compareByDict:a with:b order:lower];
}


@end

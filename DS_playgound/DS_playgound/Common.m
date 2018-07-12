//
//  Common.m
//  SortReveal
//
//  Created by Eric on 2018/4/10.
//  Copyright © 2018 Eric. All rights reserved.
//

#import "Common.h"

NSNotificationName const ELTextFieldShouldResignNotification = @"TFShouldResignNoti";
 
CGFloat UnitSize = UnitSizeDefault;
CGFloat TreeFont = TreeFontDefault;

static NSString * docPath = 0;

@interface Config()


@end

@implementation Config


+ (int)getTreeHeight:(NSUInteger)count {
    if (count == 0) {
        return 0;
    }
    return (int)(log2(count)+1);
}

+ (void)updateUnitSizeAndFontFor:(ScreenMode)screen withTreeSize:(NSUInteger)nodeCount {
    
    
//    if (nodeCount > 7) {
//        UnitSize = UnitSizeDefault * 0.6;
//        TreeFont = TreeFontDefault *0.8;
//    } else {
//        UnitSize = UnitSizeDefault;
//        TreeFont = TreeFontDefault;
//    }
}

///我们默认bottonH为一个常量 —— 没有必要自己设置值。关于树的位置有两种方案，一是convertOrdinate时调整，一个是确定的tree size，从左下角画。
+ (CGSize)estimatedSizeThatFitsTree:(NSUInteger)nodeCount bottom:(CGFloat)bottomH {
    if (nodeCount == 0)
        return CGSizeZero;
    int th = (int)(log2(nodeCount)+1);
    int lastRow = (int)pow(2, th-1);
    int w = LineWidth + UnitSize + SepaWidth*(lastRow-1), h = 0;
    if (th == 2) {
        h = UnitSize + 1.796*SepaWidth/2+UnderTreeH;
        w *= 1.3;
    } else if (th == 3) {
        h = w+UnderTreeH-24;
    } else if (th == 1) {
        h = w;
    } else if (th == 4) {
        h = 0.75*w;
    }
    return CGSizeMake(w, h);
}

///need to free points and alter coordinate, level: _height-2 ... 0
+ (CGPoint *)getLocaWithHeight:(int)h startAngle:(CGFloat)a angleReducer:(void(^)(int level, CGFloat *))handler {
    if (h == 0) {
        return 0;
    }
    int arrSize = pow(2, h)-1;
    CGPoint *points = (CGPoint *)malloc(arrSize*sizeof(CGPoint));
    
    //最底层单独确定位置
    int s = pow(2, h-1) - 1;
    CGFloat bottom = LineWidth/2;
    CGFloat left = LineWidth/2;
    CGFloat angle = a;
    
    for (int i = s; i <= 2*s; i++) {
        points[i] = CGPointMake(left+0.5*UnitSize+(i-s)*SepaWidth, UnitSize*0.5+bottom);
    }
    
    //其余层靠子树确定位置
    for (int i = h-2; i >= 0; i--) {
        int s = pow(2, i) - 1;
        for (int j = s; j <= 2*s; j++) {
            int point1Idx = 2*j+1;
            CGFloat x1 = points[point1Idx].x;
            CGFloat lastLevelBian = points[point1Idx+1].x - x1;
            CGFloat x2 = x1 + lastLevelBian/2; //X
            CGFloat y2;
            if (j == s) {
                y2 = points[point1Idx].y + lastLevelBian/2*tan(angle);
                handler(i, &angle);
            } else
                y2 = points[j-1].y;
            points[j] = CGPointMake(x2, y2);
        }
        
    }
 
    return points;
}


+ (CGSize)sizeForText:(NSString *)str attr:(NSDictionary *)attr maxSize:(CGSize)max orFontS:(CGFloat)fs {
    CGRect rect = [str boundingRectWithSize:max options:NSStringDrawingUsesLineFragmentOrigin attributes:attr ? attr : @{NSFontAttributeName: [UIFont systemFontOfSize:fs]} context:0];
    return rect.size;
}

+ (void)saveDouble:(double)value forKey:(NSString *)key {
    [NSUserDefaults.standardUserDefaults setDouble:value forKey:key];
    [NSUserDefaults.standardUserDefaults synchronize];
}

+ (double)doubleValue:(NSString *)text error:(BOOL *)error {
    NSScanner *scanner = [NSScanner scannerWithString:text];
    double result = 0;
    if (!([scanner scanDouble:&result] && [scanner isAtEnd])) {
        result = 0;
        *error = 1;
    }
    if (!result) {
        unichar c = [text characterAtIndex:0];
        if (c != '0' && c != '.') {
            *error = 1;
        }
    }
    return result;
}

+ (void)addObserver:(id)target selector:(SEL)func notiName:(NSNotificationName)name {
    [[NSNotificationCenter defaultCenter] addObserver:target selector:func name:name object:nil];
}

+ (void)postNotification:(NSNotificationName)name message:(NSDictionary *)info {
    [[NSNotificationCenter defaultCenter] postNotificationName:name object:nil userInfo:info];
}

+ (void)removeObserver:(id)obj {
    [[NSNotificationCenter defaultCenter] removeObserver:obj];
}

+ (NSString *)documentPath {
    if (!docPath) {
        docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, 1).firstObject;
    }
    return docPath;
    
}

+ (NSArray *)getArrayDataFromFile:(NSString *)name {
    
    return [NSArray arrayWithContentsOfFile:[[self documentPath] stringByAppendingPathComponent:name]];

}

+ (void)writeArrayToFile:(NSString *)file data:(NSArray *)arr {
    NSString *path = [[self documentPath] stringByAppendingPathComponent:file];
    if (![arr writeToFile:path atomically:0]) {
        [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
    }
  
}

+ (CGFloat)v_pad:(CGFloat)ipad plus:(CGFloat)b p:(CGFloat)s min:(CGFloat)ss {
    if (IPAD) {
        return ipad;
    } else if (IPHONE4 || IPHONE5) {
        return ss;
    } else if (IPHONE6) {
        return s;
    } else {
        return b;
    }
}

@end

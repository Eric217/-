//
//  Common.m
//  SortReveal
//
//  Created by Eric on 2018/4/10.
//  Copyright © 2018 Eric. All rights reserved.
//

#import "Common.h"

NSNotificationName const ELTextFieldShouldResignNotification = @"TFShouldResignNoti";
NSNotificationName const ELGraphDidSelectPointNotification = @"didselectpointnot";
NSNotificationName const ELGraphShouldStartShowNotification = @"graphshoudklshow";
NSNotificationName const ELStackDidChangeNotification = @"stackshouldpusj";
NSNotificationName const ELGraphDidRestartShowNotification = @"graphdidisatata";
NSNotificationName const ELGraphDidInitPathTableNotification = @"grfwqdidisatata";



CGFloat UnitSize = UnitSizeDefault; ///< 直径
CGFloat TreeFont = TreeFontDefault;
CGFloat SepaWidth = SepaWidtDefault;
CGFloat LineWidth = LineWidthDefault;


static NSString * docPath = 0;

@interface Config()


@end

@implementation Config


+ (NSArray *)trimmedArray:(NSArray *)a {
    NSMutableArray *arr = [NSMutableArray new];
    int c = (int)a.count;
    for (int i = 0; i < c; i++) {
        if (![EmptyNode isEqualToString:a[i]]) {
            [arr addObject:a[i]];
        }
    }
    return arr;
}

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
///得出的点是左下角为原点排列
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


+ (void)updateTreeUnitSize:(CGFloat)u_s font:(CGFloat)t_f sepaMul:(CGFloat)s_w {
    if (u_s > 0)
        UnitSize = u_s;
    if (t_f > 0)
        TreeFont = t_f;
    if (s_w > 0)
        SepaWidth = s_w * UnitSize;
}

+ (void)defaultTreeConfig {
    UnitSize = UnitSizeDefault;
    TreeFont = TreeFontDefault;
    SepaWidth = SepaWidtDefault;
    LineWidth = LineWidthDefault;
}
 

+ (void)saveDouble:(double)value forKey:(NSString *)key {
    [NSUserDefaults.standardUserDefaults setDouble:value forKey:key];
    [NSUserDefaults.standardUserDefaults synchronize];
}
 
/// @param func func parameter is NSNotification *
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

+ (NSArray *)getArrayFromFile:(NSString *)name {
    return [NSArray arrayWithContentsOfFile:[[self documentPath] stringByAppendingPathComponent:name]];
    
}

+ (NSDictionary *)getDictionaryFromFile:(NSString *)name {
    return [NSDictionary dictionaryWithContentsOfFile:[[self documentPath] stringByAppendingPathComponent:name]];
}

/// @param data NSArray *, NSDictionary *, NSString * or NSData *
+ (void)writeToPlistName:(NSString *)file data:(id)data {
    NSString *path = [[self documentPath] stringByAppendingPathComponent:file];
    if (![data writeToFile:path atomically:0]) {
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

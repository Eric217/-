//
//  Common.h
//  SortReveal
//
//  Created by Eric on 2018/4/10.
//  Copyright © 2018 Eric. All rights reserved.
//

#ifndef Common_h
#define Common_h
#import <UIKit/UIKit.h>
#import "Definition.h"

#define UnderTreeH          68*UnitSize/UnitSizeDefault

//MARK: - noti names
UIKIT_EXTERN NSNotificationName const ELTextFieldShouldResignNotification;
UIKIT_EXTERN NSNotificationName const ELGraphDidSelectPointNotification;
UIKIT_EXTERN NSNotificationName const ELGraphShouldStartShowNotification;
UIKIT_EXTERN NSNotificationName const ELStackDidChangeNotification;
UIKIT_EXTERN NSNotificationName const ELGraphDidRestartShowNotification;

// FOR TREE
UIKIT_EXTERN CGFloat UnitSize;
UIKIT_EXTERN CGFloat TreeFont;
UIKIT_EXTERN CGFloat SepaWidth;
UIKIT_EXTERN CGFloat LineWidth;


//MARK: - common and useful funcs
///Config provides common tools
@interface Config: NSObject
 
+ (void)updateUnitSizeAndFontFor:(ScreenMode)screen withTreeSize:(NSUInteger)nodeCount;
+ (int)getTreeHeight:(NSUInteger)count;
+ (CGSize)estimatedSizeThatFitsTree:(NSUInteger)nodeCount bottom:(CGFloat)bottomH;
+ (CGPoint *)getLocaWithHeight:(int)h startAngle:(CGFloat)a angleReducer:(void(^)(int level, CGFloat * angle))handler;
+ (void)updateTreeUnitSize:(CGFloat)u_s font:(CGFloat)t_f sepaMul:(CGFloat)s_w;
+ (void)defaultTreeConfig;
 

+ (void)saveDouble:(double)value forKey:(NSString *)key;


+ (void)addObserver:(id)target selector:(SEL)func notiName:(NSNotificationName)name;
+ (void)postNotification:(NSNotificationName)name message:(NSDictionary *)info;
+ (void)removeObserver:(id)obj;
 
+ (NSString *)documentPath;
+ (NSDictionary *)getDictionaryFromFile:(NSString *)name;
+ (NSArray *)getArrayFromFile:(NSString *)name;

+ (void)writeToPlistName:(NSString *)file data:(id)data;
+ (NSArray *)trimmedArray:(NSArray *)a;

+ (CGFloat)v_pad:(CGFloat)ipad plus:(CGFloat)b p:(CGFloat)s min:(CGFloat)ss;

@end

#endif

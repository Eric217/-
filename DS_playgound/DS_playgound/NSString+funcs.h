//
//  NSString+funcs.h
//  DS_playgound
//
//  Created by Eric on 2018/7/21.
//  Copyright © 2018 SDU_iOS_LAB. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSString (funcs)

- (CGSize)sizeWithAttr:(NSDictionary *)attr maxSize:(CGSize)max orFontS:(CGFloat)fs;
- (double)doubleValueWithError:(BOOL *)error;

@end



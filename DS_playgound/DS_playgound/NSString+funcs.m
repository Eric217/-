//
//  NSString+funcs.m
//  DS_playgound
//
//  Created by Eric on 2018/7/21.
//  Copyright © 2018 SDU_iOS_LAB. All rights reserved.
//

#import "NSString+funcs.h"

@implementation NSString (funcs)


///@param attr nullable
- (CGSize)sizeWithAttr:(NSDictionary *)attr maxSize:(CGSize)max orFontS:(CGFloat)fs {
    
    CGRect rect = [self boundingRectWithSize:max options:NSStringDrawingUsesLineFragmentOrigin attributes:attr ? attr : @{NSFontAttributeName: [UIFont systemFontOfSize:fs]} context:0];
    return rect.size;
}

- (double)doubleValueWithError:(BOOL *)error {
    NSScanner *scanner = [NSScanner scannerWithString:self];
    double result = 0;
    if (!([scanner scanDouble:&result] && [scanner isAtEnd])) {
        result = 0;
        *error = 1;
    }
    if (!result) {
        unichar c = [self characterAtIndex:0];
        if (c != '0' && c != '.') {
            *error = 1;
        }
    }
    return result;
}


@end

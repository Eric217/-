//
//  UIImage+operations.m
//  SortReveal
//
//  Created by Eric on 2018/4/15.
//  Copyright © 2018 Eric. All rights reserved.
//

#import "UIImage+operations.h"
#import "NSString+funcs.h"

@implementation UIImage (operations)

+ (UIImage *)pushImage {
    if (!_pushImage) {
        _pushImage = [UIImage imageNamed:@"pushImage"];
    }
    return _pushImage;
}

+ (UIImage *)backImage {
    if (!_backImage) {
        _backImage = [UIImage imageNamed:@"backImage"];
    }
    return _backImage;
}

- (UIImage *)imageWithColor:(UIColor *)color
{
    UIGraphicsBeginImageContextWithOptions(self.size, NO, self.scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, 0, self.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextSetBlendMode(context, kCGBlendModeNormal);
    CGRect rect = CGRectMake(0, 0, self.size.width, self.size.height);
    CGContextClipToMask(context, rect, self.CGImage);
    [color setFill];
    CGContextFillRect(context, rect);
    UIImage*newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

///@param a nullable;
- (UIImage *)imageWithWaterMark:(NSString *)s postion:(WaterMarkPosition)r attributes:(NSDictionary *)a offset:(CGSize)off {
    UIGraphicsBeginImageContext(self.size);
    [self drawInRect:CGRectMake(0, 0, self.size.width, self.size.height)];

    CGSize txtSize;
    NSMutableDictionary *attr;
    if (a)
        txtSize = [s sizeWithAttributes:a];
    else {
        attr = [NSMutableDictionary new];
        attr[NSFontAttributeName] = [UIFont systemFontOfSize:23];
        txtSize = [s sizeWithAttributes:attr];
    }
    
    CGRect inRect;
    switch (r) {
        case 0:
            inRect = CGRectMake(off.width, off.height, txtSize.width, txtSize.height); break;
        case 1:
            inRect = CGRectMake(self.size.width-off.width-txtSize.width, off.height, txtSize.width, txtSize.height); break;
        case 2:
            inRect = CGRectMake(off.width, self.size.height-off.height-txtSize.height, txtSize.width, txtSize.height); break;
        case 3:
            inRect = CGRectMake(self.size.width-off.width-txtSize.width, self.size.height-off.height-txtSize.height, txtSize.width, txtSize.height);
    }
    
    [s drawInRect:inRect withAttributes:a ? a : attr];
    UIImage *i = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return i;    
}

@end

//
//  UIImage+operations.m
//  SortReveal
//
//  Created by Eric on 2018/4/15.
//  Copyright © 2018 Eric. All rights reserved.
//

#import "UIImage+operations.h"

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

@end

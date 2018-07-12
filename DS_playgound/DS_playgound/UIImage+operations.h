//
//  UIImage+operations.h
//  SortReveal
//
//  Created by Eric on 2018/4/15.
//  Copyright © 2018 Eric. All rights reserved.
//

#import <UIKit/UIKit.h>

static UIImage * _backImage = 0;
static UIImage * _pushImage = 0;

@interface UIImage (operations)

+ (UIImage *)pushImage;
+ (UIImage *)backImage;


- (UIImage *)imageWithColor:(UIColor *)color;

@end

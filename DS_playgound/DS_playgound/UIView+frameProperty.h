//
//  UIView+frameProperty.h
//  SortReveal
//
//  Created by Eric on 2018/4/10.
//  Copyright © 2018 Eric. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (frameProperty)

- (CGFloat)x;
- (void)setX:(CGFloat)x;


- (CGFloat)y;
- (void)setY:(CGFloat)y;


- (CGFloat)width;
- (void)setWidth:(CGFloat)width;


- (CGFloat)height;
- (void)setHeight:(CGFloat)height;


- (CGFloat)centerX;
- (void)setCenterX:(CGFloat)x;

 
- (CGFloat)centerY;
- (void)setCenterY:(CGFloat)y;


- (CGFloat)x_right;
- (CGFloat)y_bottom;

 
@end

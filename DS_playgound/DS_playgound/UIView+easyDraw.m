//
//  UIView+easyDraw.m
//  DS_playgound
//
//  Created by Eric on 2018/7/18.
//  Copyright © 2018 SDU_iOS_LAB. All rights reserved.
//

#import "UIView+easyDraw.h"

@implementation UIView (easyDraw)

- (void)pathMoveToPoint:(CGPoint *)point path:(CGMutablePathRef)p {
    CGPathMoveToPoint(p, 0, point->x, point->y);
}

- (void)pathAddLineToPoint:(CGPoint *)point path:(CGMutablePathRef)p {
    CGPathAddLineToPoint(p, 0, point->x, point->y);
}

- (CGRect)getRectWithCenter:(CGPoint *)p unitSize:(CGFloat)unit {
    return CGRectMake(p->x-unit/2, p->y-unit/2, unit, unit);
}

@end

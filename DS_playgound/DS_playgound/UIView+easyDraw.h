//
//  UIView+easyDraw.h
//  DS_playgound
//
//  Created by Eric on 2018/7/18.
//  Copyright © 2018 SDU_iOS_LAB. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (easyDraw)

- (void)pathMoveToPoint:(CGPoint *)point path:(CGMutablePathRef)p;

- (void)pathAddLineToPoint:(CGPoint *)point path:(CGMutablePathRef)p;

- (CGRect)getRectWithCenter:(CGPoint *)p unitSize:(CGFloat)unit;

@end

NS_ASSUME_NONNULL_END

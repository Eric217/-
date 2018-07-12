//
//  UIButton+type.h
//  SortReveal
//
//  Created by Eric on 2018/5/12.
//  Copyright © 2018 Eric. All rights reserved.
//

#import <UIKit/UIKit.h>

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wnullability-completeness"

@interface UIButton (init)

+ (UIButton *)customBackBarButtonItemWithTitle:(NSString *)title target:(id)target action:(SEL)selec;

+ (UIButton *)buttonWithTitle:(nonnull NSString *)title fontSize:(CGFloat)fs textColor:(nullable UIColor *)color target:(nonnull id)tar action:(nonnull SEL)act image:(nullable UIImage *)image;

@end

#pragma clang diagnostic pop

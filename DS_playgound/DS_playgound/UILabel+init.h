//
//  UILabel+init.h
//  SortReveal
//
//  Created by Eric on 2018/5/13.
//  Copyright © 2018 Eric. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (init)

+ (UILabel *)labelWithCentredTitle:(NSString *)title fontSize:(CGFloat)fontSize;
+ (UILabel *)labelWithEmptyPrompt:(NSString *)title fontSize:(CGFloat)f_s;
+ (UILabel *)labelWithTitle:(NSString *)t fontSize:(CGFloat)f align:(NSTextAlignment)a;


@end

//
//  UILabel+init.m
//  SortReveal
//
//  Created by Eric on 2018/5/13.
//  Copyright © 2018 Eric. All rights reserved.
//

#import "UILabel+init.h"

@implementation UILabel (init)

+ (UILabel *)labelWithCentredTitle:(NSString *)title fontSize:(CGFloat)fontSize {
    UILabel *l = [[UILabel alloc] init];
    [l setText:title];
    [l setFont:[UIFont systemFontOfSize:fontSize]];
    [l setTextAlignment:NSTextAlignmentCenter];
    return l;
}
@end

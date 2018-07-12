//
//  UIButton+type.m
//  SortReveal
//
//  Created by Eric on 2018/5/12.
//  Copyright © 2018 Eric. All rights reserved.
//

#import "UIButton+init.h"
#import "UIImage+operations.h"

@implementation UIButton (init)

+ (UIButton *)customBackBarButtonItemWithTitle:(NSString *)title target:(id)target action:(SEL)selec {
    UIButton *_backButton = [[UIButton alloc] init];
    [_backButton setContentEdgeInsets:UIEdgeInsetsMake(0, -12, 0, 20)];
    [_backButton setTitle:title forState:UIControlStateNormal];
    [_backButton setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
    [_backButton setImage:[UIImage backImage] forState:UIControlStateNormal];
    [_backButton addTarget:target action:selec forControlEvents:UIControlEventTouchUpInside];
    return _backButton;
}
///可空的有默认值，fontSize为0被视为空
+ (UIButton *)buttonWithTitle:(nonnull NSString *)title fontSize:(CGFloat)fs textColor:(nullable UIColor *)color target:(nonnull id)tar action:(nonnull SEL)act image:(nullable UIImage *)image {
    UIButton *butt = [[UIButton alloc] init];
    [butt setTitle:title forState:UIControlStateNormal];
    if (fs)
        [butt.titleLabel setFont:[UIFont systemFontOfSize:fs]];
    if (color)
        [butt setTitleColor:color forState:UIControlStateNormal];
    [butt addTarget:tar action:act forControlEvents:UIControlEventTouchUpInside];
    if (image)
        [butt setImage:image forState:UIControlStateNormal];
    return butt;
}


@end

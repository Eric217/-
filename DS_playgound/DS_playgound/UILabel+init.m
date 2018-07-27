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

+ (UILabel *)labelWithTitle:(NSString *)t fontSize:(CGFloat)f align:(NSTextAlignment)a {
    UILabel *l = [[UILabel alloc] init];
    [l setText:t];
    [l setFont:[UIFont systemFontOfSize:f]];
    [l setTextAlignment:a];
    return l;
}

///font size 28 recommended
+ (UILabel *)labelWithEmptyPrompt:(NSString *)title fontSize:(CGFloat)f_s {
    UILabel *_collectionEmptyView = [[UILabel alloc] init];
    UIColor *tc = [UIColor.grayColor colorWithAlphaComponent:0.78];
    [_collectionEmptyView setTextColor:tc];
    _collectionEmptyView.text = title;
    _collectionEmptyView.numberOfLines = 2;
    _collectionEmptyView.font = [UIFont systemFontOfSize:f_s];
    _collectionEmptyView.textAlignment = NSTextAlignmentCenter;
    return _collectionEmptyView;
}

@end

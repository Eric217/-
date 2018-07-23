//
//  UIView+funcs.m
//  SortReveal
//
//  Created by Eric on 2018/4/17.
//  Copyright © 2018 Eric. All rights reserved.
//

#import "UIView+funcs.h"

@implementation UIView (funcs)
 
/**
 普通的截图
 该API仅可以在未使用layer和OpenGL渲染的视图上使用
 @return 截取的图片
 */
- (UIImage *)normalSnapshotImage {
    UIGraphicsBeginImageContextWithOptions(self.frame.size, NO, [UIScreen mainScreen].scale);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *snapshotImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return snapshotImage;
}

@end

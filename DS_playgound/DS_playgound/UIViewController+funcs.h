//
//  UIViewController+funcs.h
//  SortReveal
//
//  Created by Eric on 2018/4/15.
//  Copyright © 2018 Eric. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (funcs)

+ (UIViewController *)viewControllerFromSBName:(NSString *)sbName id:(NSString *)sbId;

- (void)presentAlertWithCancelAndConfirm:(NSString *)title message:(NSString *)msg Action:(void (^) (void))handler;
- (void)presentTip:(NSString *)title message:(NSString *)msg Action:(void (^) (void))handler;

- (void)presentPop:(UIViewController *)vc attach:(id)at;

- (void)pushWithoutBottomBar:(UIViewController *)vc;

- (void)saveImage:(UIImage *)img;

- (void)makeViewLoad;

@end


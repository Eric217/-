//
//  UIViewController+funcs.h
//  SortReveal
//
//  Created by Eric on 2018/4/15.
//  Copyright © 2018 Eric. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Common.h"

@interface UIViewController (funcs)

+ (UIViewController *)viewControllerFromSBName:(NSString *)sbName id:(NSString *)sbId;

- (void)presentAlertWithCancelAndConfirm:(NSString *)title message:(NSString *)msg Action:(void (^) (void))handler;
- (void)presentTip:(NSString *)title message:(NSString *)msg Action:(void (^) (void))handler;

- (void)pushWithoutBottomBar:(UIViewController *)vc;

@end


@interface UIViewController (ELSplitController)

- (bool)isDevicePortait;

- (bool)isPortrait;

- (bool)isFloatingOrThirth;
    
- (bool)isHalfIpad;
    
- (bool)isTwoThirth;
    
- (bool)isFullScreen;
    
//以下几个函数涉及到split view controller.
- (bool)canPullHideLeft;
    
- (bool)canShowBoth;
    
- (bool)isNoSplit;

- (ScreenMode)screenMode;

- (void)automaticSplitStyle;
- (void)overlaySplitStyle;
- (void)hidePrimarySplitStyle;

@end

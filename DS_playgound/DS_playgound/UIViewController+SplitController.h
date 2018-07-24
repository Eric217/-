//
//  UIViewController+SplitController.h
//  DS_playgound
//
//  Created by Eric on 2018/7/21.
//  Copyright © 2018 SDU_iOS_LAB. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Common.h"

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (SplitController)

- (void)showSplitWithMaster:(UIViewController *)m detail:(Class)d delegate:(id <UISplitViewControllerDelegate>)de;
- (void)showSplitWithMaster:(UINavigationController *)m detail:(UIViewController *)d;

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

NS_ASSUME_NONNULL_END

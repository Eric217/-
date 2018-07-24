//
//  UIViewController+SplitController.m
//  DS_playgound
//
//  Created by Eric on 2018/7/21.
//  Copyright © 2018 SDU_iOS_LAB. All rights reserved.
//

#import "UIViewController+SplitController.h"

@implementation UIViewController (SplitController)

#define Delta 20

/// @param m master vc@param d detail vc class, will init by [d new] and embedded in a nav
- (void)showSplitWithMaster:(UIViewController *)m detail:(Class)d delegate:(id <UISplitViewControllerDelegate>)de {
    
    UISplitViewController *splitVC = [[UISplitViewController alloc] init];
    
    if (IPAD || (IPHONE6P && ![self isDevicePortait])) {
        UIViewController *vc = [[d alloc] init];
        UINavigationController *emptyDetailNav = [[UINavigationController alloc] initWithRootViewController:vc];
        [emptyDetailNav setToolbarHidden:0];
        [splitVC setViewControllers:@[m, emptyDetailNav]];
    } else {
        [splitVC setViewControllers:@[m]];
    }
    
    if (IPAD)
        splitVC.delegate = de;
    //splitVC.preferredDisplayMode = UISplitViewControllerDisplayModeAllVisible;
    [self.view.window setRootViewController:splitVC];
}

/// svc.delegate will set to m.root
/// @param d it will be embedded in a nav
- (void)showSplitWithMaster:(UINavigationController *)m detail:(UIViewController *)d {
    
    UISplitViewController *splitVC = [[UISplitViewController alloc] init];
    
    if (IPAD || (IPHONE6P && ![self isDevicePortait])) {
        
        UINavigationController *emptyDetailNav = [[UINavigationController alloc] initWithRootViewController:d];
        [emptyDetailNav setToolbarHidden:0];
        [splitVC setViewControllers:@[m, emptyDetailNav]];
    } else {
        [splitVC setViewControllers:@[m]];
    }
    
    if (IPAD)
        splitVC.delegate = m.viewControllers[0];
    //splitVC.preferredDisplayMode = UISplitViewControllerDisplayModeAllVisible;
    [self.view.window setRootViewController:splitVC];
}

/// 真的ipad是正着还是横屏
- (bool)isDevicePortait {
    return ScreenW < ScreenH;
}

/// 对于ipad是指除了横屏2/3和大pro的半屏之外 所有宽小于高的情况，不是物理设备的portrait
- (bool)isPortrait {
    CGFloat sw = ScreenW, vw = self.view.bounds.size.width;
    bool heng2_3 = sw > ScreenH && (vw - sw/2) > Delta && sw > vw;
    if (heng2_3 || (IPADPro && [self isHalfIpad]))
        return 0;
    return vw < self.view.bounds.size.height;
}

- (bool)isFloatingOrThirth {
    if (IPHONE) {
        return [self isPortrait];
    } else {
        return (ScreenW/2 - self.view.bounds.size.width) > Delta;
    }
}

- (bool)isHalfIpad {
    if (IPHONE) {
        return 0;
    }
    return fabs(ScreenW/2 - self.view.bounds.size.width) < Delta;
}

- (bool)isTwoThirth {
    if (IPHONE) {
        return 0;
    }
    CGFloat sw = ScreenW, vw = self.view.bounds.size.width;
    return fabs(sw/2-vw) > Delta && sw > vw;
}

- (bool)isFullScreen {
    return ScreenW == self.view.bounds.size.width;
}

- (bool)canPullHideLeft {
    if (IPHONE)
        return 0;
    if ([self isPortrait])
        return [self isFullScreen];
    else {
        if (IPADPro) {
            return [self isHalfIpad];
        }
        return [self isTwoThirth];
        
    }
}

- (bool)canShowBoth {
    if (IPHONE)
        return IPHONE6P;
    return (![self isPortrait] && [self isFullScreen]) || (IPADPro && [self isTwoThirth]);
}

- (bool)isNoSplit {
    return ![self canShowBoth] && ![self canPullHideLeft];
}

- (ScreenMode)screenMode {
    //    if ([self isFloatingOrThirth]) {
    //        return ScreenModeFloatingOrThirth;
    //    } else if ([self isHalfIpad]) {
    //        return ScreenModeHalfIpad;
    //    } else if ([self canPullHideLeft]) {
    //        return ScreenModeCanPullHideLeft;
    //    } else if ([self canShowBoth]) {
    //        return ScreenModeCanShowBoth;
    //    }
    
    return 0;
}

- (void)automaticSplitStyle {
    [self.splitViewController setPreferredDisplayMode:UISplitViewControllerDisplayModeAutomatic];
}
- (void)overlaySplitStyle {
    [self.splitViewController setPreferredDisplayMode:UISplitViewControllerDisplayModePrimaryOverlay];
}
- (void)hidePrimarySplitStyle {
    [self.splitViewController setPreferredDisplayMode:UISplitViewControllerDisplayModePrimaryHidden];
}
@end

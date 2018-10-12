//
//  UIViewController+funcs.m
//  SortReveal
//
//  Created by Eric on 2018/4/15.
//  Copyright © 2018 Eric. All rights reserved.
//

#import "UIViewController+funcs.h"
#import "Common.h"
#import "Auth.h"

@implementation UIViewController (funcs)


+ (UIViewController *)viewControllerFromSBName:(NSString *)sbName id:(NSString *)sbId {
    return [[UIStoryboard storyboardWithName:sbName bundle:0] instantiateViewControllerWithIdentifier:sbId];
}

/// 两个选择：确定，取消
- (void)presentAlertWithCancelAndConfirm:(NSString *)title message:(NSString *)msg Action:(void (^) (void))handler {
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:title message:msg preferredStyle:UIAlertControllerStyleAlert];
 
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _) {
        handler();
    }];
    [alertC addAction:cancel];
    
    [alertC addAction:ok];
    
    [self presentViewController:alertC animated:1 completion:nil];
}

/// 需要用户点击才消失的，需要用户完全明确了解的提示
- (void)presentTip:(NSString *)title message:(NSString *)msg Action:(void (^) (void))handler {
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:title message:msg preferredStyle:UIAlertControllerStyleAlert];
 
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _) {
        handler();
    }];
    [alertC addAction:ok];
    
    [self presentViewController:alertC animated:1 completion:nil];
}

/// @param vc it will be embedded in a nav
/// @param at BarItem *, or array: [sourceView *, NSStringFromRect *]
- (void)presentPop:(UIViewController *)vc attach:(id)at {
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    nav.preferredContentSize = CGSizeMake(340, 576);
    nav.modalPresentationStyle = UIModalPresentationPopover;
    UIPopoverPresentationController *popvc = nav.popoverPresentationController;
    
    if ([at isKindOfClass:UIBarButtonItem.class])
        popvc.barButtonItem = at;
    else {
        NSArray *arr = at;
        popvc.sourceView = arr[0];
        popvc.sourceRect = CGRectFromString(arr[1]);
    }
    popvc.permittedArrowDirections = UIPopoverArrowDirectionAny;
    popvc.backgroundColor = nav.topViewController.view.backgroundColor;
    [self presentViewController:nav animated:1 completion:nil] ;
}

/// 弹出 hub 简单文字提示用户
- (void)presentMessage:(NSString *)msg duration:(NSTimeInterval)dur status:(BOOL)s {
 
}


- (void)attemptSaveImage:(UIImage *)image finishWithError:(NSError *)error context:(void *)ctx {
    // @{"status": "0", "msg": "str"} //0是只有一个按钮或hub提示，1是俩按钮，确定取消
    if (error) {
        if (ctx) { // 来自于保存图片的
            [self presentMessage:@"未知错误" duration:0.44 status:0];
        } else { // a custom error
            NSDictionary *info = error.userInfo;
            NSString *str = info[kMessage];
            if ([info[kStatus] isEqualToString:@"0"]) { // restricted
                [self presentTip:PromptText message:str Action:^{}];
            } else if ([info[kStatus] isEqualToString:@"1"]) { // denied
                [self presentAlertWithCancelAndConfirm:@"应用请求访问相册" message:@"要前往设置中打开相册权限吗?" Action:^{
                    [Auth jumpToSettings:@"App-Prefs:root=Photos"];
                }];
            }
        }
        
    } else { //保存成功
        [self presentMessage:@"保存成功" duration:0.44 status:1];
    }
}

- (void)saveImage:(UIImage *)img {
    
    [Auth requestPhotosWith_Success:^{ // request Auth
        bool fail = 1;
        UIImageWriteToSavedPhotosAlbum(img, self, @selector(attemptSaveImage:finishWithError:context:), &fail);
        
    } _restrict:^{
        NSError *err = [NSError errorWithDomain:NSCocoaErrorDomain code:1 userInfo:@{kStatus: @"0", kMessage: @"保存失败: 访问受限"}];
        [self attemptSaveImage:0 finishWithError:err context:0];
        
    } _denied:^{
        NSError *err = [NSError errorWithDomain:NSCocoaErrorDomain code:1 userInfo:@{kStatus: @"1", kMessage: @"要前往设置中开启吗?"}];
        [self attemptSaveImage:0 finishWithError:err context:0];
    }];
    
}


- (void)makeViewLoad {
    self.view.backgroundColor = UIColor.whiteColor;
}

- (void)pushWithoutBottomBar:(UIViewController *)vc {
    [vc setHidesBottomBarWhenPushed:1];
    [self.navigationController pushViewController:vc animated:1];
}

@end

 

//
//  Auth.m
//  DS_playgound
//
//  Created by Eric on 2018/7/21.
//  Copyright © 2018 SDU_iOS_LAB. All rights reserved.
//

#import "Auth.h"
#import<AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>
#import "UIViewController+funcs.h"

@implementation Auth

+ (void)requestPhotosWith_Success: (void(^)(void))s  _restrict:(void(^)(void))r  _denied:  (void(^)(void))d {
    
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        if (status == PHAuthorizationStatusDenied) {
            d();
        } else if (status == PHAuthorizationStatusRestricted) {
            r();
        } else if (status == PHAuthorizationStatusAuthorized)
            s();
    }];
}

+ (void)jumpToSettings:(NSString *)destination {
    
    NSURL *url1 = [NSURL URLWithString:destination];
    NSURL *url2 = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
    if (@available(iOS 11.0, *)) {
        if ([[UIApplication sharedApplication] canOpenURL:url2]){
            [[UIApplication sharedApplication] openURL:url2 options:@{} completionHandler:nil];
        }
    } else {
        if ([[UIApplication sharedApplication] canOpenURL:url1]){
            if (@available(iOS 10.0, *)) {
                [[UIApplication sharedApplication] openURL:url1 options:@{} completionHandler:nil];
            } else {
                [[UIApplication sharedApplication] openURL:url1];
            }
        }
    }
    
}

@end

/*
 名称             对应字符串
 无线局域网       App-Prefs:root=WIFI
 蓝牙            App-Prefs:root=Bluetooth
 蜂窝移动网络     App-Prefs:root=MOBILE_DATA_SETTINGS_ID
 个人热点         App-Prefs:root=INTERNET_TETHERING
 运营商          App-Prefs:root=Carrier
 通知            App-Prefs:root=NOTIFICATIONS_ID
 通用            App-Prefs:root=General
 通用-关于本机    App-Prefs:root=General&path=About
 通用-键盘       App-Prefs:root=General&path=Keyboard
 通用-辅助功能    App-Prefs:root=General&path=ACCESSIBILITY
 通用-语言与地区   App-Prefs:root=General&path=INTERNATIONAL
 通用-还原       App-Prefs:root=Reset
 墙纸            App-Prefs:root=Wallpaper
 Siri           App-Prefs:root=SIRI
 隐私           App-Prefs:root=Privacy
 Safari         App-Prefs:root=SAFARI
 音乐           App-Prefs:root=MUSIC
 音乐-均衡器     App-Prefs:root=MUSIC&path=com.apple.Music:EQ
 照片与相机      App-Prefs:root=Photos
 FaceTime      App-Prefs:root=FACETIME
 https://www.jianshu.com/p/5fd0ac245e85
 */

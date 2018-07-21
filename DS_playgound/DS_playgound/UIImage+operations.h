//
//  UIImage+operations.h
//  SortReveal
//
//  Created by Eric on 2018/4/15.
//  Copyright © 2018 Eric. All rights reserved.
//

#import <UIKit/UIKit.h>

static UIImage * _backImage = 0; //多虑了，以前不知道系统自动缓存用过的资源，自己做的缓存
static UIImage * _pushImage = 0;

typedef NS_ENUM(NSUInteger, WaterMarkPosition) {
    WaterMarkPositionRD = 3,
    WaterMarkPositionLD = 2,
    WaterMarkPositionLU = 0,
    WaterMarkPositionRU = 1,
};


@interface UIImage (operations)

+ (UIImage *)pushImage;
+ (UIImage *)backImage;


- (UIImage *)imageWithColor:(UIColor *)color;
- (UIImage *)imageWithWaterMark:(NSString *)s postion:(WaterMarkPosition)r attributes:(NSDictionary *)a offset:(CGSize)off;


@end

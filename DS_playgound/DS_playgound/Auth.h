//
//  Auth.h
//  DS_playgound
//
//  Created by Eric on 2018/7/21.
//  Copyright © 2018 SDU_iOS_LAB. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Auth : NSObject

+ (void)requestPhotosWith_Success:  (void(^)(void))s
                         _restrict: (void(^)(void))r
                         _denied:   (void(^)(void))d;

+ (void)jumpToSettings:(NSString *)destination;



@end

NS_ASSUME_NONNULL_END

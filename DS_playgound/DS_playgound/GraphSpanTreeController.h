//
//  GraphSpanTreeController.h
//  DS_playgound
//
//  Created by Eric on 2018/7/28.
//  Copyright © 2018 SDU_iOS_LAB. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Common.h"

NS_ASSUME_NONNULL_BEGIN

@interface GraphSpanTreeController : UIViewController <UISplitViewControllerDelegate>

- (id)initWithAlgoType:(GraphAlgo)t titles:(NSArray *)ts anotherRoot:(UIViewController *)r;

@end

NS_ASSUME_NONNULL_END

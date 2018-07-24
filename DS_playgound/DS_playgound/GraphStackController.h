//
//  GraphStackController.h
//  DS_playgound
//
//  Created by Eric on 2018/7/23.
//  Copyright © 2018 SDU_iOS_LAB. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Common.h"

@interface GraphStackController : UIViewController <UISplitViewControllerDelegate>

- (id)initWithAlgoType:(GraphAlgo)t titles:(NSArray *)ts anotherRoot:(UIViewController *)r;

@end



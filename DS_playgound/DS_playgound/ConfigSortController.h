//
//  ConfigViewController.h
//  SortReveal
//
//  Created by Eric on 2018/4/12.
//  Copyright © 2018 Eric. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Common.h"
#import "SortingViewController.h"

@interface ConfigSortController : UIViewController <UISplitViewControllerDelegate>

- (id)initWithSort:(SortType)t title:(NSString *)s root:(UIViewController *)r;

@end

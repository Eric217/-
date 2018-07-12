//
//  SortingViewController.h
//  SortReveal
//
//  Created by Eric on 2018/4/11.
//  Copyright © 2018 Eric. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Common.h"

@interface SortingViewController : UIViewController
 
- (instancetype)initWithArr:(NSMutableArray *)arr sortType:(SortType)type sortOrder:(SortOrder)order;
- (void)stopTimer:(id)sender;

@end

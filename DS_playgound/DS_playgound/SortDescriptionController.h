//
//  SortDescriptionController.h
//  DS_playgound
//
//  Created by Eric on 2018/7/16.
//  Copyright © 2018 SDU_iOS_LAB. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Common.h"

@interface SortDescriptionController : UIViewController

@property (nonatomic, assign) CGSize preferredSize; ///< avail after viewDidLoad

- (instancetype)initWithTitle:(NSString *)title sortType:(SortType)st;


@end

 

//
//  SelectController.h
//  SortReveal
//
//  Created by Eric on 2018/4/24.
//  Copyright © 2018 Eric. All rights reserved.
//

#import "Common.h"
#import "DataTransmitter.h"
#import <UIKit/UIKit.h>

@interface SelectController : UIViewController

@property (nonatomic, strong) UITableView *table;
@property (nonatomic, weak) id <DataTransmitter> delegate;
@property (nonatomic, copy) NSString *currentSelection;

@end

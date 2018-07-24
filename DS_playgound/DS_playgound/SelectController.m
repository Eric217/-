//
//  SelectController.m
//  SortReveal
//
//  Created by Eric on 2018/4/24.
//  Copyright © 2018 Eric. All rights reserved.
//

#import "SelectController.h"
#import <Masonry/Masonry.h>

@interface SelectController () <UITableViewDelegate, UITableViewDataSource>
 
@end

@implementation SelectController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _table = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    [self.view addSubview:_table];
    [_table mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.size.equalTo(self.view);
    }];
    
    _table.delegate = self;
    _table.dataSource = self;
}


- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    return 0;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}

 
@end

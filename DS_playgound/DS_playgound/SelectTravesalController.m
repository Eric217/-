//
//  SelectTravesalController.m
//  DS_playgound
//
//  Created by Eric on 2018/7/16.
//  Copyright © 2018 SDU_iOS_LAB. All rights reserved.
//

#import "SelectTravesalController.h"
#import "Common.h"
#import "UIButton+init.h"

@interface SelectTravesalController ()

@property (nonatomic, strong) UILabel *promptLabel;
@property (nonatomic, copy) NSArray<NSArray *> *dataArr;
@property (nonatomic, strong) UIViewController *lastRootVC;

@end

@implementation SelectTravesalController

#define cellid @"cellid"

- (instancetype)initWithRoot:(UIViewController *)root {
    self = [super init];
    if (self)
        _lastRootVC = root;
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    _dataArr = @[@[@" 前序遍历"], @[@" 中序遍历"], @[@" 后序遍历"], @[@" 层次遍历"]];
    self.title = @"二叉树遍历";
    
    //left back item
    UIButton * _backButton = [UIButton customBackBarButtonItemWithTitle:@"返回" target:self action:@selector(dismiss:)];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:_backButton];
    
    bool oldDevice = SystemVersion < 9 || IPHONE4;
    self.navigationItem.leftBarButtonItems = oldDevice ? @[[[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(dismiss:)]] : @[backItem];

    IOS11AVAIL(^{
        self.navigationItem.largeTitleDisplayMode = UINavigationItemLargeTitleDisplayModeAutomatic;
    });
    
    [self.table registerClass:UITableViewCell.class forCellReuseIdentifier:cellid];
 
    _promptLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 130)];
    [_promptLabel setTextAlignment:NSTextAlignmentCenter];
    [_promptLabel setText:@"选择遍历方式:"];
    [_promptLabel setFont:[UIFont systemFontOfSize:30]];
    self.table.tableHeaderView = _promptLabel;
    self.table.backgroundColor = UIColor.groupTableViewBackgroundColor;
}

- (void)dismiss:(id)sender {
    [self.view.window setRootViewController:_lastRootVC];
}

//MARK: - table view

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell setSelected:0 animated:1];
   
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    cell.textLabel.text = _dataArr[indexPath.section][0];
    cell.textLabel.font = [UIFont systemFontOfSize:23];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 68;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _dataArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

//MARK: - UISplitViewDelegate
- (void)collapseSecondaryViewController:(UIViewController *)secondaryViewController forSplitViewController:(UISplitViewController *)splitViewController {
    [self.navigationController pushViewController:secondaryViewController animated:1];
}

- (BOOL)splitViewController:(UISplitViewController *)splitViewController collapseSecondaryViewController:(UIViewController *)secondaryViewController ontoPrimaryViewController:(UIViewController *)primaryViewController {
    return 0;
}

@end

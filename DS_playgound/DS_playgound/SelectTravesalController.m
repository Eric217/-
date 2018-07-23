//
//  SelectTravesalController.m
//  DS_playgound
//
//  Created by Eric on 2018/7/16.
//  Copyright © 2018 SDU_iOS_LAB. All rights reserved.
//

#import "SelectTravesalController.h"
#import "TravesalDescController.h"
#import "Common.h"
#import "UIButton+init.h"
#import <Masonry/Masonry.h>
#import "UIView+frameProperty.h"

@interface SelectTravesalController ()

@property (nonatomic, copy) NSArray<NSArray *> *dataArr;
@property (nonatomic, strong) UIViewController *lastRootVC;
@property (nonatomic, strong) UILabel *promptLabel;
@property (nonatomic, strong) UILabel *footerView;

@end

@implementation SelectTravesalController

- (instancetype)initWithRoot:(UIViewController *)root {
    self = [super init];
    if (self)
        _lastRootVC = root;
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"二叉树遍历";
    _dataArr = @[@[@" 前序遍历"], @[@" 中序遍历"], @[@" 后序遍历"], @[@" 层次遍历"]];

    // left back item
    UIButton * _backButton = [UIButton customBackBarButtonItemWithTitle:@"返回" target:self action:@selector(dismiss:)];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:_backButton];
    bool oldDevice = SystemVersion < 9 || IPHONE4;
    self.navigationItem.leftBarButtonItems = oldDevice ? @[[[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(dismiss:)]] : @[backItem];
    // back item for children
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:nil];
    self.navigationItem.backBarButtonItem.tintColor = UIColor.blackColor;
    
    //title label
    _promptLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 130)];
    [_promptLabel setTextAlignment:NSTextAlignmentCenter];
    [_promptLabel setText:@"选择遍历方式"];
    [_promptLabel setFont:[UIFont systemFontOfSize:30]];
    
    //bottom label
    NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
    paragraphStyle.lineSpacing = 4;
    paragraphStyle.firstLineHeadIndent = 45;
    paragraphStyle.headIndent = 15;
    paragraphStyle.tailIndent = -10;

    NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
    attributes[NSParagraphStyleAttributeName] = paragraphStyle;
    attributes[NSFontAttributeName] = [UIFont systemFontOfSize:16];
    attributes[NSForegroundColorAttributeName] = UIColor.darkGrayColor;
    _footerView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 72)];
    _footerView.numberOfLines = 0;
    _footerView.attributedText = [[NSAttributedString alloc] initWithString:@"二叉树遍历有很多应用，例如获取节点数、树的高度，中序遍历数学表达式树，后序遍历来析构一棵树等等。" attributes:attributes];
    
    self.table.tableHeaderView = _promptLabel;
    self.table.tableFooterView = _footerView;
    self.table.backgroundColor = UIColor.groupTableViewBackgroundColor;
   
}
- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    CGFloat w = self.view.width;
    [_promptLabel setWidth:w];
    [_footerView setWidth:w];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [[self.table cellForRowAtIndexPath:self.table.indexPathForSelectedRow] setSelected:0 animated:1];

}

- (void)dismiss:(id)sender {
    [self.view.window setRootViewController:_lastRootVC];
}

//MARK: - table view

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *t = _dataArr[indexPath.section][0];
    [t stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" "]];
    TravesalDescController *desc = [[TravesalDescController alloc] initWithTravesal:indexPath.section title:TRIM(t, @" ")];
    [self.navigationController pushViewController:desc animated:1];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [UITableViewCell new];
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    cell.textLabel.text = _dataArr[indexPath.section][0];
    cell.textLabel.font = [UIFont systemFontOfSize:22];

    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UITableViewHeaderFooterView *headerView = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:0];
    if (section == 0) {
        [headerView.textLabel setText:@"按照特定方式访问二叉树中的每一个元素。"];
        headerView.textLabel.font = [UIFont systemFontOfSize:15];
    }
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section != 0)
        return 8;
    return 22;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 58;
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

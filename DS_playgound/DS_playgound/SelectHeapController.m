//
//  SettingViewController.m
//  SortReveal
//
//  Created by Eric on 2018/4/23.
//  Copyright © 2018 Eric. All rights reserved.
//

#import "SelectHeapController.h"

@interface SelectHeapController ()

@property (nonatomic, copy) NSArray<NSString *> *dataArr;

@end

@implementation SelectHeapController

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.splitViewController.presentsWithGesture = 0;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.splitViewController.presentsWithGesture = 1;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationController.navigationBar setTintColor:UIColor.blackColor];
    [self setTitle:@"堆排序选项"];
    
    [self.table registerClass:UITableViewCell.class forCellReuseIdentifier:NSStringFromClass(UITableViewCell.class)];
    [self.table setRowHeight:50];
    _dataArr = @[String((int)PreferMaxHeap), String((int)PreferMinHeap), String((int)PreferBoth)];
    
}


//MARK: - table view
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(UITableViewCell.class)];
    NSString *txt;
    int selectInt = _dataArr[indexPath.row].intValue;
    if (selectInt == PreferMinHeap) {
        txt = MinHeapSorter;
    } else if (selectInt == PreferMaxHeap) {
        txt = MaxHeapSorter;
    } else {
        txt = BothHeap;
    }
    [[cell textLabel] setText:txt];
    
    if ([self.currentSelection isEqualToString:txt]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArr.count;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell setSelected:0 animated:1];
    [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
    [[self navigationController] popViewControllerAnimated:1];
    [self.delegate transmitData:_dataArr[indexPath.row] withIdentifier:@"1"];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UITableViewHeaderFooterView *headerView = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:0];
    if (section == 0) {
        [headerView.textLabel setText:@"堆排序时使用哪种堆进行排序"];
    }
 
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 52;
}

@end

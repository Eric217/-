//
//  SelectHeapController.m
//  SortReveal
//
//  Created by Eric on 2018/4/23.
//  Copyright © 2018 Eric. All rights reserved.
//

#import "SelectFlowController.h"

@interface SelectFlowController ()

@property (nonatomic, copy) NSArray<NSString *> *dataArr;

@end

@implementation SelectFlowController
 
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
    [self setTitle:@"自动执行方式"];
 
    [self.table registerClass:UITableViewCell.class forCellReuseIdentifier:NSStringFromClass(UITableViewCell.class)];
    [self.table setRowHeight:50];
    _dataArr = @[String((int)ExecuteWayStep), String((int)ExecuteWayGroup)];
  
}


//MARK: - table view
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(UITableViewCell.class)];
    NSString *txt;
    if (_dataArr[indexPath.row].intValue == ExecuteWayStep) {
        txt = SingleStep;
    } else {
        txt = GroupStep;
    }
    [[cell textLabel] setText:txt];

    if ([self.currentSelection isEqualToString:txt]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
   
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell setSelected:0 animated:1];
    [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
    [[self navigationController] popViewControllerAnimated:1];
    [self.delegate transmitData:_dataArr[indexPath.row] withIdentifier:@"0"];
}

//
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
//    if (section == 0) {
//        return 44;
//    }
//    return 33;
//}


//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
//    return 0;
//    //UITableViewHeaderFooterView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"headerid"];
//
//    //return headerView;
//}

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//
//    return 2;
//}




@end

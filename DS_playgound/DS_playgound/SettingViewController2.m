//
//  SettingViewController2.m
//  DS_playgound
//
//  Created by Eric on 2018/7/12.
//  Copyright © 2018 SDU_iOS_LAB. All rights reserved.
//

#import <Masonry/Masonry.h>
#import "Common.h"
#import "SettingViewController2.h"
#import "SwitchCell2.h"
#import "TextFieldCell.h"
#import "DataTransmitter.h"
#import "SelectFlowController.h"
#import "SelectHeapController.h"
#import "NSString+funcs.h"

@interface SettingViewController2 () <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, DataTransmitter>

@property (nonatomic, strong) UITableView *table;
@property (nonatomic, copy) NSArray<NSArray *> *array;

@end

@implementation SettingViewController2

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.splitViewController.presentsWithGesture = 0;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.splitViewController.presentsWithGesture = 1;
    [self resignResponder];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //works only on ipad

    if (IPAD)
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(dismiss)];
    
    [self setTitle:@"演示设置"];
    
    _table = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    [self.view addSubview:_table];
    [_table mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.size.equalTo(self.view);
    }];
    
    _table.delegate = self;
    _table.dataSource = self;
    
    [_table registerClass:UITableViewHeaderFooterView.class forHeaderFooterViewReuseIdentifier:@"headerid"];
    [_table setRowHeight:50];
    
    _array = @[@[@"跳过没有发生交换的步骤", @"如果当前步骤不会发生交换，则跳过并执行下一步(部分排序中有效)"], //1+1
               @[@"自动执行时间间隔", @"自动执行时单步或单组跳过", @"自动执行设置"], //2+1
               @[@"智能比较字母与数字", @"字符或字典排序时，使 Foo2 < Foo7 < Foo25"], //1+1
               @[@"自动推断排序方式时升序", @"忽略字母大小写", @"堆排序选项(下次生效)", @""], //3+1
               ];
    [Config postNotification:ELTextFieldShouldResignNotification message:0];
    [Config addObserver:self selector:@selector(resignResponder) notiName:ELTextFieldShouldResignNotification];
    
}

//MARK: - 业务需求处理

- (void)dismiss {
    [self.navigationController dismissViewControllerAnimated:0 completion:nil];
}

- (void)resignResponder {
    [_table endEditing:1];
}

- (void)didChangeSkipNull:(UISwitch *)sender {
    [Config saveDouble:sender.isOn forKey:kSkipNullStep];
}

- (void)didChangeNumericCompare:(UISwitch *)sender {
    [Config saveDouble:sender.isOn forKey:kNumericCompare];
}

- (void)didChangeAutomaticOrder:(UISwitch *)sender {
    [Config saveDouble:!(sender.isOn) forKey:kAutomaticOrderASD];
}

- (void)didChangeIgnoringCases:(UISwitch *)sender {
    [Config saveDouble:sender.isOn forKey:kIgnoringCases];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField endEditing:1];
    return 1;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    UITextPosition *end = [textField endOfDocument];
    UITextPosition *start = [textField positionFromPosition:end offset:-textField.text.length];
    textField.selectedTextRange = [textField textRangeFromPosition:start toPosition:end];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField.text.length == 8) {
        return 0;
    }
    return 1;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    
    NSString *origiText = [NSString stringWithFormat:@"%.2f", [UserDefault doubleForKey:kTimeInterval]];
    BOOL e = 0;
    double interval = [textField.text doubleValueWithError:&e];
    if (interval < 0.3 || interval > 10) {
        textField.text = origiText;
    } else {
        [Config saveDouble:interval forKey:kTimeInterval];
    }
    return 1;
}

- (void)dealloc
{
    [Config removeObserver:self];
}

#define cellId @"cellid"

//MARK: - table view

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *tableCell;
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            tableCell = [self switchCellWithAction:@selector(didChangeSkipNull:) isOn:[UserDefault boolForKey:kSkipNullStep]];
        }
        
    } else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            TextFieldCell *cell = [[TextFieldCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];//NSStringFromClass(TextFieldCell.class)];
            cell.textField.delegate = self;
            double ti = [UserDefault doubleForKey:kTimeInterval];
            [cell.textField setText:[NSString stringWithFormat:@"%.2f", ti]];
            tableCell = cell;
            
        } else if (indexPath.row == 1) {
            
            UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellId];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            NSInteger exew = [UserDefault integerForKey:kFlowExecWay];
            if (exew == ExecuteWayStep) {
                cell.detailTextLabel.text =  SingleStep;
            } else {
                cell.detailTextLabel.text = GroupStep;
            }
            tableCell = cell;
        }
    } else if (indexPath.section == 2) {
        if (indexPath.row == 0) {
            tableCell = [self switchCellWithAction:@selector(didChangeNumericCompare:) isOn:[UserDefault boolForKey:kNumericCompare]];
        } else if (indexPath.row == 1) {
            
        }
    } else if (indexPath.section == 3) {
        if (indexPath.row == 0) {
            tableCell = [self switchCellWithAction:@selector(didChangeAutomaticOrder:) isOn:![UserDefault boolForKey:kAutomaticOrderASD]];
        } else if (indexPath.row == 1) {
            tableCell = [self switchCellWithAction:@selector(didChangeIgnoringCases:) isOn:[UserDefault boolForKey:kIgnoringCases]];
        } else if (indexPath.row == 2) {
            UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellId];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            NSInteger exew = [UserDefault integerForKey:kPreferredHeap];
            if (exew == PreferMaxHeap) {
                cell.detailTextLabel.text = MaxHeapSorter;
            } else if (exew == PreferBoth) {
                cell.detailTextLabel.text = BothHeap;
            } else {
                cell.detailTextLabel.text = MinHeapSorter;
            }
            tableCell = cell;
        }
    }
    
    tableCell.textLabel.text = _array[indexPath.section][indexPath.row];
    
    return tableCell;
}

- (SwitchCell2 *)switchCellWithAction:(SEL)action isOn:(BOOL)on {
    SwitchCell2 *cell =  [[SwitchCell2 alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];//NSStringFromClass(SwitchCell.class)];
    [cell.switcher addTarget:self action:action forControlEvents:UIControlEventValueChanged];
    [[cell switcher] setOn:on];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 66;
    }
    return 33;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UITableViewHeaderFooterView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"headerid"];
    NSUInteger c = _array[section].count;
    headerView.textLabel.text = _array[section][c-1];
    return headerView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return _array.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _array[section].count-1;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    
    [Config postNotification:ELTextFieldShouldResignNotification message:0];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:1];
    
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            TextFieldCell *textFiel = [tableView cellForRowAtIndexPath:indexPath];
            [textFiel.textField becomeFirstResponder];
        } else if (indexPath.row == 1) {
            SelectFlowController *vc = [[SelectFlowController alloc] init];
            vc.delegate = self;
            vc.currentSelection = [[tableView cellForRowAtIndexPath:indexPath] detailTextLabel].text;
            [self.navigationController pushViewController:vc animated:1];
        }
    } else if (indexPath.section == 3) {
        if (indexPath.row == 2) {
            SelectHeapController *vc = [[SelectHeapController alloc] init];
            vc.delegate = self;
            vc.currentSelection = [[tableView cellForRowAtIndexPath:indexPath] detailTextLabel].text;
            [self.navigationController pushViewController:vc animated:1];
            
        }
    }
    
}

- (void)transmitData:(id)data withIdentifier:(nullable NSString *)identitifier {
    NSString *dataA = data;
    
    if ([identitifier isEqualToString:@"0"]) {
        UITableViewCell *cell = [_table cellForRowAtIndexPath:IndexPath(1, 1)];
        NSString *r;
        if (dataA.intValue == ExecuteWayStep) {
            r = SingleStep;
        } else
            r = GroupStep;
        if (cell.detailTextLabel.text != r) {
            cell.detailTextLabel.text = r;
            [Config saveDouble:dataA.intValue forKey:kFlowExecWay];
        }
    } else if ([dataA isEqualToString:@"1"]) {
        UITableViewCell *cell = [_table cellForRowAtIndexPath:IndexPath(2, 3)];
        NSString *r;
        int selecI = dataA.intValue;
        if (selecI == PreferMinHeap) {
            r = MinHeapSorter;
        } else if (selecI == PreferMaxHeap) {
            r = MaxHeapSorter;
        } else {
            r = BothHeap;
        }
        if (cell.detailTextLabel.text != r) {
            cell.detailTextLabel.text = r;
            [Config saveDouble:selecI forKey:kPreferredHeap];
        }
        
    }
}


@end

//
//  GraphStackController.m
//  DS_playgound
//
//  Created by Eric on 2018/7/23.
//  Copyright © 2018 SDU_iOS_LAB. All rights reserved.
//

#import "GraphStackController.h"
#import "StackViewCell.h"
#import "GraphDescController.h"

#import "UIButton+init.h"
#import "UIImage+operations.h"
#import "UIView+funcs.h"

#import <Masonry/Masonry.h>

@interface GraphStackController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *table;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UITableViewCell *selectStart;
@property (nonatomic, strong) UIButton *startShow;

@property (nonatomic, copy) NSMutableArray *stackData;
@property (nonatomic, strong) UIViewController *anotherRootVC;

@property (nonatomic, assign) GraphAlgo algoType;
@property (nonatomic, copy) NSArray *titles;
@property (nonatomic, assign) int start_pos;


@end

@implementation GraphStackController

- (id)initWithAlgoType:(GraphAlgo)t titles:(NSArray *)ts anotherRoot:(UIViewController *)r {
    self = [super init];
    _algoType = t;
    _anotherRootVC = r;
    _titles = ts;
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = TableBackLightColor;
    
    // navigation items
    self.navigationItem.title = _titles[1];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"原理" style:UIBarButtonItemStylePlain target:self action:@selector(showAlgorithm)];
    self.navigationItem.rightBarButtonItem.tintColor = UIColor.blackColor;
    UIButton * _backButton = [UIButton customBackBarButtonItemWithTitle:@"返回" target:self action:@selector(dismiss)];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:_backButton];
    bool oldDevice = SystemVersion < 9 || IPHONE4;
    self.navigationItem.leftBarButtonItem = oldDevice ? [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(dismiss)] : backItem;
    self.navigationItem.backBarButtonItem = BARBUTTON(@"返回", 0);
    
    // algorithm name label
    _nameLabel = [UILabel new];
    NSString *algoName = [_titles[0] stringByAppendingString:@" 算法"];
    NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
    paragraphStyle.alignment = NSTextAlignmentCenter;
    NSDictionary *attr = @{NSFontAttributeName: [UIFont fontWithName:LetterFont size:28], NSParagraphStyleAttributeName: paragraphStyle};
    _nameLabel.attributedText = [[NSAttributedString alloc] initWithString:algoName attributes:attr];;
    [self.view addSubview:_nameLabel];
    
    // select start view
    _selectStart = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:0];
    [self.view addSubview:_selectStart];
    _selectStart.textLabel.font = [UIFont systemFontOfSize:18];
    _selectStart.detailTextLabel.font = [UIFont systemFontOfSize:18];
    _selectStart.detailTextLabel.textColor = UIColor.darkGrayColor;
    _selectStart.textLabel.text = @"图中点击选择起点:";

    // table view
    _table = [UITableView new];
    [self.view addSubview:_table];
    _table.delegate = self;
    _table.dataSource = self;
    _table.allowsSelection = 0;
    _table.backgroundColor = UIColor.whiteColor;
    
    [_table roundStyleWithColor:UIColor.whiteColor width:1.5 radius:6];
  
    _table.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_table setContentInset:UIEdgeInsetsMake(20, 0, 0, 0)];
    _table.showsVerticalScrollIndicator = 0;
    _table.showsHorizontalScrollIndicator = 0;
    _table.transform = CGAffineTransformMakeRotation(M_PI);
    _table.scrollsToTop = 0;
    [_table registerClass:StackViewCell.class forCellReuseIdentifier:NSStringFromClass(StackViewCell.class)];
    
    // start show button
    _startShow = [UIButton buttonWithTitle:@"开始演示" fontSize:23 textColor:UIColor.blackColor target:self action:@selector(startDisplay:) image:[UIImage pushImage]];
    [_startShow setTitleEdgeInsets:UIEdgeInsetsMake(0, -20, 0, 0)];
    [_startShow setImageEdgeInsets:UIEdgeInsetsMake(0, 125, 0, 0)];
    [self.view addSubview:_startShow];
    
    // constraints
    
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(36);
        make.top.equalTo(self.view).offset(64+[Config v_pad:33 plus:18 p:12 min:8]);
    }];
    
    [_selectStart mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameLabel.mas_bottom).offset([Config v_pad:20 plus:13 p:12 min:8]);
        make.centerX.equalTo(self.view);
        make.width.mas_equalTo(250);
        make.height.mas_equalTo(40);
    }];
    
    [_startShow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).inset([Config v_pad:41 plus:34 p:30 min:24]);
        make.height.mas_equalTo(44);
        make.centerX.equalTo(self.view);
    }];
    
    [_table mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(40);
        make.right.equalTo(self.view).inset(40);
        make.top.equalTo(self.selectStart.mas_bottom).offset(18);
        make.bottom.equalTo(self.startShow.mas_top).inset(22);
    }];
    
    _stackData = [NSMutableArray new];
    
    [Config addObserver:self selector:@selector(didReceivePointInfo:) notiName:ELGraphDidSelectPointNotification];
    [Config addObserver:self selector:@selector(stackShouldOperate:) notiName:ELStackDidChangeNotification];
    [Config addObserver:self selector:@selector(clearStack) notiName:ELGraphDidRestartShowNotification];
}

- (void)didReceivePointInfo:(NSNotification *)noti {
    _start_pos = [noti.userInfo[@"id"] intValue];
    _selectStart.detailTextLabel.text = noti.userInfo[@"name"];
}


- (void)startDisplay:(id)sender {
    if (self.splitViewController.viewControllers.count == 1) { 
        // 手机版另行适配
    }
    
    // TODO: - 提示框，是否重置
 
    [Config postNotification:ELGraphShouldStartShowNotification message:@{NotiInfoId: String(_start_pos)}];
   
}

- (void)stackShouldOperate:(NSNotification *)noti {
    if (_algoType == GraphAlgoDFS) {
        NSString *optNodeName = noti.userInfo[NotiInfoName];
        int opt = [noti.userInfo[NotiInfoId] intValue];
        if (opt == 0) {
            optNodeName = optNodeName.mutableCopy;
            [_stackData addObject:optNodeName];
            NSIndexPath *idx = IndexPath(_stackData.count-1, 1);
            [_table insertRowsAtIndexPaths:@[idx] withRowAnimation:UITableViewRowAnimationBottom];
            [_table scrollToRowAtIndexPath:idx atScrollPosition:UITableViewScrollPositionTop animated:1];
        } else if (opt == 1) {
            [_stackData removeLastObject];
            [_table deleteRowsAtIndexPaths:@[IndexPath(_stackData.count, 1)] withRowAnimation:UITableViewRowAnimationBottom];
        }
    } else if (_algoType == GraphAlgoBFS) {
        NSArray<NSString *> *in_names = noti.userInfo[NotiInfoId];
        int c = (int)in_names.count;
        for (int i = 0; i < c; i++) {
            [_stackData insertObject:in_names[i].mutableCopy atIndex:0];
            [_table insertRowsAtIndexPaths:@[IndexPath(0, 1)] withRowAnimation:UITableViewRowAnimationTop];
            [_table scrollToRowAtIndexPath:IndexPath(_stackData.count-1, 1) atScrollPosition:UITableViewScrollPositionTop animated:1];
        }
        
        NSString *out_name = noti.userInfo[NotiInfoName];
        if (out_name.length > 0) {
            [_stackData removeLastObject];
            [_table deleteRowsAtIndexPaths:@[IndexPath(_stackData.count, 1)] withRowAnimation:UITableViewRowAnimationBottom];
        }
    }

}

- (void)clearStack {
    [_stackData removeAllObjects];
    [_table reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationBottom];
}


- (void)showAlgorithm {
    [self.navigationController pushViewController:[[GraphDescController alloc] initWithAlgoType:_algoType titles:_titles] animated:1];
}

- (void)dismiss {
    [self.view.window setRootViewController:_anotherRootVC];
}

//MARK: - UISplitViewDelegate
- (void)collapseSecondaryViewController:(UIViewController *)secondaryViewController forSplitViewController:(UISplitViewController *)splitViewController {
    [self.navigationController pushViewController:secondaryViewController animated:1];
}

- (BOOL)splitViewController:(UISplitViewController *)splitViewController collapseSecondaryViewController:(UIViewController *)secondaryViewController ontoPrimaryViewController:(UIViewController *)primaryViewController {
    return 0;
}

//MARK: - Table View

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    if (indexPath.section == 1) {
        cell = [[StackViewCell alloc] initWithReuseId:NSStringFromClass(StackViewCell.class)];
        cell.textLabel.text = _stackData[indexPath.row];
    } else if (indexPath.section == 0) {
        cell = [[StackViewCell alloc] initWithReuseId:NSStringFromClass(StackViewCell.class)];
        if (_algoType == GraphAlgoDFS) {
            cell.textLabel.text = @"栈底";
        } else if (_algoType == GraphAlgoBFS) {
            cell.textLabel.text = @"队列尾";
        }
    } else { // section == 2
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:0];
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        if (_algoType == GraphAlgoDFS) {
            cell.textLabel.text = @"栈顶";
        } else if (_algoType == GraphAlgoBFS) {
            cell.textLabel.text = @"队列头";
        }

        cell.textLabel.font = [UIFont systemFontOfSize:21];
    }
    
    cell.transform = CGAffineTransformMakeRotation(M_PI);
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 58;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 1)
         return _stackData.count;
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (void)dealloc {
    [Config removeObserver:self];
}

@end





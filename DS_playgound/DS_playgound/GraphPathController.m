//
//  GraphPathController.m
//  DS_playgound
//
//  Created by Eric on 2018/7/30.
//  Copyright © 2018 SDU_iOS_LAB. All rights reserved.
//

#import "GraphPathController.h"
#import "GraphDescController.h"
#import "PathViewCell.h"

#import "UIView+funcs.h"
#import "UIButton+init.h"
#import "UIImage+operations.h"
#import "UILabel+init.h"
#import "NSString+funcs.h"
#import <Masonry/Masonry.h>

@interface GraphPathController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *table;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UIButton *startShow;
@property (nonatomic, strong) UILabel *tableHeaderPrompt;
@property (nonatomic, strong) UITableViewCell *selectStart;
@property (nonatomic, strong) UIViewController *anotherRootVC;

@property (nonatomic, copy) NSArray *titles;
@property (nonatomic, copy) NSMutableArray *dataArr;

@property (nonatomic, assign) int start_pos;
@property (nonatomic, assign) GraphAlgo algoType;

@end

@implementation GraphPathController

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
    _selectStart.textLabel.font = [UIFont systemFontOfSize:18.5];
    _selectStart.detailTextLabel.font = [UIFont systemFontOfSize:18.5];
    _selectStart.detailTextLabel.textColor = UIColor.darkGrayColor;
    _selectStart.textLabel.text = @"图中点击选择起点 :";
    
    _tableHeaderPrompt = [UILabel labelWithCentredTitle:@"" fontSize:18];
    [self.view addSubview:_tableHeaderPrompt];
    
    // table view
    _table = [UITableView new];
    [self.view addSubview:_table];
    _table.delegate = self;
    _table.dataSource = self;
    _table.allowsSelection = 0;
    _table.backgroundColor = UIColor.whiteColor;

    [_table roundStyleWithColor:UIColor.whiteColor width:1.5 radius:6];
    
    [_table setContentInset:UIEdgeInsetsMake(9, 0, 3, 0)];
    [_table registerClass:PathViewCell.class forCellReuseIdentifier:NSStringFromClass(PathViewCell.class)];
   
    // start show button
    _startShow = [UIButton buttonWithTitle:@"开始演示" fontSize:23 textColor:UIColor.blackColor target:self action:@selector(startDisplay:) image:[UIImage pushImage]];
    [_startShow setTitleEdgeInsets:UIEdgeInsetsMake(0, -20, 0, 0)];
    [_startShow setImageEdgeInsets:UIEdgeInsetsMake(0, 125, 0, 0)];
    [self.view addSubview:_startShow];
    
    // constraints
    
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.height.equalTo(@36);
        make.top.equalTo(self.view).offset(64+[Config v_pad:31 plus:18 p:12 min:8]);
    }];
    
    [_selectStart mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameLabel.mas_bottom).offset([Config v_pad:18 plus:13 p:12 min:8]);
        make.centerX.equalTo(self.view);
        make.width.equalTo(@258.58);
        make.height.equalTo(@26);
    }];
    
    [_tableHeaderPrompt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@26);
        make.left.equalTo(self.view).offset(15);
        make.right.equalTo(self.view).inset(15);
        make.top.equalTo(self.selectStart.mas_bottom).offset(3);
    }];
    
    [_startShow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).inset([Config v_pad:40 plus:34 p:30 min:24]);
        make.height.mas_equalTo(44);
        make.centerX.equalTo(self.view);
    }];
    
    [_table mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(40);
        make.right.equalTo(self.view).inset(40);
        make.top.equalTo(self.tableHeaderPrompt.mas_bottom).offset(15);
        make.bottom.equalTo(self.startShow.mas_top).inset(20);
    }];
    
    _dataArr = [NSMutableArray new];
//    [NSString stringWithFormat:@"到达 %@ 最短距离: %d", , 1];
    [_dataArr addObject:@[@"到达 2 最短距离: 25", @"1 -> 4 -> 7 -> 5 -> 2 -> 4 -> 7 -> 5 -> 4 -> 7 -> 5"]];
    [_dataArr addObject:@[@"到达 2 最短距离: 25", @"1 -> 4 -> 7 -> 5 -> 2 -> 4 -> 7 -> 5 -> 4 -> 7 -> 5"]];
    [_dataArr addObject:@[@"到达 2 最短距离: 25", @"1 -> 4 -> 7 -> 5 -> 2 -> 4 -> 7 -> 5 -> 4 -> 7 -> 5"]];
    [_dataArr addObject:@[@"test", @"tedataArr addObjecdataArr addObjecst2"]];
    [_dataArr addObject:@[@"test", @"test2"]];
    [_dataArr addObject:@[@"tedataArr addObjecdataArr addObjecst", @"tesdataArr addObjecdataArr addObject2"]];
    [_dataArr addObject:@[@"test", @"test2"]];
    [_dataArr addObject:@[@"tedataArr addObjecdataArr addObjecst", @"test2"]];
    [_dataArr addObject:@[@"tesdataArr addObjecdataArr addObject", @"tdataArr addObjecdataArr addObjecdataArr addObjecdataArr addObjecest2"]];

//    [_dataArr removeAllObjects];

    [Config addObserver:self selector:@selector(didReceivePointInfo:) notiName:ELGraphDidSelectPointNotification];
    [Config addObserver:self selector:@selector(stackShouldOperate:) notiName:ELStackDidChangeNotification];
    [Config addObserver:self selector:@selector(clearStack) notiName:ELGraphDidRestartShowNotification];
    
}

- (void)didReceivePointInfo:(NSNotification *)noti {
    _start_pos = [noti.userInfo[@"id"] intValue];
    NSString *pos_name = noti.userInfo[@"name"];
    _selectStart.detailTextLabel.text = pos_name;
    _tableHeaderPrompt.text = [NSString stringWithFormat:@"从 %@ 到各顶点的最短路如下 :", pos_name];
    
}


- (void)startDisplay:(id)sender {
    if (self.splitViewController.viewControllers.count == 1) {
        // 手机版另行适配
    }
    
    // TODO: - 提示框，是否重置
    
    [Config postNotification:ELGraphShouldStartShowNotification message:@{NotiInfoId: String(_start_pos)}];
    
}

- (void)stackShouldOperate:(NSNotification *)noti {
    if (_algoType == GraphAlgoDIJ) {
        
        
        
    }
    
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    CGFloat new_w = [_tableHeaderPrompt.text sizeWithAttr:0 maxSize:CGSizeMake(self.view.bounds.size.width-30, 26) orFontS:18].width + 30;

    [_selectStart mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo([NSNumber numberWithDouble:new_w]);
    }];
    
}


- (void)clearStack {
    [_dataArr removeAllObjects];
    [_table reloadData];
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
    PathViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(PathViewCell.class)forIndexPath:indexPath];
    
    [cell fillLabelWithTitle:_dataArr[indexPath.row][0] body:_dataArr[indexPath.row][1]];
    
    return cell;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    return 58;
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArr.count;
}

- (void)dealloc {
    [Config removeObserver:self];
}


@end

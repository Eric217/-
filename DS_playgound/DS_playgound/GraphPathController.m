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
@property (nonatomic, strong) NSString *current_name;
@property (nonatomic, assign) int current_pos;

@property (nonatomic, assign) int latest_clicked_pos;

@property (nonatomic, assign) GraphAlgo algoType;

@property (nonatomic, assign) bool start_clicked;
@property (nonatomic, copy) NSMutableArray<NSMutableArray *> *dataArr;


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
    _table.tableFooterView = [UIView new];
    
    [_table roundStyleWithColor:UIColor.whiteColor width:1.5 radius:6];
    
    [_table setContentInset:UIEdgeInsetsMake(9, 0, 3, 0)];
    [_table registerClass:PathViewCell.class forCellReuseIdentifier:NSStringFromClass(PathViewCell.class)];
   
    // start show button
    _startShow = [UIButton buttonWithTitle:@"开始演示" fontSize:23 textColor:UIColor.blackColor target:self action:@selector(startDisplay:) image:[UIImage pushImage]];
    [_startShow setTitleEdgeInsets:UIEdgeInsetsMake(0, -20, 0, 0)];
    [_startShow setImageEdgeInsets:UIEdgeInsetsMake(0, 125, 0, 0)];
    [self.view addSubview:_startShow];
    _start_clicked = 0;
    // constraints
    
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.height.equalTo(@36);
        make.top.equalTo(self.view).offset(64+[Config v_pad:33 plus:18 p:12 min:8]);
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
        make.top.equalTo(self.selectStart.mas_bottom).offset(1.5);
    }];
    
    [_startShow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).inset([Config v_pad:39 plus:34 p:30 min:24]);
        make.height.mas_equalTo(38);
        make.centerX.equalTo(self.view);
    }];
    
    [_table mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(42);
        make.right.equalTo(self.view).inset(42);
        make.top.equalTo(self.tableHeaderPrompt.mas_bottom).offset(15);
        make.bottom.equalTo(self.startShow.mas_top).inset(18);
    }];
    
    [Config addObserver:self selector:@selector(didReceivePointInfo:) notiName:ELGraphDidSelectPointNotification];
    
    [Config addObserver:self selector:@selector(pathTableDidChange:) notiName:ELStackDidChangeNotification];
  
    [Config addObserver:self selector:@selector(getTableInitData:) notiName:ELGraphDidInitPathTableNotification];
    
}

- (void)didReceivePointInfo:(NSNotification *)noti {
    _latest_clicked_pos = [noti.userInfo[@"id"] intValue];
    _current_name = noti.userInfo[@"name"];
    _selectStart.detailTextLabel.text = _current_name;
    if (!_start_clicked)
        _tableHeaderPrompt.text = [NSString stringWithFormat:@"从 %@ 到各顶点的最短路如下 :", _current_name];
    
}

- (void)getTableInitData:(NSNotification *)noti {
    _dataArr = noti.userInfo[@"0"];
    [_table reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
}


- (void)startDisplay:(id)sender {
    _start_clicked = 1;
    if (_start_clicked)
        _tableHeaderPrompt.text = [NSString stringWithFormat:@"从 %@ 到各顶点的最短路如下 :", _current_name];
    else _start_clicked = 1;
    
    if (self.splitViewController.viewControllers.count == 1) {
        // 手机版另行适配
    }
    
    // TODO: - 提示框，是否重置
    _current_pos = _latest_clicked_pos;
    [Config postNotification:ELGraphShouldStartShowNotification message:@{NotiInfoId: String(_latest_clicked_pos)}];
    
}

- (void)pathTableDidChange:(NSNotification *)noti {
    if (_algoType == GraphAlgoDIJ) {
        NSString *_id = noti.userInfo[@"0"];
        int __id = [_id intValue];
        int p = __id < _current_pos ? __id - 1 : __id - 2;
        
        _dataArr[p][1] = noti.userInfo[@"1"];
        _dataArr[p][2] = noti.userInfo[@"2"];
        NSIndexPath *idx = IndexPath_Sec0(p);
        [_table reloadRowsAtIndexPaths:@[idx] withRowAnimation:UITableViewRowAnimationRight];
        
        UITableViewCell *cell = [_table cellForRowAtIndexPath:idx];
        if (!CGRectContainsRect(_table.bounds, cell.frame))
            [_table scrollToRowAtIndexPath:idx atScrollPosition:__id < _dataArr.count/2 ? UITableViewScrollPositionTop : UITableViewScrollPositionBottom animated:1];
        
    }
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    CGFloat new_w = [_tableHeaderPrompt.text sizeWithAttr:0 maxSize:CGSizeMake(self.view.bounds.size.width-30, 26) orFontS:18].width + 30;

    [_selectStart mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo([NSNumber numberWithDouble:new_w]);
    }];
    
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
    
    [cell fillLabelWithTitle:_dataArr[indexPath.row][1] body:_dataArr[indexPath.row][2]];
    
    return cell;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArr.count;
}

- (void)dealloc {
    [Config removeObserver:self];
}


@end

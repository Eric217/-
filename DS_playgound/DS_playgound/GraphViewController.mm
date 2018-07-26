//
//  GraphViewController.m
//  DS_playgound
//
//  Created by Eric on 2018/7/24.
//  Copyright © 2018 SDU_iOS_LAB. All rights reserved.
//

#import "GraphViewController.h"
#import "GraphView.h"
#import "GraphSettingController.h"

#import "UIView+funcs.h"
#import "UIImage+operations.h"
#import "UIViewController+funcs.h"
#import "UIViewController+SplitController.h"

#import "SQLiteManager.h"
#import "AdjacencyWGraph.mm"
#import <Masonry/Masonry.h>

@interface GraphViewController ()

@property (nonatomic, strong) GraphView *graphView;
//Right 2
@property (nonatomic, strong) UIBarButtonItem *capture;
@property (nonatomic, strong) UIBarButtonItem *settings;
//Bottom 3
@property (nonatomic, strong) UIBarButtonItem *nextStepButton;
@property (nonatomic, strong) UIBarButtonItem *resultButton;
@property (nonatomic, strong) UIBarButtonItem *restartButton;

@property (nonatomic, assign) GraphAlgo algoType;
@property (nonatomic, copy) NSArray<NSString *> *titles; ///< title, sub

@property (nonatomic, assign) AdjacencyWGraph<int> *aw_graph;
@property (nonatomic, assign) int nodecount;
@property (nonatomic, assign) int start_pos;
@property (nonatomic, assign) bool finished;


@end

@implementation GraphViewController

- (id)initWithAlgoType:(GraphAlgo)t titles:(NSArray *)ts {
    self = [super init];
    _algoType = t;
    _titles = ts;
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Navigation Item
    self.view.backgroundColor = UIColor.whiteColor;
    _capture = BARBUTTON(@"保存图片", @selector(captureScreen:));
    _capture.tintColor = UIColor.blackColor;
    _settings = BARBUTTON(@" 设置", @selector(openSettings:));
    _settings.tintColor = UIColor.blackColor;
    self.navigationItem.rightBarButtonItems = @[_settings, _capture];
    self.navigationItem.leftBarButtonItem = BARBUTTON(@"自定义图", @selector(customGraph));
    self.navigationItem.title = [_titles[0] stringByAppendingString:@" 算法"];
    
    // Toolbar Item
    _nextStepButton = BARBUTTON(@"下一步", @selector(nextStep:));
    _restartButton = BARBUTTON(@"重新开始", @selector(restart:));
    if (_algoType != GraphAlgoDFS && _algoType != GraphAlgoBFS) {
        _resultButton = BARBUTTON(@"显示结果", @selector(showResult:));
        self.toolbarItems = @[FlexibleSpace, _restartButton, _resultButton, _nextStepButton];
    } else
        self.toolbarItems = @[FlexibleSpace, _restartButton, _nextStepButton];
    [self enableButtons:0];
    
    // graph view
    _graphView = [[GraphView alloc] init];
    [self.view addSubview:_graphView];
    
    [_graphView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(15);
        make.top.equalTo(self.view).offset(64+16);
        make.bottom.equalTo(self.view).inset(44);
        make.right.equalTo(self.view).inset(15);
    }];
    
    _start_pos = 0;
    [self retriveGraph:[UserDefault objectForKey:kLatestGraph]];
    if (_nodecount > 0) {
        [Config postNotification:ELGraphDidSelectPointNotification message:@{NotiInfoId: @"1", NotiInfoName: [_graphView verticeWithOrder:1].name}];
    }
    
    [Config addObserver:self selector:@selector(indicateStart:) notiName:ELGraphShouldStartShowNotification];

    
}



- (void)indicateStart:(NSNotification *)noti {
    int s = [noti.userInfo[NotiInfoId] intValue];
    if (!_start_pos) {
        // 开始
    } else if (s == _start_pos) {
        // if !finished, 提示重新开始吗
        // else 开始
    } else {
        // if !finished, 提示是否演示新的
        // else 开始
    }
    // temp: start, in all cases.
    [self startShowFrom:s];
}

- (void)startShowFrom:(int)pos {
    _start_pos = pos;
    
 
    if (_algoType == GraphAlgoDFS) {
        IntPair p = _aw_graph->startDFSFrom(pos);
        [[_graphView verticeWithOrder:p.v2] setColor:UIColor.redColor];
        
        
        
    } else if (_algoType == GraphAlgoBFS) {
        
    } else if (_algoType == GraphAlgoKRU) {
        
    } else if (_algoType == GraphAlgoPRI) {
        
    } else if (_algoType == GraphAlgoDIJ) {
        
    } else {}
 
    
}


- (void)retriveGraph:(NSString *)name {
 
    NSString *sql = [NSString stringWithFormat:@"select nname, centerx x, centery y, gorder __id from graph_node where gid = (select gid from graph where gname = '%@')", name];
 
    NSArray *nodes = [SQLiteManager.shared querySQL:sql];
    
    _nodecount = (int)nodes.count;
    _aw_graph = new AdjacencyWGraph<int>(_nodecount);

    for (NSDictionary *node in nodes) {
        NodeView *nodeView = [[NodeView alloc] initWithId:[node[@"__id"] intValue] name:node[@"nname"] s_center:{[node[@"x"] doubleValue], [node[@"y"] doubleValue]}];
        [_graphView addSubview:nodeView];
        [_graphView.vertices addObject:nodeView];
    }
 
    sql = [NSString stringWithFormat:@"select n_s_o s, n_e_o e, weight w from graph_edge where gid = (select gid from graph where gname = '%@')", name];
    NSArray *edges = [SQLiteManager.shared querySQL:sql];
    for (NSDictionary *edge in edges) {
        int weight = [edge[@"w"] intValue];
        int start_id = [edge[@"s"] intValue];
        int end_id = [edge[@"e"] intValue];
        _aw_graph->addEdge(start_id, end_id, weight);
        GraphEdge *edgeView = [[GraphEdge alloc] initWithWeight:weight start:[_graphView verticeWithOrder:start_id] end:[_graphView verticeWithOrder:end_id]];
        [_graphView.edges addObject:edgeView];
    }
 
    
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];

    CGFloat rateX = _graphView.bounds.size.width;
    CGFloat rateY = _graphView.bounds.size.height;
    CGFloat s = 2*[UserDefault doubleForKey:kGraphRadius];

    for (NodeView *node in _graphView.vertices) {
        [node setBounds:CGRectMake(0, 0, s, s)];
        [node setCenter:{node.s_center.x * rateX, node.s_center.y * rateY}];
    }
    
}

- (void)restart:(UIBarButtonItem *)sender {
 
}


- (void)nextStep:(UIBarButtonItem *)sender {
    
    
    
}

- (void)enableButtons:(bool)b {
    _nextStepButton.enabled = b;
    _resultButton.enabled = b;
}

- (void)showResult:(UIBarButtonItem *)sender {
  
}

- (void)customGraph {
    
}

- (void)openSettings:(id)sender {
    
    if ([self.splitViewController isFullScreen] || [self.splitViewController canPullHideLeft]) {
        [self presentPop:[GraphSettingController new] attach:_settings];
    } else
        [self pushWithoutBottomBar:[GraphSettingController new]];
    
}

- (void)captureScreen:(UIBarButtonItem *)sender {
    [self saveImage:[[_graphView normalSnapshotImage] imageWithWaterMark:_titles[0] postion:WaterMarkPositionLU attributes:0 offset:CGSizeMake(40, 40)]];
}

- (void)dealloc {
    if (_aw_graph)
        delete _aw_graph;
}
@end

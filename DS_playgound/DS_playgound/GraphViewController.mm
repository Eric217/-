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
#import "UILabel+init.h"
#import "UIImage+operations.h"
#import "UIViewController+funcs.h"
#import "UIViewController+SplitController.h"

#import "SQLiteManager.h"
#import "AdjacencyWGraph.mm"
#import <Masonry/Masonry.h>

@interface GraphViewController ()

@property (nonatomic, strong) GraphView *graphView;
@property (nonatomic, strong) UILabel *promptLabel;

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
    _restartButton.enabled = 0;
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
    
    _promptLabel = [UILabel labelWithTitle:0 fontSize:20 align:NSTextAlignmentLeft];
    [self.view addSubview:_promptLabel];
    [_promptLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.equalTo(self.graphView);
        make.size.mas_equalTo(CGSizeMake(300, 45));
    }];
    
    _start_pos = 0;

    [self retriveGraph:[UserDefault objectForKey:kLatestGraph]];
    if (_nodecount > 0) {
        [Config postNotification:ELGraphDidSelectPointNotification message:@{NotiInfoId: @"1", NotiInfoName: [_graphView verticeWithOrder:1].name}];
    }
    
    [Config addObserver:self selector:@selector(indicateStart:) notiName:ELGraphShouldStartShowNotification];
    
    
}


/// 通知传来开始消息，那么确定要开始吗(拦截)？
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

/// 重新开始、通知要求开始 最后都从这里开始
- (void)startShowFrom:(int)pos {
    _start_pos = pos;
    _finished = 0;
    [self enableButtons:1];
    _restartButton.enabled = 1;
    [self updatePromptsWithIn:0 Out:0];
    [_graphView reset];
    [Config postNotification:ELGraphDidRestartShowNotification message:0];
    
    
    if (_algoType == GraphAlgoDFS) {
        [self handleDFSPack:_aw_graph->startDFSFrom(pos)];
    } else if (_algoType == GraphAlgoBFS) {
        [self handleBFSPack:_aw_graph->startBFSFrom(pos)];
    } else if (_algoType == GraphAlgoKRU) {
        
    } else if (_algoType == GraphAlgoPRI) {
        
    } else if (_algoType == GraphAlgoDIJ) {
        
    } else {}

}
- (void)nextStep:(UIBarButtonItem *)sender {
    
    if (_algoType == GraphAlgoDFS) {
        [self handleDFSPack:_aw_graph->nextDFSStep(&_finished)];
    } else if (_algoType == GraphAlgoBFS) {
        [self handleBFSPack:_aw_graph->nextBFSStep(&_finished)];
    } else if (_algoType == GraphAlgoKRU) {
        
    } else if (_algoType == GraphAlgoPRI) {
        
    } else if (_algoType == GraphAlgoDIJ) {
        
    } else {}
    
    if (_finished) {
        [self enableButtons:0];
    }
    
}

- (void)handleDFSPack:(DFSDataPack)p {
    NodeView *n = [_graphView verticeWithOrder:p.order];
    if (p.type == 0) {
        [_graphView visit_node:n from:[_graphView verticeWithOrder:p.lastTop]];
        [self updatePromptsWithIn:@[n.name] Out:0];
    } else if (p.type == 1) {
        [_graphView revisit_node:n];
        [self updatePromptsWithIn:0 Out:@[n.name]];
    }
  
    [Config postNotification:ELStackDidChangeNotification message:@{NotiInfoId: String(p.type), NotiInfoName: n.name}];
}

- (void)handleBFSPack:(BFSDataPack)p {
    NodeView *s = [_graphView verticeWithOrder:p.out_node];
    [_graphView revisit_node:s];
    NSMutableArray *inNames = [NSMutableArray new];

    for (int i = 0; i < p.in_count; i ++) {
        NodeView *n = [_graphView verticeWithOrder:p.in_nodes[i]];
        [_graphView visit_node:n from:s];
        [inNames addObject:n.name];
    }
    
    if (p.in_count > 0)
        delete [] p.in_nodes;
    
    [self updatePromptsWithIn:inNames Out:s ? @[s.name] : 0];
    [Config postNotification:ELStackDidChangeNotification message:@{NotiInfoId: inNames, NotiInfoName: s ? s.name : @""}];
    
}

- (void)updatePromptsWithIn:(NSArray *)i Out:(NSArray *)o {
    if (i == 0 && o == 0) {
        _promptLabel.text = @""; return;
    }
    
    NSMutableString *in_str = [NSMutableString new];
    NSMutableString *out_str = [NSMutableString new];

    for (NSString *o_s in o) {
        [out_str appendString:o_s];
        [out_str appendString:@", "];
    }
    int co = (int)o.count;
    if (co > 0)
        [out_str replaceCharactersInRange:NSMakeRange(out_str.length-2, 2) withString:@""];
    
    for (NSString *i_s in i) {
        [in_str appendString:i_s];
        [in_str appendString:@", "];
    }
    int ci = (int)i.count;
    if (ci > 0)
        [in_str replaceCharactersInRange:NSMakeRange(in_str.length-2, 2) withString:@""];

    if (_algoType == GraphAlgoDFS) {
        [in_str appendString:ci > 0 ? @" 入栈  " : @""];
        [out_str appendString:co > 0 ? @" 出栈； " : @""];
    } else if (_algoType == GraphAlgoBFS) {
        [in_str appendString:ci > 0 ? @" 入队列  " : @""];
        [out_str appendString:co > 0 ? @" 出队列； " : @""];
    }
    
    [out_str appendString:in_str];
    if (co > 0 && _finished)
        [out_str appendString:@"遍历完成"];
    int l = (int)out_str.length;
    unichar u = [@"；" characterAtIndex:0];
    if (l > 1 && [out_str characterAtIndex:l-2] == u)
        [out_str replaceCharactersInRange:NSMakeRange(l-2, 2) withString:@""];
    _promptLabel.text = out_str;
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
    [self startShowFrom:_start_pos];
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
    if (_aw_graph) {
        delete _aw_graph;
        _aw_graph = 0;
    }
}
@end

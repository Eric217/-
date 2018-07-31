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
#include <set>

@interface GraphViewController ()

@property (nonatomic, assign) GraphAlgo algoType;
@property (nonatomic, strong) GraphView *graphView;
@property (nonatomic, strong) UILabel *promptLabel;
@property (nonatomic, copy)   NSArray<NSString *> *titles; ///< title, sub
//Right 2
@property (nonatomic, strong) UIBarButtonItem *capture;
@property (nonatomic, strong) UIBarButtonItem *settings;
//Bottom 3
@property (nonatomic, strong) UIBarButtonItem *nextStepButton;
@property (nonatomic, strong) UIBarButtonItem *resultButton;
@property (nonatomic, strong) UIBarButtonItem *restartButton;

@property (nonatomic, assign) AdjacencyWGraph<int> *aw_graph;
@property (nonatomic, assign) int nodecount;

@property (nonatomic, assign) set<set<int> *> *kru_set; ///< for kruskal
@property (nonatomic, assign) int added_edge_count; ///< for kruskal

@property (nonatomic, assign) set<int> *prim_set; ///< for prim

@property (nonatomic, assign) int *dist; ///< for dijkstra
@property (nonatomic, assign) int *pre; ///< for dijkstra

@property (nonatomic, assign) int start_pos; ///< for those who need select start

@property (nonatomic, assign) bool finished; ///< signal for finish
@property (nonatomic, assign) bool showing_result; ///< for show_result, disable flash node views

@end

@implementation GraphViewController

- (id)initWithAlgoType:(GraphAlgo)t titles:(NSArray *)ts {
    self = [super init];
    _algoType = t;
    _titles = ts;
    _kru_set = 0;
    _prim_set = 0;
    _dist = _pre = 0;
    _start_pos = 0;
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
        make.left.width.bottom.equalTo(self.graphView);
        make.height.mas_equalTo(52);
    }];
    
    [self retriveGraph];
    if (_nodecount > 0) {
        [Config postNotification:ELGraphDidSelectPointNotification message:@{NotiInfoId: @"1", NotiInfoName: [_graphView nodeWithOrder:1].name}];
    }
    
    [Config addObserver:self selector:@selector(indicateStart:) notiName:ELGraphShouldStartShowNotification];
    
}

/// 通知传来开始消息，那么确定要开始吗(拦截)？
- (void)indicateStart:(NSNotification *)noti {
    int s = [noti.userInfo[NotiInfoId] intValue];
    if (!_start_pos) {
        // 开始 directly
    } else if (s == _start_pos) {
        // if !finished, 提示重新开始吗
        // else 开始
    } else {
        // if !finished, 提示是否演示新的
        // else 开始
    }
    // for now: start directly in all cases.
    [self startShowFrom:s];
}

/// 重新开始、通知要求开始 最后都从这里开始
/// @discussion init these values:
/// _graphView->reset;\n _promptLabel->clear;
/// enable all buttons; _aw_graph->restart; for properties specificated for certain algorithm, reset in their bodies; _start_pos updated if needed; _finished = 0; _showing_result = 0;
- (void)startShowFrom:(int)pos {
    _start_pos = pos;
    _finished = 0;
    _showing_result = 0;
    [self enableButtons:1];
    _restartButton.enabled = 1;
    [self updatePromptsWithIn:0 Out:0];
    [_graphView resetColor];
    [Config postNotification:ELGraphDidRestartShowNotification message:0];
    
    if (_algoType == GraphAlgoDFS) {
        [self handleDFSPack:_aw_graph->startDFSFrom(pos)];
    } else if (_algoType == GraphAlgoBFS) {
        [self handleBFSPack:_aw_graph->startBFSFrom(pos)];
    } else if (_algoType == GraphAlgoKRU) {
        _added_edge_count = 0;
        if (_kru_set) {
            for (set<set<int> *>::iterator it = _kru_set->begin();
                 it != _kru_set->end(); it++) {
                set<int> * s = *it; delete s; }
            _kru_set->clear();
        } else _kru_set = new set<set<int> *>();
        [self handleKRUPack:_aw_graph->startKruskal()];
    } else if (_algoType == GraphAlgoPRI) {
        if (_prim_set) _prim_set->clear();
        else _prim_set = new set<int>();
        [self handlePRIPack:_aw_graph->startPrimFrom(_start_pos)];
    } else if (_algoType == GraphAlgoDIJ) {
        if (!_dist) _dist = new int[_nodecount+1];
        if (!_pre)  _pre = new int[_nodecount+1];
        [self initPathTable];
        [self handleDIJPack:_aw_graph->startDijkstra(_start_pos, _dist, _pre)];
    } else {}
}
- (void)nextStep:(UIBarButtonItem *)sender {
    
    if (_algoType == GraphAlgoDFS) {
        [self handleDFSPack:_aw_graph->nextDFSStep(&_finished)];
    } else if (_algoType == GraphAlgoBFS) {
        [self handleBFSPack:_aw_graph->nextBFSStep(&_finished)];
    } else if (_algoType == GraphAlgoKRU) {
        [self handleKRUPack:_aw_graph->nextKruskal()];
    } else if (_algoType == GraphAlgoPRI) {
        [self handlePRIPack:_aw_graph->nextPrim()];
    } else if (_algoType == GraphAlgoDIJ) {
        [self handleDIJPack:_aw_graph->nextDijkstra(&_finished)];
    } else {}
    
    if (_finished) {
        if (_showing_result)
            [self updatePromptLabel:@"" withFinishComma:0];
        _showing_result = 0;
        [self enableButtons:0];
    }
}

- (void)initPathTable {
    NSMutableArray<NSMutableArray *> *dataArr = [NSMutableArray new];
    
    for (int i = 0; i < _nodecount; i++) {
        NodeView *node = _graphView.vertices[i];
        if (node._id == _start_pos)
            continue;
        NSMutableArray *temp = [NSMutableArray new];
        [temp addObject:String(node._id)];
        [temp addObject:[NSString stringWithFormat:@"到达 %@ 的最短距离  _", node.name]];
        [temp addObject:@" "];
        [dataArr addObject:temp];
    }
    [Config postNotification:ELGraphDidInitPathTableNotification message:@{@"0": dataArr}];
}
 
- (void)handleDIJPack:(DIJDataPack)p {

    if (p.new_node) {
        int i = p.new_node;
        NodeView *node = [_graphView nodeWithOrder:i];
        [_graphView visit_node:node from:0];
        [self updatePromptLabel:[NSString stringWithFormat:@"路径首次到达顶点 %@", node.name] withFinishComma:1];
        [self updatePathTableWithOrder:i name:node.name];
        
    } else if (p.no_update_node) {
        NodeView *node = [_graphView nodeWithOrder:p.no_update_node];
        [self updatePromptLabel:[NSString stringWithFormat:@"无需更新顶点 %@", node.name] withFinishComma:1];
        if (!_showing_result)
            [node flashWithDuration:0.2 color:node.layer.borderColor];
    } else if (p.poped_node) {
        NodeView *node = [_graphView nodeWithOrder:p.poped_node];
        [_graphView revisit_node:node];
        [self updatePromptLabel:[NSString stringWithFormat:@"切换至顶点 %@", node.name] withFinishComma:1];
        
    } else if (p.updated_node) {
        NodeView *node = [_graphView nodeWithOrder:p.updated_node];
        if (!_showing_result)
            [node flashWithDuration:0.2 color:node.layer.borderColor];
        [self updatePromptLabel:[NSString stringWithFormat:@"更新顶点 %@ 的路径", node.name] withFinishComma:1];
        [self updatePathTableWithOrder:p.updated_node name:node.name];
    } else {};
    
}

- (void)updatePathTableWithOrder:(int)o name:(NSString *)n {
    NSString *first_line = [NSString stringWithFormat:@"到达 %@ 最短距离: %d", n, _dist[o]];
    NSMutableString *str = [NSMutableString stringWithString:n];
    int i = o;
    while (_pre[i]) {
        NSString *s = [_graphView nodeWithOrder:_pre[i]].name;
        [str insertString:[NSString stringWithFormat:@"%@ -> ", s] atIndex:0];
        i = _pre[i];
    }
    [Config postNotification:ELStackDidChangeNotification message:@{@"0": String(o), @"1": first_line, @"2": str}];
 
}


- (void)handlePRIPack:(PRIDataPack<int>)p {
    int from = p.from_node, to = p.new_node;
    if (!from) {
        from = to; [_graphView revisit_node:[_graphView nodeWithOrder:to]];
    }
    GraphEdge *edge = [_graphView edgeWithStart:from end:to];
    bool b1 = _prim_set->find(to) != _prim_set->end();
    if (b1) { // 环
        [_graphView invalidate_edge:edge];
        [self updatePromptLabel:[NSString stringWithFormat:@"选中边:(%@, %@)会构成环，删除该边", edge.startNode.name, edge.endNode.name] withFinishComma:1];
    } else {
        [_graphView revisit_edge:edge];
        NSMutableString *mut = from == to ? [NSMutableString new] : [NSMutableString stringWithFormat:@"选中边:(%@, %@)", edge.startNode.name, edge.endNode.name];
        if (p.edge_count > 0) {
            if (from != to)
                [mut appendString:@";  "];
            [mut appendString:@"新增待选边: "];
        }
        for (int i = 0; i < p.edge_count; i++) {
            EdgeForHeap<int> *e = p.new_edges + i;
            GraphEdge *ee = [_graphView edgeWithStart:e->start end:e->end];
            [mut appendString:[NSString stringWithFormat:@"(%@, %@) ", ee.startNode.name, ee.endNode.name]];
            [_graphView visit_edge:ee];
        }
        
        _prim_set->insert(to);
      
        _finished = _prim_set->size() == _nodecount;
        [self updatePromptLabel:mut withFinishComma:1];
    }
    delete [] p.new_edges;
}

- (void)handleKRUPack:(EdgeForHeap<int> *)edge {
    int v1 = edge->start, v2 = edge->end;

    set<set<int> *>::iterator it = _kru_set->begin();
    bool finded = 0, exec = 0;
    for (; it != _kru_set->end(); it++) {
        set<int> * s = *it;
        if (!(s->find(v1) == s->end() && s->find(v2) == s->end())) {
            if (s->find(v1) != s->end() && s->find(v2) != s->end()) { //都找到了
                GraphEdge *ee = [_graphView edgeWithStart:v1 end:v2];
                [_graphView invalidate_edge:ee];
                [self updatePromptLabel:[NSString stringWithFormat:@"选中边:(%@, %@)会构成环，删除该边", ee.startNode.name, ee.endNode.name] withFinishComma:1];
            } else { //只有一处找到了
                s->insert(v1); s->insert(v2); exec = 1;
            }
            finded = 1; break;
        }
    }
    if (!finded) {
        set<int> * s = new set<int>(); s->insert(v1); s->insert(v2);
        _kru_set->insert(s); exec = 1;
    }
    if (exec) {
        _added_edge_count ++;
        [_graphView revisit_edge:[_graphView edgeWithStart:v1 end:v2]];
        if (_added_edge_count == _nodecount-1)
            _finished = 1;
        [self updatePromptLabel:[NSString stringWithFormat:@"加入权值为 %d 的边", edge->weight] withFinishComma:1];
    }
}

- (void)handleDFSPack:(DFSDataPack)p {
    NodeView *n = [_graphView nodeWithOrder:p.order];
    if (p.type == 0) {
        [_graphView visit_node:n from:[_graphView nodeWithOrder:p.lastTop]];
        [self updatePromptsWithIn:@[n.name] Out:0];
    } else if (p.type == 1) {
        [_graphView revisit_node:n];
        [self updatePromptsWithIn:0 Out:@[n.name]];
    }
  
    [Config postNotification:ELStackDidChangeNotification message:@{NotiInfoId: String(p.type), NotiInfoName: n.name}];
}

- (void)handleBFSPack:(BFSDataPack)p {
    NodeView *s = [_graphView nodeWithOrder:p.out_node];
    [_graphView revisit_node:s];
    NSMutableArray *inNames = [NSMutableArray new];

    for (int i = 0; i < p.in_count; i ++) {
        NodeView *n = [_graphView nodeWithOrder:p.in_nodes[i]];
        [_graphView visit_node:n from:s];
        [inNames addObject:n.name];
    }
    
    if (p.in_count > 0)
        delete [] p.in_nodes;
    
    [self updatePromptsWithIn:inNames Out:s ? @[s.name] : 0];
    [Config postNotification:ELStackDidChangeNotification message:@{NotiInfoId: inNames, NotiInfoName: s ? s.name : @""}];
    
}

- (void)updatePromptsWithIn:(NSArray *)i Out:(NSArray *)o {
    if (i == 0 && o == 0) { _promptLabel.text = @""; return; }
    NSMutableString *in_str = [NSMutableString new];
    NSMutableString *out_str = [NSMutableString new];
    for (NSString *o_s in o) {
        [out_str appendString:o_s]; [out_str appendString:@", "];
    }
    int co = (int)o.count; int ci = (int)i.count;
    if (co > 0) [out_str replaceCharactersInRange:NSMakeRange(out_str.length-2, 2) withString:@""];
    for (NSString *i_s in i) {
        [in_str appendString:i_s]; [in_str appendString:@", "];
    }
    if (ci > 0) [in_str replaceCharactersInRange:NSMakeRange(in_str.length-2, 2) withString:@""];
    if (_algoType == GraphAlgoDFS) {
        [in_str appendString:ci > 0 ? @" 入栈  " : @""];
        [out_str appendString:co > 0 ? @" 出栈； " : @""];
    } else if (_algoType == GraphAlgoBFS) {
        [in_str appendString:ci > 0 ? @" 入队列  " : @""];
        [out_str appendString:co > 0 ? @" 出队列； " : @""];
    }
    [out_str appendString:in_str];
    if (co > 0 && _finished) [out_str appendString:@"遍历完成"];
    int l = (int)out_str.length; unichar u = [@"；" characterAtIndex:0];
    if (l > 1 && [out_str characterAtIndex:l-2] == u)
        [out_str replaceCharactersInRange:NSMakeRange(l-2, 2) withString:@""];
    _promptLabel.text = out_str;
}

- (void)updatePromptLabel:(NSString *)str withFinishComma:(bool)b {
    if (_finished) {
        NSMutableString *s = [NSMutableString stringWithString:str];
        if (b) [s appendString:@"; "];
        [s appendString:_algoType == GraphAlgoDIJ ? @"所有最短路径已生成" : @"构成最小生成树"];
        _promptLabel.text = s;
    } else
        _promptLabel.text = str;
}


- (void)retriveGraph {
    NSString *name = [UserDefault objectForKey:kLatestGraph];
    NSString *sql = [NSString stringWithFormat:@"select nname, centerx x, centery y, gorder __id from graph_node where gid = (select gid from graph where gname = '%@')", name];
 
    NSArray *nodes = [SQLiteManager.shared querySQL:sql];
    
    _nodecount = (int)nodes.count;
    _aw_graph = new AdjacencyWGraph<int>(_nodecount);

    for (NSDictionary *node in nodes) {
        NodeView *nodeView = [[NodeView alloc] initWithId:[node[@"__id"] intValue] name:node[@"nname"] s_center:{[node[@"x"] doubleValue], [node[@"y"] doubleValue]}];
        [_graphView addSubview:nodeView];
        [_graphView.vertices addObject:nodeView];
    }
    
    [_graphView.vertices sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        NodeView *n = obj1; NodeView *m = obj2;
        return n._id < m._id ? NSOrderedAscending : NSOrderedDescending;
    }];
 
    sql = [NSString stringWithFormat:@"select n_s_o s, n_e_o e, weight w from graph_edge where gid = (select gid from graph where gname = '%@')", name];
    NSArray *edges = [SQLiteManager.shared querySQL:sql];
    for (NSDictionary *edge in edges) {
        int weight = [edge[@"w"] intValue];
        int start_id = [edge[@"s"] intValue];
        int end_id = [edge[@"e"] intValue];
        _aw_graph->addEdge(start_id, end_id, weight);
        GraphEdge *edgeView = [[GraphEdge alloc] initWithWeight:weight start:[_graphView nodeWithOrder:start_id] end:[_graphView nodeWithOrder:end_id]];
        if (_algoType != GraphAlgoBFS && _algoType != GraphAlgoDFS)
            edgeView.drawCenter = 1;
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
    _showing_result = 1;
    while (!_finished) {
        [self nextStep:0];
    }

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
    if (_aw_graph) { delete _aw_graph; _aw_graph = 0; }
    if (_kru_set) {
        for (set<set<int> *>::iterator it = _kru_set->begin(); it != _kru_set->end(); it++) {
            set<int> * s = *it; delete s; }
        delete _kru_set;
    }
    if (_prim_set) delete _prim_set;
    if (_dist) delete [] _dist;
    if (_pre) delete [] _pre;
}
@end

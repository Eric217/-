//
//  GraphSpanTreeController.m
//  DS_playgound
//
//  Created by Eric on 2018/7/28.
//  Copyright © 2018 SDU_iOS_LAB. All rights reserved.
//

#import "GraphSpanTreeController.h"

#import "UIButton+init.h"
#import "UIImage+operations.h"
#import "UIView+funcs.h"
#import "NSString+funcs.h"

#import <Masonry/Masonry.h>

@interface GraphSpanTreeController ()

@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *descLabel;
@property (nonatomic, strong) UIButton *startShow;
@property (nonatomic, strong) UIScrollView *subScroll;
@property (nonatomic, strong) UITableViewCell *selectStart;
@property (nonatomic, strong) UIViewController *anotherRootVC;

@property (nonatomic, strong) NSString *source;
@property (nonatomic, strong) NSArray *titles;

@property (nonatomic, assign) GraphAlgo algoType;
@property (nonatomic, assign) int start_pos;

@end

@implementation GraphSpanTreeController

- (id)initWithAlgoType:(GraphAlgo)t titles:(NSArray *)ts anotherRoot:(UIViewController *)r {
    self = [super init];
    _algoType = t;
    _anotherRootVC = r;
    _titles = ts;
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.algoType == GraphAlgoPRI)
        self.view.backgroundColor = TableBackColor;
    else
        self.view.backgroundColor = TableBackLightestColor;
    
    // navigation items
    self.navigationItem.title = _titles[1];
    UIButton * _backButton = [UIButton customBackBarButtonItemWithTitle:@"返回" target:self action:@selector(dismiss)];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:_backButton];
    bool oldDevice = SystemVersion < 9 || IPHONE4;
    self.navigationItem.leftBarButtonItem = oldDevice ? [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(dismiss)] : backItem;
  
    // algorithm name label
    _nameLabel = [UILabel new];
    NSString *algoName = [_titles[0] stringByAppendingString:@" 算法"];
    NSMutableParagraphStyle *paraStyle = [NSMutableParagraphStyle new];
    paraStyle.alignment = NSTextAlignmentCenter;
    NSDictionary *attr = @{NSFontAttributeName: [UIFont fontWithName:LetterFont size:29], NSParagraphStyleAttributeName: paraStyle};
    _nameLabel.attributedText = [[NSAttributedString alloc] initWithString:algoName attributes:attr];;
    [self.view addSubview:_nameLabel];
    
    // select start view
    if (_algoType == GraphAlgoPRI) {
        _selectStart = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:0];
        [self.view addSubview:_selectStart];
        _selectStart.textLabel.font = [UIFont systemFontOfSize:21];
        _selectStart.detailTextLabel.font = [UIFont systemFontOfSize:21];
        _selectStart.detailTextLabel.textColor = UIColor.darkGrayColor;
        _selectStart.textLabel.text = @"图中点击选择起点:";
        _selectStart.backgroundColor = AlmostWhiteColor;
    }
    
    // start show button
    _startShow = [UIButton buttonWithTitle:@"开始演示" fontSize:23 textColor:UIColor.blackColor target:self action:@selector(startDisplay:) image:[UIImage pushImage]];
    [_startShow setTitleEdgeInsets:UIEdgeInsetsMake(0, -20, 0, 0)];
    [_startShow setImageEdgeInsets:UIEdgeInsetsMake(0, 125, 0, 0)];
    [self.view addSubview:_startShow];
    
    // desc label and its scroll view
    _subScroll = [UIScrollView new];
    _subScroll.alwaysBounceVertical = 1;
    [self.view addSubview:_subScroll];
    _descLabel = [[UILabel alloc] init];
    _descLabel.numberOfLines = 0;
    [_subScroll addSubview:_descLabel];
 
    // constraints
    
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(36);
        make.top.equalTo(self.view).offset(64+[Config v_pad:40 plus:18 p:12 min:8]);
    }];
    
    if (_algoType == GraphAlgoPRI) {
        [_selectStart mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.nameLabel.mas_bottom).offset([Config v_pad:25 plus:13 p:12 min:8]);
            make.centerX.equalTo(self.view);
            make.width.mas_equalTo(250);
            make.height.mas_equalTo(37);
        }];
    }
    
    [_startShow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).inset([Config v_pad:41 plus:34 p:30 min:24]);
        make.height.mas_equalTo(44);
        make.centerX.equalTo(self.view);
    }];
    
    [_subScroll mas_makeConstraints:^(MASConstraintMaker *make) {
        if (self.algoType == GraphAlgoPRI) {
            make.top.equalTo(self.selectStart.mas_bottom).offset(25);
        } else {
            make.top.equalTo(self.nameLabel.mas_bottom).offset(30);
        }
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.startShow.mas_top).inset(30);
    }];
    //_subScroll.backgroundColor = AlmostWhiteColor;
    
    if (_algoType == GraphAlgoKRU) {
        _source = @"对于 N 个顶点的连通图：\n1. 设 T 为已选边的集合，E 为所有边的集合；\n2. 每次点击 下一步时执行：\n     (1) 从 E 中选择代价最小的边，并从 E 中删除；\n     (2) 如果该边加入 T 中不产生环路，则将其加入 T 中；\n     (3) 当T中有 N-1 条边时，算法结束（没有环、N 个顶点的连通图有 N-1 条边，即最小生成树）。";
    } else if (_algoType == GraphAlgoPRI) {
        _source = @"对于 N 个顶点的连通图：\n1. 选择任意一个顶点为起点；\n2. 设T为具有该单一顶点的树；\n3. 每次点击下一步时执行：\n     (1) 往 T 中加入一条代价最小的边，使 T 仍是一棵树（连通、无环）。\n     (2) 当 T 中有 N-1 条边时，算法结束（无环、N 个顶点的连通图有 N-1 条边，即最小生成树）。";
    }
    
    if (self.algoType == GraphAlgoPRI)
        [Config addObserver:self selector:@selector(didReceivePointInfo:) notiName:ELGraphDidSelectPointNotification];

}

- (void)didReceivePointInfo:(NSNotification *)noti {
    _start_pos = [noti.userInfo[@"id"] intValue];
    _selectStart.detailTextLabel.text = noti.userInfo[@"name"];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
   
    NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
    paragraphStyle.lineSpacing = 3;
    paragraphStyle.firstLineHeadIndent = 23.5;
    paragraphStyle.headIndent = 23.5;
    paragraphStyle.tailIndent = -16;
    paragraphStyle.paragraphSpacing = 8.5;
    
    NSMutableDictionary *_attributes = [NSMutableDictionary new];
    _attributes[NSParagraphStyleAttributeName] = paragraphStyle;
    _attributes[NSFontAttributeName] = [UIFont systemFontOfSize:20];
    _attributes[NSForegroundColorAttributeName] = UIColor.darkTextColor;
    
    
    CGSize s = [_source sizeWithAttr:_attributes maxSize:CGSizeMake(self.view.bounds.size.width, 3000) orFontS:0];
    
    _descLabel.frame = CGRectMake(0, 10, _subScroll.bounds.size.width, s.height);
    _subScroll.contentSize = _descLabel.frame.size;
  
    self.descLabel.attributedText = [[NSAttributedString alloc] initWithString:_source attributes:_attributes];
    
}


- (void)startDisplay:(id)sender {
    if (self.splitViewController.viewControllers.count == 1) {
        // 手机版另行适配
    }
    
    // TODO: - 提示框，是否重置
    
    [Config postNotification:ELGraphShouldStartShowNotification message:@{NotiInfoId: String(_start_pos)}];
    
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

@end

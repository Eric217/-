//
//  TravesingController.m
//  DS_playgound
//
//  Created by Eric on 2018/7/16.
//  Copyright © 2018 SDU_iOS_LAB. All rights reserved.
//

#import "TravesingController.h"
#import "TreeView.h"
#import "UILabel+init.h"
#import "UIView+funcs.h"
#import "UIImage+operations.h"
#import "BinaryTree.h"
#import "UIViewController+funcs.h"
#import <Masonry/Masonry.h>


@interface TravesingController ()
//BASIC COMPONENTS
@property (strong, nonatomic) UILabel *collectionEmptyView;
//Left 1
@property (strong, nonatomic) UIBarButtonItem *customButton;
//Right 1
@property (strong, nonatomic) UIBarButtonItem *captureButton;
@property (strong, nonatomic) UIBarButtonItem *settingButton;
//Bottom 3
@property (strong, nonatomic) UIBarButtonItem *nextStepButton;
@property (strong, nonatomic) UIBarButtonItem *resultButton;
@property (strong, nonatomic) UIBarButtonItem *restartButton;
//travesing
@property (strong, nonatomic) TreeView *treeView;
//@property (strong, nonatomic) TravesalBottomView *bottomView;


@property (nonatomic, assign) bool *reach;
@property (nonatomic, assign) int realCount;
@property (nonatomic, assign) TravesalType travesalType;
@property (nonatomic, strong) BinaryTree *tree;
@property (nonatomic, strong) NSString *tra_name;

@property (nonatomic, copy) NSMutableArray *completeArray;
@property (nonatomic, copy) NSArray<NSString *> *dataArray;
@property (nonatomic, copy) NSArray<NSString *> *customTreeArray;

@end

@implementation TravesingController

#define DefaultTitle @"动态演示"

- (void)captureScreen:(UIBarButtonItem *)sender {
    if (_travesalType < 0)
        return;
    [self saveImage:[[self.treeView normalSnapshotImage] imageWithWaterMark:self.tra_name postion:WaterMarkPositionLU attributes:0 offset:CGSizeMake(40, 40)]];
 
}

- (void)customTree:(UIBarButtonItem *)sender {
    
}


- (void)updateRealCount {
    NSPredicate *p = [NSPredicate predicateWithFormat:@"self != %@", EmptyNode];
    _realCount = (int)[_dataArray filteredArrayUsingPredicate:p].count;
}

- (void)updateDataArray:(NSArray *)arr set:(BOOL)asDefault {
    _dataArray = arr;
    _completeArray = [NSMutableArray new];

    if (_reach)     free(_reach);
    _reach = (bool *)malloc(sizeof(bool) * _dataArray.count);

    _tree = [[BinaryTree alloc] initWithdataArray:_dataArray];
    [_treeView setupTree:_dataArray result:_completeArray reach:_reach];

    if (asDefault)
        [Config writeToPlistName:TravesalFile data:_dataArray];
    [self restart:0];
}

- (void)playTravesalType:(TravesalType)type title:(NSString *)t {
    if (_travesalType == type)
        return;
    if (_collectionEmptyView) {
        [_collectionEmptyView removeFromSuperview];
        self.navigationItem.leftBarButtonItems = @[_customButton];
        self.navigationItem.rightBarButtonItems = @[_captureButton];
        _treeView.backgroundColor = UIColor.whiteColor;
        _collectionEmptyView = 0;
    }
    self.title = [t stringByAppendingString:@"演示"];
    _tra_name = t;
    _travesalType = type;
    
    if (!_dataArray) {
        _dataArray = [Config getArrayFromFile:TravesalFile];
        if (!_dataArray) {
            NSString *e = EmptyNode;
            _dataArray = @[@"A", @"B", @"E", @"K", @"C", e, @"F", @"N", e, @"D", e, e, e,
                           @"G", @"H"];
            [Config writeToPlistName:TravesalFile data:_dataArray];
        }
    }
    
    if (!_reach)  [self initReach:0];
    
    if (!_tree)   _tree = [[BinaryTree alloc] initWithdataArray:_dataArray];
    
    if (!_completeArray) {
        _completeArray = [NSMutableArray new];
        [_treeView setupTree:_dataArray result:_completeArray reach:_reach];
    }
    [self restart:0];
}

- (void)restart:(UIBarButtonItem *)sender {
    if (_travesalType < 0 || _completeArray.count == 0)
        return;
 
    [self initReach:0];
    [_completeArray removeAllObjects];
    [_tree reset];
    [self enableButtons:1];

    [_treeView setNeedsDisplay];

}

- (void)initReach:(BOOL)reached {
    int c = (int)(_dataArray.count);
    if (!_reach)
        _reach = (bool *)malloc(sizeof(bool) * c);
    
    for (int i = 0; i < c; i++)
        _reach[i] = reached;
}

- (void)nextStep:(UIBarButtonItem *)sender {
    if (_travesalType < 0)
        return;
    
    bool _finish = 0;
    int p = [_tree nextStepWithTravesalType:_travesalType finished:&_finish];
    [_completeArray addObject:_dataArray[p]];
    _reach[p] = 1;
    if (_finish) {
        [self enableButtons:0];
        [self initReach:0];
    }
    [_treeView setNeedsDisplay];
}

- (void)enableButtons:(bool)b {
    _nextStepButton.enabled = b;
    _resultButton.enabled = b;
}

- (void)showResult:(UIBarButtonItem *)sender {
    if (_travesalType < 0)
        return;
    bool _finish = 0;
    while (!_finish) {
        int p = [_tree nextStepWithTravesalType:_travesalType finished:&_finish];
        [_completeArray addObject:_dataArray[p]];
    }
    [self initReach:0];
    [_treeView setNeedsDisplay];
    [self enableButtons:0];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    //appearrance
    [self.navigationController setToolbarHidden:0];
    self.view.backgroundColor = UIColor.whiteColor;
    self.title = DefaultTitle; _travesalType = -1;
    
    //buttons
    _customButton = [[UIBarButtonItem alloc] initWithTitle:@"自定义树" style:UIBarButtonItemStylePlain target:self action:@selector(customTree:)];
    _captureButton = [[UIBarButtonItem alloc] initWithTitle:@"保存图片" style:UIBarButtonItemStylePlain target:self action:@selector(captureScreen:)];
    [_captureButton setTintColor:UIColor.blackColor];
    _restartButton = [[UIBarButtonItem alloc] initWithTitle:@"重新开始" style:UIBarButtonItemStylePlain target:self action:@selector(restart:)];
    _resultButton = [[UIBarButtonItem alloc] initWithTitle:@"显示结果" style:UIBarButtonItemStylePlain target:self action:@selector(showResult:)];
    _nextStepButton = [[UIBarButtonItem alloc] initWithTitle:@"下一步" style:UIBarButtonItemStylePlain target:self action:@selector(nextStep:)];
    self.toolbarItems = @[[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:0 action:0], _restartButton, _resultButton, _nextStepButton];
    
    //empty view
    _collectionEmptyView = [UILabel labelWithEmptyPrompt:@"选择遍历\n方式" fontSize:28];
    [self.view addSubview:_collectionEmptyView];
    [_collectionEmptyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(300, 200));
    }];
    
    //tree view
    _treeView = [TreeView new];
    [self.view addSubview:_treeView];
    [_treeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(20);
        make.left.equalTo(self.view).offset(20);
        make.right.equalTo(self.view).inset(20);
        make.bottom.equalTo(self.view).inset(25);
    }];
}

- (void)dealloc {
    if (_reach) free(_reach);
}

@end

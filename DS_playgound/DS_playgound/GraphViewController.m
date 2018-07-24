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

#import <Masonry/Masonry.h>

@interface GraphViewController ()

@property (nonatomic, strong) GraphView *graph;
//Right 2
@property (nonatomic, strong) UIBarButtonItem *capture;
@property (nonatomic, strong) UIBarButtonItem *settings;
//Bottom 3
@property (nonatomic, strong) UIBarButtonItem *nextStepButton;
@property (nonatomic, strong) UIBarButtonItem *resultButton;
@property (nonatomic, strong) UIBarButtonItem *restartButton;

@property (nonatomic, assign) GraphAlgo algoType;
@property (nonatomic, copy) NSArray<NSString *> *titles; ///< title, sub


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
    self.navigationItem.title = _titles[0];
    
    // Toolbar Item
    _nextStepButton = BARBUTTON(@"下一步", @selector(nextStep:));
    _restartButton = BARBUTTON(@"重新开始", @selector(restart:));
    if (_algoType != GraphAlgoDFS && _algoType != GraphAlgoBFS) {
        _resultButton = BARBUTTON(@"显示结果", @selector(showResult:));
        self.toolbarItems = @[FlexibleSpace, _restartButton, _resultButton, _nextStepButton];
    } else
        self.toolbarItems = @[FlexibleSpace, _restartButton, _nextStepButton];
    
    // graph view
    
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
    [self saveImage:[[_graph normalSnapshotImage] imageWithWaterMark:_titles[0] postion:WaterMarkPositionLU attributes:0 offset:CGSizeMake(40, 40)]];
}

@end

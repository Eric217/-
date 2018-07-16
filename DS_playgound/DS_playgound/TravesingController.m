//
//  TravesingController.m
//  DS_playgound
//
//  Created by Eric on 2018/7/16.
//  Copyright © 2018 SDU_iOS_LAB. All rights reserved.
//

#import "TravesingController.h"

@interface TravesingController ()

//Left 1
@property (strong, nonatomic) UIBarButtonItem *customButton;
//Right 1
@property (strong, nonatomic) UIBarButtonItem *captureButton;
@property (strong, nonatomic) UIBarButtonItem *settingButton;
//Bottom 3
@property (strong, nonatomic) UIBarButtonItem *nextStepButton;
@property (strong, nonatomic) UIBarButtonItem *resultButton;
@property (strong, nonatomic) UIBarButtonItem *restartButton;

@end

@implementation TravesingController

#define DefaultTitle @"动态演示"

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationController setToolbarHidden:0];
    self.view.backgroundColor = UIColor.whiteColor;
    self.title = DefaultTitle;
    
    //buttons
    _customButton = [[UIBarButtonItem alloc] initWithTitle:@"自定义树" style:UIBarButtonItemStylePlain target:self action:@selector(customTree:)];
    self.navigationItem.leftBarButtonItems = @[_customButton];
    _captureButton = [[UIBarButtonItem alloc] initWithTitle:@"保存图片" style:UIBarButtonItemStylePlain target:self action:@selector(captureScreen:)];
    [_captureButton setTintColor:UIColor.blackColor];

    self.navigationItem.rightBarButtonItems = @[_captureButton];

    _restartButton = [[UIBarButtonItem alloc] initWithTitle:@"重新开始" style:UIBarButtonItemStylePlain target:self action:@selector(restart:)];
    

    _resultButton = [[UIBarButtonItem alloc] initWithTitle:@"显示结果" style:UIBarButtonItemStylePlain target:self action:@selector(showResult:)];

    _nextStepButton = [[UIBarButtonItem alloc] initWithTitle:@"下一步" style:UIBarButtonItemStylePlain target:self action:@selector(nextStep:)];

    self.toolbarItems = @[[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:0 action:0], _restartButton, _resultButton, _nextStepButton];
 
}

- (void)captureScreen:(UIBarButtonItem *)sender {
    
}

- (void)customTree:(UIBarButtonItem *)sender {
    
}

- (void)restart:(UIBarButtonItem *)sender {
    
}

- (void)nextStep:(UIBarButtonItem *)sender {

    
}

- (void)showResult:(UIBarButtonItem *)sender {
    
}


@end

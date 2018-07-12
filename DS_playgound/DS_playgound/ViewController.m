//
//  ViewController.m
//  DS_playgound
//
//  Created by Eric on 2018/7/12.
//  Copyright © 2018 SDU_iOS_LAB. All rights reserved.
//

#import "ViewController.h"
#import "SortMainController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    //测试
    UIButton *butt = [[UIButton alloc] initWithFrame:CGRectMake(300, 300, 140, 60)];
    [butt setTitle:@"测试：排序算法" forState:UIControlStateNormal];
    [butt setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
    [butt setBackgroundColor:UIColor.groupTableViewBackgroundColor];
    [butt addTarget:self action:@selector(didClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:butt];

}

- (void)didClick {
    [self presentViewController:[SortMainController new] animated:1 completion:nil];
    
}


@end

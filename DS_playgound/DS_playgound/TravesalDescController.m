//
//  TravesalDescController.m
//  DS_playgound
//
//  Created by Eric on 2018/7/17.
//  Copyright © 2018 SDU_iOS_LAB. All rights reserved.
//

#import "TravesalDescController.h"
#import "TravesingController.h"

#import "UIButton+init.h"
#import "UIImage+operations.h"
#import "UIViewController+funcs.h"
#import <Masonry/Masonry.h>


@class TravesingController; //相当于cpp里类的claim

@interface TravesalDescController ()

@property (nonatomic, strong) UIButton *startShow;
@property (nonatomic, assign) TravesalType travesal;


@end

@implementation TravesalDescController

- (instancetype)initWithTravesal:(TravesalType)trvs title:(NSString *)t {
    self = [super init];
    if (self) {
        _travesal = trvs;
        self.title = t;
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImage *img = [UIImage pushImage];

    //start show
    _startShow = [UIButton buttonWithTitle:@"开始演示" fontSize:23 textColor:UIColor.blackColor target:self action:@selector(startDisplay:) image:img];
    [_startShow setTitleEdgeInsets:UIEdgeInsetsMake(0, -20, 0, 0)];
    [_startShow setImageEdgeInsets:UIEdgeInsetsMake(0, 125, 0, 0)];
    [self.view addSubview:_startShow];
    
    
    [_startShow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).inset([Config v_pad:58 plus:34 p:30 min:24]);
        make.height.mas_equalTo(44);
        make.centerX.equalTo(self.view);
    }];
    
    
    
     
    self.view.backgroundColor = UIColor.groupTableViewBackgroundColor;
    

}

/// we dont create a new travesingVC and show detail if there already exists one.
- (void)startDisplay:(id)sender {
    NSArray *vcs = self.splitViewController.viewControllers;
    TravesingController *vc;
    if (vcs.count == 1) {
        vc = [TravesingController new];
        UINavigationController *detailNav = [[UINavigationController alloc] initWithRootViewController:vc];
        self.splitViewController.viewControllers = @[vcs[0], detailNav];
        [vc makeViewLoad];
    } else {
        UINavigationController * nav = self.splitViewController.viewControllers[1];
        vc = nav.viewControllers[0];
    }
    [vc playTravesalType:_travesal title:self.title];
}

@end

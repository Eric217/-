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
#import "NSString+funcs.h"
#import <Masonry/Masonry.h>


@class TravesingController; //相当于cpp里类的claim

@interface TravesalDescController ()

@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *descLabel;
@property (nonatomic, strong) UIButton *startShow;
@property (nonatomic, strong) UIScrollView *subScroll;


@property (nonatomic, strong) NSString *source;

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
    
    // name label
    _nameLabel = [UILabel new];
    _nameLabel.textAlignment = NSTextAlignmentCenter;
    _nameLabel.font = [UIFont systemFontOfSize:28];
    _nameLabel.text = [self.title stringByAppendingString:@"原理"];
    [self.view addSubview:_nameLabel];
    
    //start show
    _startShow = [UIButton buttonWithTitle:@"开始演示" fontSize:23 textColor:UIColor.blackColor target:self action:@selector(startDisplay:) image:img];
    [_startShow setTitleEdgeInsets:UIEdgeInsetsMake(0, -20, 0, 0)];
    [_startShow setImageEdgeInsets:UIEdgeInsetsMake(0, 125, 0, 0)];
    [self.view addSubview:_startShow];
    
    
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
    
    [_startShow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).inset([Config v_pad:58 plus:34 p:30 min:24]);
        make.height.mas_equalTo(44);
        make.centerX.equalTo(self.view);
    }];
    
    [_subScroll mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameLabel.mas_bottom).offset(30);
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.startShow.mas_top).inset(30);
    }];
    
    _subScroll.backgroundColor = AlmostWhiteColor;
    self.view.backgroundColor = TableBackLightColor;
    
    if (_travesal == TravesalPre) {
        _source = @"        首先访问根结点, 然后遍历左子树，最后遍历右子树。\n        在遍历左、右子树时，仍然先访问根结点，然后遍历左子树，最后遍历右子树。\n        递归过程为：\n        若二叉树为空则结束返回，否则：\n        (1) 访问根结点;\n        (2) 前序遍历左子树;\n        (3) 前序遍历右子树。";
    } else if (_travesal == TravesalIn) {
        _source = @"        首先遍历左子树, 然后访问根结点，最后遍历右子树。\n        在遍历左、右子树时，仍然先遍历左子树, 然后访问根结点，最后遍历右子树。\n        递归过程为：\n        若二叉树为空则结束返回，否则：\n        (1) 中序遍历左子树;\n        (2) 访问根结点;\n        (3) 中序遍历右子树。";
    } else if (_travesal == TravesalPost) {
        _source = @"        首先遍历左子树, 然后遍历右子树，最后访问根结点。\n        在遍历左、右子树时，仍然先遍历左子树, 然后遍历右子树，最后访问根结点。\n        递归过程为：\n        若二叉树为空则结束返回，否则：\n        (1) 后序遍历左子树;\n        (2) 后序遍历右子树;\n        (3) 访问根结点。";
    } else if (_travesal == TravesalLevel) {
        _source = @"      初始化一个仅含根节点的队列，每次点击下一步时执行：\n      (1) 从队列中取出一个节点，访问该节点;\n      (2) 如果其左孩子非空，则将左孩子加入队列;\n      (3) 如果其右孩子非空，则将右孩子加入队列;\n      (4) 如果当前队列为空，则遍历完成。";
    }

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

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
    paragraphStyle.lineSpacing = 5;
    paragraphStyle.firstLineHeadIndent = 23;
    paragraphStyle.headIndent = 23;
    paragraphStyle.tailIndent = -16;
    paragraphStyle.paragraphSpacing = 9;
    
    NSMutableDictionary *_attributes = [NSMutableDictionary new];
    _attributes[NSParagraphStyleAttributeName] = paragraphStyle;
    _attributes[NSFontAttributeName] = [UIFont systemFontOfSize:20];
    _attributes[NSForegroundColorAttributeName] = UIColor.darkTextColor;
    
    
    CGSize s = [_source sizeWithAttr:_attributes maxSize:CGSizeMake(self.view.bounds.size.width, 3000) orFontS:0];
    
    _descLabel.frame = CGRectMake(0, 24, _subScroll.bounds.size.width, s.height);
    _subScroll.contentSize = _descLabel.frame.size;
    
    self.descLabel.attributedText = [[NSAttributedString alloc] initWithString:_source attributes:_attributes];
    
}



@end

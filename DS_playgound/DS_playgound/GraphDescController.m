//
//  GraphDescController.m
//  DS_playgound
//
//  Created by Eric on 2018/7/27.
//  Copyright © 2018 SDU_iOS_LAB. All rights reserved.
//

#import "GraphDescController.h"

#import "NSString+funcs.h"
#import <Masonry/Masonry.h>
#import "Definition.h"

@interface GraphDescController ()


@property (nonatomic, assign) GraphAlgo algoType;
@property (nonatomic, copy) NSArray *titles;

@property (nonatomic, strong) UILabel *descLabel;
@property (nonatomic, strong) NSString *source;
@property (nonatomic, strong) NSMutableDictionary *attributes;
@property (nonatomic, strong) UIScrollView *scroll;


@end

@implementation GraphDescController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = TableBackLightColor;
    
    // navigation items
    self.navigationItem.title = [_titles[0] stringByAppendingString:@" 原理"];
    
    
    _scroll = [[UIScrollView alloc] init];
    [self.view addSubview:_scroll];
    [_scroll mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(self.view);
    }];
    _scroll.alwaysBounceVertical = 1;
    _descLabel = [[UILabel alloc] init];
    [_scroll addSubview:_descLabel];
 
    
    
    NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
    paragraphStyle.lineSpacing = 5;
    paragraphStyle.firstLineHeadIndent = 21;
    paragraphStyle.headIndent = 21;
    paragraphStyle.tailIndent = -16;
    paragraphStyle.paragraphSpacing = 6.5;
    
    _attributes = [NSMutableDictionary dictionary];
    _attributes[NSParagraphStyleAttributeName] = paragraphStyle;
    _attributes[NSFontAttributeName] = [UIFont systemFontOfSize:19];
    _attributes[NSForegroundColorAttributeName] = UIColor.darkTextColor;
   
    _descLabel.numberOfLines = 0;
    
    if (_algoType == GraphAlgoDFS) {
        _source = @"深度优先遍历 ( DFS ):\n\n1. 选定起点，起点输出并入栈；\n2. 每次点击“下一步”时，执行：\n     (1) 取栈顶元素 A，不弹栈； \n     (2) 若存在一个与 A 相连但未输出的节点 B，则 B 输出并入栈；\n     (3) 若(2)中无新元素进栈，则 A 出栈。如果此时栈为空，则算法结束。";
    } else if ( _algoType == GraphAlgoBFS) {
        _source = @"广度优先遍历 ( BFS ):\n\n1. 选定起点，起点输出并入队列；\n2. 每次点击“下一步”时，执行：\n     (1) 取出队列头元素 A；\n     (2) 将所有与A相连但未输出过的节点依次输出并加入队列尾部；\n     (3) 若此时队列为空，则算法结束。";
    }
 
   
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    
    CGSize s = CGSizeMake(self.view.bounds.size.width, 3000);
    s = [_source sizeWithAttr:_attributes maxSize:s orFontS:0];
   
    //_descLabel.text = @"test";
    _descLabel.frame = CGRectMake(0, 40, _scroll.bounds.size.width, s.height);
    _scroll.contentSize = _descLabel.frame.size;
    self.descLabel.attributedText = [[NSAttributedString alloc] initWithString:_source attributes:_attributes];
 
}



- (id)initWithAlgoType:(GraphAlgo)t titles:(NSArray *)ts {
    self = [super init];
    _algoType = t;
    _titles = ts;
    return self;
}


@end

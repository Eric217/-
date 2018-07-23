//
//  SortDescriptionController.m
//  DS_playgound
//
//  Created by Eric on 2018/7/16.
//  Copyright © 2018 SDU_iOS_LAB. All rights reserved.
//

#import "SortDescriptionController.h"
#import <Masonry/Masonry.h>
#import "UIView+frameProperty.h"
#import "NSString+funcs.h"

@interface SortDescriptionController ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *descLabel;
@property (nonatomic, strong) UIScrollView *scroll;
@property (nonatomic, strong) UIImageView *imageV1;

@property (nonatomic, assign) SortType sortType;

@end

@implementation SortDescriptionController

- (instancetype)initWithTitle:(NSString *)title sortType:(SortType)st {
    self = [super init];
    if (self) {
        self.title = title;
        _sortType = st;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = UIColor.whiteColor;
    
    self.navigationItem.leftBarButtonItems = @[[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(dismissPresentedVC)]];

    _titleLabel = [UILabel new];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.font = [UIFont systemFontOfSize:25];
    _titleLabel.text = [self.title stringByAppendingString:@"算法的原理如下："];
    [self.view addSubview:_titleLabel];
    
    _descLabel = [UILabel new];
    _descLabel.numberOfLines = 0;
    _descLabel.font = [UIFont systemFontOfSize:20];
    [self.view addSubview:_descLabel];
    
    _scroll = [[UIScrollView alloc] init];
    [self.view addSubview:_scroll];
    _imageV1 = [[UIImageView alloc] initWithFrame:CGRectZero];
    [_imageV1 setContentMode:UIViewContentModeScaleAspectFit];
    [_scroll addSubview:_imageV1];
    _scroll.bounces = 0;

    UILabel *bottomLabel = [UILabel new];
    bottomLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:bottomLabel];

    NSString *source;
    NSString *complexImageName = @"n2";
    
    #define SetImg(name) _imageV1.image=[UIImage imageNamed:name]
    
    switch (_sortType) {
        case SortTypeBubble:
            source = @"1. 比较相邻的元素(降序为例)，若左边比右边小，就交换他们两个。\n2. 对每一对相邻元素做同样的工作，从开始第一对到结尾的最后一对。\n3. 每趟冒泡在右边产生一个最小值。\n4. 每趟对越来越少的元素重复上面的步骤，直到全部完成。";
            _preferredSize = CGSizeMake(730, 560);
            SetImg(@"bubble_source"); break;
        case SortTypeInsertion:
            source = @"1. 只有一个元素的数组一定是有序数组。\n2. 从包含数组中取出第一个元素，做单元素数组。\n3. 把第二个元素插入该数组正确位置，得到大小为2的有序数组。\n4. 同种方式循环n-1次，最后即得到一个大小为n的有序数组。";
            _preferredSize = CGSizeMake(730, 560);
            SetImg(@"insertion_source"); break;
        case SortTypeFast:
            source = @"1. 从 0: n-1 中选择一个元素作为middle，以该元素为支点。\n2. 余下元素分为两段，左侧元素都 ≤ 支点，，右侧 ≥ 支点\n3. 递归地对 left 和 right 分别进行排序。\n4. 最终结果即 left+middle+right。"; //\n2. 余下元素分割为两段：left 中元素支点，right 中元素支点。
            _preferredSize = CGSizeMake(730, 555);
            complexImageName = 0;
            SetImg(@"fast_source"); break;
        case SortTypeHeap:
            source = @"1. 将待排序序列构造成一个最大/小堆。\n2. 序列的最大/小值即堆顶节点，将其与末尾元素交换。\n3. 将剩余 n-1 个元素重新构造成一个堆。\n4. 相同方式执行 n-1 次，即得到有序序列。";
            _preferredSize = CGSizeMake(745, 555);
            complexImageName = 0;
            SetImg(@"heap_source"); break;
        case SortTypeSelection:
            source = @"1. 选择第一个位置为最大元素位置，剩下的 n-1 个元素与之比较。\n2. 遇到更大元素则交换，循环一轮后此位置上即是最大元素。\n3. 选择第二个位置开始新一轮循环，找出第二大的元素。\n4. n-1 个元素依次全部循环完毕后即得到有序数组。";
            _preferredSize = CGSizeMake(700, 490);
            SetImg(@"selection_source"); break;
    }
 

    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(55);
        make.height.mas_equalTo(48);
        make.width.equalTo(self.view);
        make.left.mas_equalTo(0);
    }];
    
    NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
    paragraphStyle.lineSpacing = 10;
    paragraphStyle.lineBreakMode = NSLineBreakByCharWrapping;
    NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
    attributes[NSParagraphStyleAttributeName] = paragraphStyle;
    attributes[NSFontAttributeName] = [UIFont systemFontOfSize:19];
 
    CGSize txtSize = [source sizeWithAttr:attributes maxSize:self.view.bounds.size orFontS:0]; txtSize.height += 5;
    
    [_descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(6);
        make.centerX.equalTo(self.view);
        make.size.mas_equalTo(txtSize);
    }];
    
    [bottomLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).inset(17);
        make.height.mas_equalTo(45);
        make.width.mas_equalTo(300);
        make.centerX.equalTo(self.view);//.offset(-18);
    }];
    
    [_scroll mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.descLabel.mas_bottom).offset(10.5);
        make.bottom.equalTo(bottomLabel.mas_top).inset(9.5);
        make.left.equalTo(self.view).offset(22);
        make.right.equalTo(self.view).inset(22);
    }];
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:@"平均时间复杂度为 " attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:22.5]}];
    
    if (complexImageName) {
        NSTextAttachment *attchment = [[NSTextAttachment alloc] init];
        attchment.bounds = CGRectMake(0, -8.5, 76, 35.5);//设置frame
        attchment.image = [UIImage imageNamed:complexImageName];//设置图片
        [attributedString appendAttributedString:[NSAttributedString attributedStringWithAttachment:attchment]];
    } else {
        NSAttributedString *ast = [[NSAttributedString alloc] initWithString:@"O(nlogn)" attributes:@{NSFontAttributeName: [UIFont fontWithName:LetterFont_I size:30]}];
        [attributedString appendAttributedString:ast];
    }
    
    bottomLabel.attributedText = attributedString;
    _descLabel.attributedText = [[NSAttributedString alloc] initWithString:source attributes:attributes];
    
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    //img size
    CGFloat imgScale = _imageV1.image.scale;
    CGSize imgSize = _imageV1.image.size;
    imgSize.width *= imgScale; imgSize.height *= imgScale;
   
    if (_scroll.width >= imgSize.width && _scroll.height >= imgSize.height)
        [_imageV1 setFrame:CGRectMake(0, 0, _scroll.width, _scroll.height)];
    else if (_scroll.width >= imgSize.width && _scroll.height < imgSize.height)
        [_imageV1 setFrame:CGRectMake(_scroll.width/2 - imgSize.width/2, 0, imgSize.width, imgSize.height)];
    else if (_scroll.width < imgSize.width && _scroll.height >= imgSize.height)
        [_imageV1 setFrame:CGRectMake(0, _scroll.height/2 - imgSize.height/2, imgSize.width, imgSize.height)];
    else
        [_imageV1 setFrame:CGRectMake(0, 0, imgSize.width, imgSize.height)];
    [_scroll setContentSize:_imageV1.frame.size];
    
}


- (void)dismissPresentedVC {
    [self dismissViewControllerAnimated:1 completion:nil];
}

@end

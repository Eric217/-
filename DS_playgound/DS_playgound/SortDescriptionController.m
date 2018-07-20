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

    UILabel *label2 = [UILabel new];
    label2.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:label2];

    NSString *source;
    NSString *complexImageName = @"n2";
    
    #define SetImg(name) _imageV1.image=[UIImage imageNamed:name]
    
    switch (_sortType) {
        case SortTypeBubble:
            source = @"1. 比较相邻的元素(降序为例)，若左边比右边小，就交换他们两个。\n2. 对每一对相邻元素做同样的工作，从开始第一对到结尾的最后一对。\n3. 每趟冒泡在右边产生一个最小值。\n4. 每趟对越来越少的元素重复上面的步骤，直到全部完成。";
            SetImg(@"bubble_source"); break;
        case SortTypeInsertion:
            source = @"";
            SetImg(@""); break;
        case SortTypeFast:
            source = @"";
            complexImageName = @"nlogn";
            SetImg(@"fast_source"); break;
        case SortTypeHeap:
            source = @"";
            complexImageName = @"nlogn";
            SetImg(@""); break;
        case SortTypeSelection:
            source = @"";
            SetImg(@""); break;
    }
 

    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(51);
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
 
    CGSize txtSize = [Config sizeForText:source attr:attributes maxSize:self.view.bounds.size orFontS:0]; txtSize.height += 5;
    
    [_descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(7.5);
        make.centerX.equalTo(self.view);
        make.size.mas_equalTo(txtSize);
    }];
    
    [label2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).inset(26);
        make.height.mas_equalTo(45);
        make.width.mas_equalTo(300);
        make.centerX.equalTo(self.view);//.offset(-18);
    }];
    
    [_scroll mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.descLabel.mas_bottom).offset(13);
        make.bottom.equalTo(label2.mas_top).offset(-12);
        make.left.equalTo(self.view).offset(22);
        make.right.equalTo(self.view).inset(22);
    }];
    
    NSTextAttachment *attchment = [[NSTextAttachment alloc] init];
    attchment.bounds = CGRectMake(0, -8.5, 76, 35.5);//设置frame
    attchment.image = [UIImage imageNamed:complexImageName];//设置图片
 
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:@"平均时间复杂度为 " attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:22.5]}];
    [attributedString appendAttributedString:[NSAttributedString attributedStringWithAttachment:attchment]];
    
    label2.attributedText = attributedString;
    _descLabel.attributedText = [[NSAttributedString alloc] initWithString:source attributes:attributes];
    
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    //img size
    CGFloat imgScale = _imageV1.image.scale;
    CGSize imgSize = _imageV1.image.size;
    imgSize.width *= imgScale; imgSize.height *= imgScale;
    if (_scroll.width > imgSize.width && _scroll.height > imgSize.height)
        [_imageV1 setFrame:CGRectMake(0, 0, _scroll.width, _scroll.height)];
    else
        [_imageV1 setFrame:CGRectMake(0, 0, imgSize.width, imgSize.height)];
    [_scroll setContentSize:_imageV1.frame.size];
    
}


- (void)dismissPresentedVC {
    [self dismissViewControllerAnimated:1 completion:nil];
}

@end

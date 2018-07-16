//
//  SortDescriptionController.m
//  DS_playgound
//
//  Created by Eric on 2018/7/16.
//  Copyright © 2018 SDU_iOS_LAB. All rights reserved.
//

#import "SortDescriptionController.h"
#import <Masonry/Masonry.h>

@interface SortDescriptionController ()

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

    UILabel *titleLabel = [UILabel new];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont systemFontOfSize:25];
    [self.view addSubview:titleLabel];
    
    UILabel *descLabel = [UILabel new];
    descLabel.numberOfLines = 0;
    descLabel.font = [UIFont systemFontOfSize:20];
    [self.view addSubview:descLabel];
    
    UIImageView *imageV1 = [[UIImageView alloc] init];
    [self.view addSubview:imageV1]; //500:300
    
    UILabel *label2 = [UILabel new];
    label2.font = [UIFont systemFontOfSize:23];
    label2.textAlignment = NSTextAlignmentRight;
    [self.view addSubview:label2];
    label2.text = @"平均时间复杂度为";
    
    UIImageView *imageV2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"n2"]]; //88:40
    [self.view addSubview:imageV2];
    
    NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
    paragraphStyle.lineSpacing = 10;
    NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
    attributes[NSParagraphStyleAttributeName] = paragraphStyle;
    attributes[NSFontAttributeName] = [UIFont systemFontOfSize:19];

    CGSize imageSize = CGSizeZero;
    NSString *source = @"";
    switch (_sortType) {
        case SortTypeBubble:
            titleLabel.text = @"冒泡排序算法的原理如下：";
            source = @"1. 比较相邻的元素(降序为例)，若左边比右边小，就交换他们两个。\n2. 对每一对相邻元素做同样的工作，从开始第一对到结尾的最后一对。\n3. 每趟冒泡在右边产生一个最小值。\n4. 每趟对越来越少的元素重复上面的步骤，直到全部完成。";
            [imageV1 setImage:[UIImage imageNamed:@"bubble"]];
            imageSize = CGSizeMake(500, 310);
            break;
        case SortTypeInsertion:
            break;
        default:
            break;
    }
    
    descLabel.attributedText = [[NSAttributedString alloc] initWithString:source attributes:attributes];
  
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(51);
        make.height.mas_equalTo(48);
        make.width.equalTo(self.view);
        make.left.mas_equalTo(0);
    }];
    
    CGSize txtSize = [Config sizeForText:source attr:attributes maxSize:CGSizeMake(800, 150) orFontS:0];
    txtSize.height += 5;
    [descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLabel.mas_bottom).offset(7.5);
        make.centerX.equalTo(self.view);
        make.size.mas_equalTo(txtSize);
    }];
    
    [imageV1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(descLabel.mas_bottom).offset(31);
        make.centerX.equalTo(self.view);
        make.size.mas_equalTo(imageSize);
    }];
    
    [label2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).inset(76);
        make.height.mas_equalTo(46);
        make.width.mas_equalTo(190);
        make.centerX.equalTo(self.view).offset(-18);
    }];
    
    [imageV2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(label2.mas_right).offset(4);
        make.centerY.equalTo(label2);
        make.size.mas_equalTo(CGSizeMake(76, 34));
    }];
    
    
}



- (void)dismissPresentedVC {
    [self dismissViewControllerAnimated:1 completion:nil];
}

@end

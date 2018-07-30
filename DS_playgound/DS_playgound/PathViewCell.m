//
//  PathViewCell.m
//  DS_playgound
//
//  Created by Eric on 2018/7/30.
//  Copyright © 2018 SDU_iOS_LAB. All rights reserved.
//

#import "PathViewCell.h"

#import "UILabel+init.h"
#import <Masonry/Masonry.h>
#import "Definition.h"

@interface PathViewCell ()

@property (strong, nonatomic) UILabel *distLabel;
@property (strong, nonatomic) UILabel *pathLabel;
 
@end

@implementation PathViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    _distLabel = [UILabel new];
    _pathLabel = [UILabel new];
    _distLabel.numberOfLines = 0;
    _pathLabel.numberOfLines = 0;
    _distLabel.font = [UIFont fontWithName:LetterFont size:16.5];
    _pathLabel.font = [UIFont systemFontOfSize:17.5];
    
    [self.contentView addSubview:_distLabel];
    [self.contentView addSubview:_pathLabel];
    
    [_distLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(7.5);
        make.left.equalTo(self.contentView).offset(13);
        make.right.equalTo(self.contentView).inset(2);
    }];
    
    [_pathLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.distLabel);
        make.bottom.equalTo(self.contentView).inset(2.5);
        make.top.equalTo(self.distLabel.mas_bottom).offset(3.5);
    }];
    
    // TODO: - 少一个约束
    // 可是该怎么加呢？会打印 <NSLayoutConstraint:0x600002892030 UITableViewCell:0x7f8f558a4c00.width == 320> 提示。 试了给 _distLabel 加 greaterOrEqual，没用。可和 width 有关的真没道理啊
    
    return self;
}

- (void)fillLabelWithTitle:(NSString *)t body:(NSString *)b {
    _distLabel.text = t;
    _pathLabel.text = b;
}

@end

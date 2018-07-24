//
//  TextFieldCell.m
//  SortReveal
//
//  Created by Eric on 2018/4/23.
//  Copyright © 2018 Eric. All rights reserved.
//

#import "TextFieldCell.h"
#import <Masonry/Masonry.h>


@interface TextFieldCell ()

@end


@implementation TextFieldCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        UIView *accessory = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 134, 50)];
        
        _textField = [UITextField new];
        UILabel *l = [[UILabel alloc] init];
        [l setText:@"秒"];
        [l setTextColor:[UIColor.grayColor colorWithAlphaComponent:0.8]];
        [accessory addSubview:l];
        [accessory addSubview:_textField];
        
        [l mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.centerY.equalTo(accessory);
            make.size.mas_equalTo(CGSizeMake(24, 50));
        }];
        [_textField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(l.mas_left).inset(10);
            make.centerY.height.equalTo(l);
            make.width.mas_equalTo(100);
        }];
        [_textField setTextColor:UIColor.darkGrayColor];
        _textField.returnKeyType = UIReturnKeyDone;
        [_textField setTextAlignment:NSTextAlignmentRight];
        [_textField setKeyboardType:UIKeyboardTypeDecimalPad];
        self.accessoryView = accessory;
    }
    return self;
    
}

@end

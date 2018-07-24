//
//  SubtitleCollectionCell.m
//  DS_playgound
//
//  Created by Eric on 2018/7/23.
//  Copyright © 2018 SDU_iOS_LAB. All rights reserved.
//

#import "SubtitleCollectionCell.h"
#import "Definition.h"

@interface SubtitleCollectionCell ()

@property (nonatomic, strong) UILabel *titleLabel;

@end


@implementation SubtitleCollectionCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    _titleLabel = [[UILabel alloc] init];
    [self.contentView addSubview:_titleLabel];

    _titleLabel.layer.cornerRadius = 3;
    _titleLabel.clipsToBounds = 1;
    _titleLabel.layer.borderColor = [UIColor.lightGrayColor colorWithAlphaComponent:0.7].CGColor;
    _titleLabel.layer.borderWidth = 1.5;
    
    _titleLabel.numberOfLines = 0;
    self.layer.cornerRadius = 3;
    self.layer.masksToBounds = 1;
    
    return self;
}


- (void)setTitle:(NSString *)title subtitle:(NSString *)sub {
    [_titleLabel setFrame:self.bounds];
    
    NSString *total = [[title stringByAppendingString:@"\n"] stringByAppendingString:sub];
 
    NSMutableAttributedString *attr_total = [[NSMutableAttributedString alloc] initWithString:total];
    [attr_total addAttribute:NSFontAttributeName value:[UIFont fontWithName:LetterFont_B size:29] range:NSMakeRange(0, title.length)];
    [attr_total addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:21 weight:UIFontWeightRegular] range:NSMakeRange(title.length, sub.length+1)];
    
    NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
    paragraphStyle.paragraphSpacing = 30;
    paragraphStyle.alignment = NSTextAlignmentCenter;
    [attr_total addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, total.length)];
 
    _titleLabel.attributedText = attr_total;
 
}

@end

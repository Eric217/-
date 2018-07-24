//
//  StackViewCell.m
//  DS_playgound
//
//  Created by Eric on 2018/7/24.
//  Copyright © 2018 SDU_iOS_LAB. All rights reserved.
//

#import "StackViewCell.h"

@interface StackViewCell ()

@end

@implementation StackViewCell

- (id)initWithReuseId:(NSString *)r {
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:r];
    
    self.textLabel.textAlignment = NSTextAlignmentCenter;
 
    return self;
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    CGFloat dx = self.bounds.size.width/5.2, dy = self.bounds.size.height/10;
    CGRect inner = CGRectInset(self.bounds, dx, dy);
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(ctx, UIColor.blackColor.CGColor);
    CGContextSetLineWidth(ctx, 2);
    CGContextStrokeRect(ctx, inner);
}


@end

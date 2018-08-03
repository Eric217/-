//
//  NodeView.m
//  DS_playgound
//
//  Created by Eric on 2018/7/25.
//  Copyright © 2018 SDU_iOS_LAB. All rights reserved.
//

#import "NodeView.h"
#import "Common.h"
#import "UIView+funcs.h"

static CGColorRef node_highlight_color = 0;

@interface NodeView ()

@end

@implementation NodeView

/// load = 1
- (id)initWithId:(int)i name:(NSString *)n s_center:(CGPoint)sc {
    self = [super init];
    __id = i;
    _load = 1;
    [self setColor:UIColor.blackColor];
    _name = n; 
    _s_center = sc;
    
    self.layer.backgroundColor = UIColor.whiteColor.CGColor;
    
    [self roundStyleWithColor:0 width:LineWidth radius:[UserDefault doubleForKey:kGraphRadius]];
 
    self.text = _name;
    self.font = [UIFont fontWithName:LetterFont_B size:27];
    self.textAlignment = NSTextAlignmentCenter;
    self.userInteractionEnabled = 1;
    
    return self;
}

- (void)flashWithDuration:(NSTimeInterval)t color:(CGColorRef)c {
    CGColorRef backup = self.layer.backgroundColor;
    [UIView animateWithDuration:t animations:^{
        self.layer.backgroundColor = c;
        self.layer.backgroundColor = backup;
    }];
    
}

- (void)setColor:(UIColor *)color {
    self.textColor = color;
    self.layer.borderColor = color.CGColor;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self touchBegan];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self touchEnd];
    if (CGRectContainsPoint(self.bounds, [[touches anyObject] locationInView:self])) { // did click
        
        [Config postNotification:ELGraphDidSelectPointNotification message:@{@"id": String(__id), @"name": _name}];
    }
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self touchEnd];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    CGPoint pt = [[touches anyObject] locationInView:self];
   
    if (pt.x - self.frame.size.width > 5 || pt.x < -5 || pt.y - self.frame.size.height > 5 || pt.y < -5) {
        [self touchEnd];
    } else {
        [self touchBegan];
    }
}

- (void)touchBegan {
    if (!node_highlight_color) {
        CGFloat c[4] = {0.597, 1, 1, 1};
        node_highlight_color = CGColorCreate(CGColorSpaceCreateDeviceRGB(), c);
    }
    self.layer.backgroundColor = node_highlight_color;
}

- (void)touchEnd {
    self.layer.backgroundColor = UIColor.whiteColor.CGColor;
}

@end

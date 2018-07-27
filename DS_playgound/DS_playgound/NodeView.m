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

@interface NodeView ()

@end

@implementation NodeView

/// load = 1, color = black, edges = @[]
- (id)initWithId:(int)i name:(NSString *)n s_center:(CGPoint)sc {
    self = [super init];
    __id = i;
    _load = 1;
//    _visited = 0;
//    _color = UIColor.blackColor;
    [self setColor:UIColor.blackColor];
    _name = n;
//    _edges = [NSMutableArray new];
    _s_center = sc;
    
    self.layer.backgroundColor = UIColor.whiteColor.CGColor;
    
    [self roundStyleWithColor:0 width:LineWidth radius:[UserDefault doubleForKey:kGraphRadius]];
 
    self.text = _name;
    self.font = [UIFont fontWithName:LetterFont size:26];
    self.textAlignment = NSTextAlignmentCenter;
    self.userInteractionEnabled = 1;
    
    return self;
}

- (void)setColor:(UIColor *)color {
//    _color = color;
    self.textColor = color;
    self.layer.borderColor = color.CGColor;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    CGFloat c[4] = {0.88, 0.88, 0.88, 1};
    self.layer.backgroundColor = CGColorCreate(CGColorSpaceCreateDeviceRGB(), c);
}

- (void)touchEnd {
    self.layer.backgroundColor = UIColor.whiteColor.CGColor;
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





@end

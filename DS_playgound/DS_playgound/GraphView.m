//
//  GraphView.m
//  DS_playgound
//
//  Created by Eric on 2018/7/24.
//  Copyright © 2018 SDU_iOS_LAB. All rights reserved.
//

#import "GraphView.h"
#import "UIView+frameProperty.h"
#import "Common.h"

@interface GraphView ()  

@end

@implementation GraphView

- (id)init {
    self = [super init];
    _edges = [NSMutableArray new];
    _vertices = [NSMutableArray new];
    _g_tint = UIColor.redColor;
    _fresh_tint = UIColor.blueColor;
    _dead_tint = AlphaColor(UIColor.lightGrayColor, 0.56);
    self.backgroundColor = UIColor.whiteColor;
    return self;
}

- (void)resetColor {
    for (NodeView *node in _vertices)
        [node setColor:UIColor.blackColor];
    for (GraphEdge *edge in _edges) {
        edge.color = UIColor.blackColor;
    }
    [self setNeedsDisplay];
}

- (void)invalidate_edge:(GraphEdge *)e {
    if (!e) return;
    e.color = _dead_tint;
    [self setNeedsDisplay];
}

- (void)visit_edge:(GraphEdge *)e {
    if (!e) return;
    e.color = _fresh_tint;
    [self setNeedsDisplay];
}

/// 变红
- (void)revisit_edge:(GraphEdge *)e {
    if (!e) return;
    e.color = _g_tint;
    [e.startNode setColor:_g_tint];
    [e.endNode setColor:_g_tint];
    [self setNeedsDisplay];
}

- (void)revisit_node:(NodeView *)n {
    if (n)
        [n setColor:_g_tint];
}
 
- (void)visit_node:(NodeView *)n from:(NodeView *)f {
    [n setColor:_fresh_tint];
    if (!f) return;
    [self edgeWithStart:f._id end:n._id].color = _g_tint;
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {

    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGFloat radius = [UserDefault doubleForKey:kGraphRadius];
    CGFloat smallRadius = 0;
    
    NSMutableDictionary *attr;
    if (_edges && _edges.count != 0 && _edges[0].drawCenter) {
        attr = [NSMutableDictionary new];
        NSMutableParagraphStyle *p = [NSMutableParagraphStyle new];
        p.alignment = NSTextAlignmentCenter;
        attr[NSParagraphStyleAttributeName] = p;
        attr[NSFontAttributeName] = [UIFont fontWithName:LetterFont_I size:18];
        smallRadius = radius * EdgeWeightSizeRate;
    }
    
    for (GraphEdge *edge in _edges) {
        
        CGPoint points[2] = {edge.startNode.center, edge.endNode.center};
     
        CGContextSetStrokeColorWithColor(ctx, edge.color.CGColor);
        CGContextSetLineWidth(ctx, LineWidth);
        CGContextStrokeLineSegments(ctx, points, 2);
        if (edge.drawCenter) {
            CGRect r = SquareRect(MidPoint(points), smallRadius);
            CGContextSetFillColorWithColor(ctx, UIColor.whiteColor.CGColor);
            CGContextFillEllipseInRect(ctx, r);
            attr[NSForegroundColorAttributeName] = edge.color;
            [String(edge.weight) drawInRect:CGRectInset(r, 0, r.size.height/7.7) withAttributes:attr];
        }
    }
    
}

- (GraphEdge *)edgeWithStart:(int)s end:(int)e {
    if (s == e)
        return 0;
    for (GraphEdge *edge in _edges) {
        if ((edge.startNode._id == s && edge.endNode._id == e) || (edge.startNode._id == e && edge.endNode._id == s)) {
            return edge;
        }
    }
    return 0;
}

- (NodeView *)nodeWithOrder:(int)o {
    for (NodeView *node in _vertices)
        if (node._id == o)
            return node;
    return 0;
}

@end

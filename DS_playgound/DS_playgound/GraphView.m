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
    self.backgroundColor = UIColor.whiteColor;
    return self;
}

- (void)reset {
    for (NodeView *node in _vertices)
        [node setColor:UIColor.blackColor];
    for (GraphEdge *edge in _edges) {
        edge.color = UIColor.blackColor;
    }
    [self setNeedsDisplay];
}

- (void)revisit_node:(NodeView *)n {
    if (n)
        [n setColor:_g_tint];
}

- (void)visit_node:(NodeView *)n from:(NodeView *)f {
    [n setColor:_fresh_tint];
    if (!f)
        return;
    
    for (GraphEdge *edge in _edges) {
        if ((edge.startNode == f && edge.endNode == n) || (edge.startNode == n && edge.endNode == f)) {
            edge.color = _g_tint;
        }
    }
  
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {

    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGFloat radius = [UserDefault doubleForKey:kGraphRadius];
    CGFloat smallRadius = 0;
    
    NSMutableDictionary *attr;
    if (_edges && _edges.count != 0 && _edges[0].drawCenter) {
        CGContextSetFillColorWithColor(ctx, UIColor.whiteColor.CGColor);
        attr = [NSMutableDictionary new];
        NSMutableParagraphStyle *p = [NSMutableParagraphStyle new];
        p.alignment = NSTextAlignmentCenter;
        attr[NSParagraphStyleAttributeName] = p;
        smallRadius = radius * EdgeWeightSizeRate;
    }
    
    for (GraphEdge *edge in _edges) {
        CGPoint points[2] = {edge.startNode.center, edge.endNode.center};
        CGContextSetStrokeColorWithColor(ctx, edge.color.CGColor);
        CGContextSetLineWidth(ctx, LineWidth);
        CGContextStrokeLineSegments(ctx, points, 2);
        if (edge.drawCenter) {
            CGRect r = SquareRect(MidPoint(points), smallRadius);
            CGContextFillEllipseInRect(ctx, r);
            attr[NSForegroundColorAttributeName] = edge.color;
            [String(edge.weight) drawInRect:r withAttributes:attr];
        }
    }
    
}

- (NodeView *)verticeWithOrder:(int)o {
    for (NodeView *node in _vertices)
        if (node._id == o)
            return node;
    return 0;
}

@end

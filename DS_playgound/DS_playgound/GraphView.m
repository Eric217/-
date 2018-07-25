//
//  GraphView.m
//  DS_playgound
//
//  Created by Eric on 2018/7/24.
//  Copyright © 2018 SDU_iOS_LAB. All rights reserved.
//

#import "GraphView.h"
#import "GraphEdge.h"
#import "NodeView.h"
#import "Common.h"

@interface GraphView () {
    NSMutableArray<GraphEdge *> *_edges;
    NSMutableArray<NodeView *> *_vertices;
}

@end

@implementation GraphView

- (id)init {
    self = [super init];
    _edges = [NSMutableArray new];
    _vertices = [NSMutableArray new];
    return self;
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


@end

//
//  GraphEdge.m
//  DS_playgound
//
//  Created by Eric on 2018/7/25.
//  Copyright © 2018 SDU_iOS_LAB. All rights reserved.
//

#import "GraphEdge.h"

@interface GraphEdge () 

@end

@implementation GraphEdge

- (id)initWithWeight:(int)w start:(NodeView *)s end:(NodeView *)e {
    self = [super init];
    _color = UIColor.blackColor;
    _drawCenter = 0;
    _weight = w;
    _startNode = s;
    _endNode = e;
    return self;
}



@end

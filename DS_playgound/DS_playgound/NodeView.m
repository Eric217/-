//
//  NodeView.m
//  DS_playgound
//
//  Created by Eric on 2018/7/25.
//  Copyright © 2018 SDU_iOS_LAB. All rights reserved.
//

#import "NodeView.h"


@interface NodeView ()

@end

@implementation NodeView

/// load = 1, color = black, edges = @[]
- (id)initWithId:(int)i name:(NSString *)n {
    self = [super init];
    __id = i;
    _load = 1;
    _color = UIColor.blackColor;
    _name = n;
    _edges = [NSMutableArray new];
    
    
    
    return self;
}


@end

//
//  GraphEdge.h
//  DS_playgound
//
//  Created by Eric on 2018/7/25.
//  Copyright © 2018 SDU_iOS_LAB. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NodeView.h"

NS_ASSUME_NONNULL_BEGIN

@interface GraphEdge : NSObject

@property (nonatomic, strong) NodeView *startNode;
@property (nonatomic, strong) NodeView *endNode;
@property (nonatomic, strong) UIColor *color;
@property (nonatomic, assign) bool drawCenter;
@property (nonatomic, assign) int weight;

- (id)initWithWeight:(int)w start:(NodeView *)s end:(NodeView *)e;


@end

NS_ASSUME_NONNULL_END

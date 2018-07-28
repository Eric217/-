//
//  GraphView.h
//  DS_playgound
//
//  Created by Eric on 2018/7/24.
//  Copyright © 2018 SDU_iOS_LAB. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GraphEdge.h"
#import "NodeView.h"

NS_ASSUME_NONNULL_BEGIN

@interface GraphView : UIView

@property (nonatomic, strong) NSMutableArray<GraphEdge *> *edges;
@property (nonatomic, strong) NSMutableArray<NodeView *> *vertices;
@property (nonatomic, strong) UIColor *g_tint; ///< 正常选中颜色
@property (nonatomic, strong) UIColor *fresh_tint; ///< fresh 选中颜色
@property (nonatomic, strong) UIColor *dead_tint; ///< deleted edge color


- (void)visit_node:(NodeView *)n from:(NodeView *)f;
- (void)revisit_node:(NodeView *)n;
- (void)invalideEdge:(GraphEdge *)e;
- (void)highlightEdge:(GraphEdge *)e;

- (NodeView *)verticeWithOrder:(int)o;
- (GraphEdge *)edgeWithStart:(int)s end:(int)e;

- (void)resetColor;

@end

NS_ASSUME_NONNULL_END

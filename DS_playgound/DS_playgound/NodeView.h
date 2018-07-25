//
//  NodeView.h
//  DS_playgound
//
//  Created by Eric on 2018/7/25.
//  Copyright © 2018 SDU_iOS_LAB. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class GraphEdge;

@interface NodeView : UIView

@property (nonatomic, assign) int _id;
@property (nonatomic, assign) bool load;
@property (nonatomic, strong) UIColor *color;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSMutableArray<GraphEdge *> *edges;


- (id)initWithId:(int)i name:(NSString *)n;


@end

NS_ASSUME_NONNULL_END

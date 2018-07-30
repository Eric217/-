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

@interface NodeView : UILabel

@property (nonatomic, assign) int _id;
@property (nonatomic, assign) bool load;

@property (nonatomic, assign) CGPoint s_center; ///<在superview中的位置，0-1
@property (nonatomic, strong) NSString *name;


- (void)flashWithDuration:(NSTimeInterval)t color:(CGColorRef)c;

- (id)initWithId:(int)i name:(NSString *)n s_center:(CGPoint)sc;

- (void)setColor:(UIColor *)color;


@end

NS_ASSUME_NONNULL_END

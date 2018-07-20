//
//  TreeView.m
//  DS_playgound
//
//  Created by Eric on 2018/7/18.
//  Copyright © 2018 SDU_iOS_LAB. All rights reserved.
//

#import "TreeView.h"
#import "Common.h"
#import "UIView+easyDraw.h"

@interface TreeView ()

@property (nonatomic, assign) bool *reachedNodes;
@property (nonatomic, copy) NSArray<NSString *> *treeArray;
@property (nonatomic, copy) NSArray<NSString *> *resultArray;

//calculated attributes
@property (nonatomic, assign) int unit_num;
@property (nonatomic, assign) int height;
//view related
@property (nonatomic, assign) CGFloat bottomH;

@end

@implementation TreeView

- (void)setupTree:(NSArray *)tree result:(NSArray *)result reach:(bool *)nodes {
    _treeArray    = tree;
    _reachedNodes = nodes;
    _resultArray  = result;
    
    _height = [Config getTreeHeight:_treeArray.count];
    _bottomH = _height == 4 ? 250 : 400;
    NSPredicate *p = [NSPredicate predicateWithFormat:@"self != %@", EmptyNode];
    _unit_num = (int)[_treeArray filteredArrayUsingPredicate:p].count;
}

- (void)convertOrdinate:(CGPoint *)points length:(int)size {
    if (!points)
        return;
    CGFloat w = LineWidth + UnitSize + SepaWidth*(pow(2, _height-1)-1);
    CGFloat wOffset = self.bounds.size.width/2 - w/2;
    for (int i = 0; i < size; i++) {
        points[i].y = self.bounds.size.height - points[i].y - _bottomH;
        points[i].x += wOffset;
    }
}

- (void)drawRect:(CGRect)rect {
    if (!_treeArray) return;
    
    [Config updateTreeUnitSize:UnitSizeDefault * 1.3 font:TreeFontDefault * 1.25 sepaMul:1.5];
    
    //SPECIFICATION
    int nodes = (int)_treeArray.count;
    CGPoint * points = [Config getLocaWithHeight:_height startAngle:M_PI/3 angleReducer:^(int level, CGFloat * angle) {
        *angle -=  (M_PI*7/30.0)/(self.height-0.52);
    }];
    [self convertOrdinate:points length:pow(2, _height)-1];
    
    //MARK: - bottom part
    //DRAW LINE
    CGFloat h = self.bounds.size.height;
    CGFloat w = self.bounds.size.width;

    CGFloat hStart = h-_bottomH/2 - 46, hReal = 58;
    
    CGFloat offset = w/2 - _unit_num * hReal/2;
    offset = offset < 0 ? 0 : offset;
    CGFloat unitLength = (w-offset*2)/_unit_num;
    
    NSMutableParagraphStyle *textStyle = [[NSMutableParagraphStyle defaultParagraphStyle] mutableCopy];
    textStyle.lineBreakMode = NSLineBreakByWordWrapping;
    textStyle.alignment = NSTextAlignmentCenter;//水平居中
    NSMutableDictionary *attr =  [@{NSFontAttributeName: [UIFont fontWithName:@"TimesNewRomanPS-BoldMT" size:TreeFont], NSParagraphStyleAttributeName: textStyle} mutableCopy];
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGMutablePathRef path = CGPathCreateMutable();
    //左
    CGFloat leftP = offset == 0 ? LineWidth/2 : offset;
    CGFloat rightP = offset == 0 ? LineWidth/2 : 0;
    CGPathMoveToPoint(path, 0, leftP, hStart);
    CGPathAddLineToPoint(path, 0, leftP, hStart + hReal);
    //下
    CGPathMoveToPoint(path, 0, offset-LineWidth/2, hStart + hReal);
    CGPathAddLineToPoint(path, 0, w-offset+LineWidth/2, hStart + hReal);
    //上
    CGPathMoveToPoint(path, 0, offset, LineWidth/2 + hStart);
    CGPathAddLineToPoint(path, 0, w-offset, LineWidth/2 + hStart);
    
    //框内字与右
    NSUInteger rac = _resultArray.count;
    
    for (int i = 0; i < _unit_num; i++) {
        CGRect r = CGRectMake(offset+i*unitLength, hStart-1, unitLength, hReal);
        CGPathMoveToPoint(path, 0, unitLength+r.origin.x - rightP, hStart);
        CGPathAddLineToPoint(path, 0, unitLength+r.origin.x - rightP, hStart + hReal);
        if (i < rac)
            [self.resultArray[i] drawInRect:CGRectInset(r, 8, 8) withAttributes:attr];
        
    }
    
    //MARK: - tree part
    for (int i = nodes-1; i > 0; i--) { //n个节点有n-1条线
        if ([_treeArray[i] isEqualToString:EmptyNode])
            continue;
        [self pathMoveToPoint:points+i path:path];
        [self pathAddLineToPoint:points+(i-1)/2 path:path];
    }
    CGContextSetLineWidth(ctx, LineWidth);
    CGContextSetStrokeColorWithColor(ctx, UIColor.blackColor.CGColor);
    CGContextAddPath(ctx, path);
    CGContextStrokePath(ctx);
    
    //FILL ARC, DRAW TEXT AND ARC
    for (int i = 0; i < nodes; i++) {
        if ([_treeArray[i] isEqualToString:EmptyNode])
            continue;
        CGContextSetFillColorWithColor(ctx, UIColor.whiteColor.CGColor);
        CGRect r = [self getRectWithCenter:points+i unitSize:UnitSize];
        CGContextFillEllipseInRect(ctx, r);

        attr[NSForegroundColorAttributeName] = _reachedNodes[i] ? UIColor.redColor : UIColor.blackColor;
   
        double inset = UnitSize*0.207/1.414;
        [_treeArray[i] drawInRect:CGRectInset(r, inset, inset) withAttributes:attr];
        CGContextStrokeEllipseInRect(ctx, r);
    }
    
    [Config defaultTreeConfig];
   
    if (points)
        free(points);
}


@end

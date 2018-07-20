//
//  ELTreeUnitCell.m
//  SortReveal
//
//  Created by Eric on 2018/4/17.
//  Copyright © 2018 Eric. All rights reserved.
//

#import "ELTreeUnitCell.h"
#import "UIView+easyDraw.h"

@interface ELTreeUnitCell ()

@property (assign) int height;

@property (nonatomic, copy) NSArray *sortedArray;
@property (nonatomic, copy) NSArray<NSString *> *treeArray;

@end


@implementation ELTreeUnitCell

- (void)setDataDict:(NSDictionary *)dataDict {
    super.dataDict = dataDict;
    
    _treeArray = [dataDict valueForKey:kDataArr];
    _sortedArray = [dataDict valueForKey:kTitleArr];
    _height = [Config getTreeHeight:_treeArray.count];
    
}

- (void)convertOrdinate:(CGPoint *)points length:(int)size {
    if (!points) {
        return;
    }
    
    CGFloat w = LineWidth + UnitSize + SepaWidth*(pow(2, _height-1)-1);
    CGFloat wOffset = self.bounds.size.width/2 - w/2;
    
    if (size >= 2 || _sortedArray.count) {
        for (int i = 0; i < size; i++) {
            points[i].y = self.bounds.size.height - points[i].y - UnderTreeH;
            points[i].x += wOffset;
        }
    } else {
        for (int i = 0; i < size; i++) {
            points[i].y = self.bounds.size.height - points[i].y;
            points[i].x += wOffset;
        }
    }
}

//树枝有多长由 SepaWidth Angle 共同决定
- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    bool temp = UnitSize == UnitSizeDefault;

    //SPECIFICATION
    int nodes = (int)_treeArray.count;
    CGPoint * points = [Config getLocaWithHeight:_height startAngle:M_PI/3 angleReducer:^(int level, CGFloat * angle) {
        *angle -=  (M_PI*7/30.0)/(self.height-0.65);
    }];
    [self convertOrdinate:points length:pow(2, _height)-1];
    
    //TEXT ATTRIBUTES
    NSMutableParagraphStyle *textStyle = [[NSMutableParagraphStyle defaultParagraphStyle] mutableCopy];
    textStyle.lineBreakMode = NSLineBreakByWordWrapping;
    textStyle.alignment = NSTextAlignmentCenter;//水平居中,但是竖直不居中...
    NSMutableDictionary *attr =  [@{NSFontAttributeName: [UIFont systemFontOfSize:TreeFont], NSParagraphStyleAttributeName: textStyle} mutableCopy];
    
    //DRAW LINE
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGMutablePathRef path = CGPathCreateMutable();
    for (int i = nodes-1; i > 0; i--) { //n个节点有n-1条线
        [self pathMoveToPoint:points+i path:path];
        [self pathAddLineToPoint:points+(i-1)/2 path:path];
    }
    CGContextSetLineWidth(ctx, LineWidth);
    CGContextSetStrokeColorWithColor(ctx, UIColor.blackColor.CGColor);
    
    //BOTTOM ARRAY
    int arrSize = (int)_sortedArray.count;
    if (arrSize > 0) {
        CGFloat h = self.bounds.size.height;
        CGFloat proportion = 0.6;
        CGFloat hh = proportion*UnderTreeH; //小方格高度
        CGFloat h0 = h - UnderTreeH + UnderTreeH*(1-proportion)/2;//->h0 + hh
        CGFloat w = self.bounds.size.width;
        CGFloat offset = w/2 - arrSize * hh/2;
        offset = offset < 2 ? 2 : offset;
        CGFloat unitLength = (w-offset*2)/arrSize; //小方格宽度
        //左
        CGPathMoveToPoint(path, 0, offset, h0);
        CGPathAddLineToPoint(path, 0, offset, h0+hh);
        //下
        CGPathMoveToPoint(path, 0, offset, h0+hh);
        CGPathAddLineToPoint(path, 0, w-offset, hh+h0);
        //上
        CGPathMoveToPoint(path, 0, offset, h0);
        CGPathAddLineToPoint(path, 0, w-offset, h0);
        //框内字与右
        for (int i = 0; i < arrSize; i++) {
            CGRect r = CGRectMake(offset+i*unitLength, h0+(temp ? 4.5 : -1.5), unitLength, hh);//4.5是文字偏移量
            CGPathMoveToPoint(path, 0, unitLength+r.origin.x, h0);
            CGPathAddLineToPoint(path, 0, unitLength+r.origin.x, h0+hh);
            [_sortedArray[i] drawInRect:r withAttributes:attr];
        }
        
    }
    CGContextAddPath(ctx, path);
    CGContextStrokePath(ctx);
    //FILL ARC
    CGContextSetFillColorWithColor(ctx, UIColor.whiteColor.CGColor);
    for (int i = 0; i < nodes; i++)
        CGContextFillEllipseInRect(ctx, [self getRectWithCenter:points+i unitSize:UnitSize]);
    //DRAW ARC
    for (int i = 0; i < nodes; i++) {
        CGRect r = [self getRectWithCenter:points+i unitSize:UnitSize];
        [_treeArray[i] drawInRect:CGRectInset(r, 0, temp ? 6 : 0) withAttributes:attr];
        CGContextStrokeEllipseInRect(ctx, r);
    }
    if (points)
        free(points);
}



@end

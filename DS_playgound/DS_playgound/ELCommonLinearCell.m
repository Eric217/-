//
//  ELCommonLinearCell.m
//  SortReveal
//
//  Created by Eric on 2018/4/26.
//  Copyright © 2018 Eric. All rights reserved.
//

#import "ELCommonLinearCell.h"

@implementation ELCommonLinearCell


- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];//bounds现在有值
 
    CGFloat h = self.bounds.size.height;
    CGFloat w = self.bounds.size.width;
    CGFloat hBlow = h*0.4, hTextAbove = h*0.75;
    int arrSize = (int)self.dataArr.count;
    CGFloat offset = w/2 - arrSize * hBlow/2;
    offset = offset < 0 ? 0 : offset;
    CGFloat unitLength = (w-offset*2)/arrSize;
 
    NSMutableParagraphStyle *textStyle = [[NSMutableParagraphStyle defaultParagraphStyle] mutableCopy];
    textStyle.lineBreakMode = NSLineBreakByWordWrapping;
    textStyle.alignment = NSTextAlignmentCenter;//水平居中
    
    NSMutableDictionary *attr =  [@{NSFontAttributeName: [UIFont systemFontOfSize:27], NSParagraphStyleAttributeName: textStyle} mutableCopy];
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    CGMutablePathRef path = CGPathCreateMutable();
    
    CGFloat leftP = offset == 0 ? LineWidth/2 : offset;
    CGFloat rightP = offset == 0 ? LineWidth/2 : 0;
    
    //左
    CGPathMoveToPoint(path, 0, leftP, 0);
    CGPathAddLineToPoint(path, 0, leftP, hBlow);
    //下
    CGPathMoveToPoint(path, 0, offset-LineWidth/2, hBlow);
    CGPathAddLineToPoint(path, 0, w-offset+LineWidth/2, hBlow);
    //上
    CGPathMoveToPoint(path, 0, offset, LineWidth/2);
    CGPathAddLineToPoint(path, 0, w-offset, LineWidth/2);
    
    //框内字与右
    for (int i = 0; i < arrSize; i++) {
        CGRect r = CGRectMake(offset+i*unitLength, 2.5, unitLength, hBlow);//2.5是文字偏移量
        CGPathMoveToPoint(path, 0, unitLength+r.origin.x - rightP, 0);
        CGPathAddLineToPoint(path, 0, unitLength+r.origin.x - rightP, hBlow);
        [self.dataArr[i] drawInRect:r withAttributes:attr];
    }
    
    //arrow与title
    UIImage *upArrow = [UIImage imageNamed:@"upArrow"];
    int titleCount = (int)(self.titlArr.count);
 
    attr[NSFontAttributeName] = [UIFont systemFontOfSize:16];
    CGFloat widthOverFlow = unitLength*0.074;
    CGRect r = CGRectMake(0, 0, unitLength+widthOverFlow, 0);
    
    for (int i = 0; i < titleCount; i++) {
        int p = ((NSString *)(self.posiArr[i])).intValue;
        r.origin.x = offset + p*(unitLength) - widthOverFlow/2;
        r.origin.y = hTextAbove;
        r.size.height = h-hTextAbove;
        CGFloat dx = 10;
        if (i == 2 && offset == 0 && r.origin.x > w-3-widthOverFlow/2) { //冒泡排序 满格 3是模糊的适配值
            r.size.width = 0.35*unitLength;
            r.origin.x -= r.size.width - 1 - widthOverFlow/2; //1是模糊的适配值
            dx = 0;
        }
        [self.titlArr[i] drawInRect:r withAttributes:attr];
        r.origin.y = hBlow;
        r.size.height = hTextAbove-hBlow;
        CGRect rr = CGRectInset(r, dx, 6);
        if (rr.size.width <= 4) {
            rr.size.width = 4;
            rr.origin.x -= 2;
        }
        [upArrow drawInRect:rr];
    
    }
    
    CGContextSetLineWidth(ctx, LineWidth);
    CGContextSetStrokeColorWithColor(ctx, UIColor.blackColor.CGColor);
    CGContextAddPath(ctx, path);
    CGContextStrokePath(ctx);
    
}


@end

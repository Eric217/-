//
//  ELRepeatLinearCell.m
//  SortReveal
//
//  Created by Eric on 2018/4/26.
//  Copyright © 2018 Eric. All rights reserved.
//

#import "ELRepeatLinearCell.h"

@implementation ELRepeatLinearCell

- (bool)repeatIdx:(int *)m idx:(int *)n {
    int len = (int)(self.posiArr.count);
    for (int i = 0; i < len; i++) {
        for (int j = i+1; j < len; j++) {
            if ([self.posiArr[i] isEqualToString:self.posiArr[j]]) {
                *m = i;
                *n = j;
                return 1;
            }
        }
    }
    return 0;
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    CGFloat h = self.bounds.size.height;
    CGFloat w = self.bounds.size.width;
    CGFloat hBlow = h*0.4, hTextAbove = h*0.75;
    int arrSize = (int)self.dataArr.count;
    CGFloat offset = w/2 - arrSize * hBlow/2;
    offset = offset < 0 ? 0 : offset;
    CGFloat unitLength = (w-offset*2)/arrSize;
    CGFloat lineWidth = 2;
    
    NSMutableParagraphStyle *textStyle = [[NSMutableParagraphStyle defaultParagraphStyle] mutableCopy];
    textStyle.lineBreakMode = NSLineBreakByWordWrapping;
    textStyle.alignment = NSTextAlignmentCenter;//水平居中
    
    NSMutableDictionary *attr =  [@{NSFontAttributeName: [UIFont systemFontOfSize:26], NSParagraphStyleAttributeName: textStyle, NSForegroundColorAttributeName: UIColor.blackColor} mutableCopy];
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    CGMutablePathRef path = CGPathCreateMutable();
    
    CGFloat leftP = offset == 0 ? lineWidth/2 : offset;
    CGFloat rightP = offset == 0 ? lineWidth/2 : 0;
    
    //左
    CGPathMoveToPoint(path, 0, leftP, 0);
    CGPathAddLineToPoint(path, 0, leftP, hBlow);
    //下
    CGPathMoveToPoint(path, 0, offset-lineWidth/2, hBlow);
    CGPathAddLineToPoint(path, 0, w-offset+lineWidth/2, hBlow);
    //上
    CGPathMoveToPoint(path, 0, offset, lineWidth/2);
    CGPathAddLineToPoint(path, 0, w-offset, lineWidth/2);
    
    int blueIdx = -1;
    if (self.coloArr && self.coloArr.firstObject)
        blueIdx = ((NSString *)self.coloArr.firstObject).intValue;
    
    //框内字与右
    for (int i = 0; i < arrSize; i++) {
        CGRect r = CGRectMake(offset+i*unitLength, 3, unitLength, hBlow);//3是文字偏移量
        CGPathMoveToPoint(path, 0, unitLength+r.origin.x - rightP, 0);
        CGPathAddLineToPoint(path, 0, unitLength+r.origin.x - rightP, hBlow);
        
        attr[NSForegroundColorAttributeName] = i == blueIdx ? systemBlue : UIColor.blackColor;
        [self.dataArr[i] drawInRect:r withAttributes:attr];
    }
    attr[NSForegroundColorAttributeName] = UIColor.blackColor;
    
    //arrow与title
    
    UIImage *upArrow = [UIImage imageNamed:@"upArrow"];
    int titleCount = (int)(self.titlArr.count);
    int repeati = -1, repeatj = -1; //这是在posiArr里的下标，其pos一样，为posiArr[i]
    bool hasRepeat = [self repeatIdx:&repeati idx:&repeatj];
    
    if (hasRepeat) {
        int r_idx = self.posiArr[repeati].intValue;
        attr[NSFontAttributeName] = [UIFont systemFontOfSize:15];
        
        CGRect r = CGRectMake(offset+r_idx*unitLength, hTextAbove, unitLength/2, h-hTextAbove);
        [self.titlArr[repeati] drawInRect:r withAttributes:attr];
        r.origin.x += unitLength/2;
        [self.titlArr[repeatj] drawInRect:r withAttributes:attr];
        
        r.origin.y = hBlow;
        r.size.height = hTextAbove-hBlow;
    
        CGRect rr = CGRectInset(r, 2, 6);
        if (rr.size.width <= 3) {
            rr.size.width = 3;
            rr.origin.x -= 1.5;
        }
        [upArrow drawInRect:rr];
        rr.origin.x -= 0.5*unitLength;
        [upArrow drawInRect:rr];
    } else {
        attr[NSFontAttributeName] = [UIFont systemFontOfSize:17];
        CGRect r;
        
        for (int i = 0; i < titleCount; i++) {
            NSString * ps = self.posiArr[i];
            int p = ps.intValue;
            if (p == repeati || p == repeatj) {
                continue;
            }
            //每个p是有字的位置，其字为title[i]
            r = CGRectMake(offset + p*(unitLength), hTextAbove, unitLength, h-hTextAbove);
            CGFloat dx = 10;
            if (offset == 0 && r.origin.x > w-3) { // 满格 3是模糊的适配值
                r.size.width = 0.35*unitLength;
                r.origin.x -= r.size.width - 2; //2是模糊的适配值
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
    }
    
    
    
    CGContextSetLineWidth(ctx, lineWidth);
    CGContextSetStrokeColorWithColor(ctx, UIColor.blackColor.CGColor);
    CGContextAddPath(ctx, path);
    CGContextStrokePath(ctx);
    
}

@end

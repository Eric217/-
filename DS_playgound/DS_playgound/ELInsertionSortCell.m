//
//  ELInsertionSortCell.m
//  SortReveal
//
//  Created by Eric on 2018/4/26.
//  Copyright © 2018 Eric. All rights reserved.
//

#import "ELInsertionSortCell.h"

@interface ELInsertionSortCell ()

@property (nonatomic, copy) NSString *nextText;

@end

@implementation ELInsertionSortCell

- (void)setDataDict:(NSDictionary *)dataDict {
    [super setDataDict:dataDict];
    _nextText = dataDict[kCommingText];
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
    
    NSMutableDictionary *attr =  [@{NSFontAttributeName: [UIFont systemFontOfSize:27], NSParagraphStyleAttributeName: textStyle} mutableCopy];
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
    
    attr[NSFontAttributeName] = [UIFont systemFontOfSize:17];
    CGRect r = CGRectMake(0, 0, unitLength, 0), rr;
    
    for (int i = 0; i < titleCount; i++) {
        int p = ((NSString *)(self.posiArr[i])).intValue;
        r.origin.x = (offset == 0 ? -4 : offset) + (p+0.5)*(unitLength);
        r.origin.y = hTextAbove;
        r.size.height = h-hTextAbove;
        [self.titlArr[i] drawInRect:r withAttributes:attr];
        r.origin.y = hBlow;
        r.size.height = hTextAbove-hBlow;
        rr = CGRectInset(r, 10, 6);
        if (rr.size.width <= 4) {
            rr.size.width = 4;
            rr.origin.x -= 2;
        }
        [upArrow drawInRect:rr];
    }
    
    //右侧提示文字
    if (!([_nextText isEqualToString:@""] || !_nextText)) {
        textStyle.alignment = NSTextAlignmentRight;
        attr[NSParagraphStyleAttributeName] = textStyle;
        NSString *str1 = [NSString stringWithFormat:@"i = %d", arrSize];
        NSString *str2 = [@"arr[i] = " stringByAppendingString:_nextText];
        
        CGSize box = [str2 sizeWithAttributes:attr];
        if (box.width < offset) {
            r = CGRectMake(w-box.width, 0, box.width, h*0.266);
            [str1 drawInRect:r withAttributes:attr];
            r.origin.y += h*0.228;
            [str2 drawInRect:r withAttributes:attr];
        } else {
//            str2 = [[str1 stringByAppendingString:@" "] stringByAppendingString:str2];
//            box = [str2 sizeWithAttributes:attr];
            if (w - rr.origin.x-rr.size.width > box.width) {
                r = CGRectMake(w-box.width, hBlow, box.width, h*0.266);
                [str1 drawInRect:r withAttributes:attr];
                r.origin.y += h*0.228;
                [str2 drawInRect:r withAttributes:attr];
            } else {
                textStyle.alignment = NSTextAlignmentLeft;
                attr[NSParagraphStyleAttributeName] = textStyle;
                
                r = CGRectMake(2, hBlow, box.width, h*0.266);
                [str1 drawInRect:r withAttributes:attr];
                r.origin.y += h*0.228;
                r.origin.x -= 2;
                [str2 drawInRect:r withAttributes:attr];
                
            }
            
            
            
        }
    }
    
    CGContextSetLineWidth(ctx, lineWidth);
    CGContextSetStrokeColorWithColor(ctx, UIColor.blackColor.CGColor);
    CGContextAddPath(ctx, path);
    CGContextStrokePath(ctx);
    
}





@end

//
//  ELRepeatLinearCell.h
//  SortReveal
//
//  Created by Eric on 2018/4/26.
//  Copyright © 2018 Eric. All rights reserved.
//

#import "ELLinearUnitCell.h"

@protocol RepeatableCell <NSObject>

- (bool)repeatIdx:(int *)m idx:(int *)n;

@end


@interface ELRepeatLinearCell : ELLinearUnitCell <RepeatableCell>

@end

//
//  ELLinearUnitCell1.m
//  SortReveal
//
//  Created by Eric on 2018/4/26.
//  Copyright © 2018 Eric. All rights reserved.
//

#import "ELLinearUnitCell.h"

@implementation ELLinearUnitCell

- (void)setDataDict:(NSDictionary *)dataDict {
    super.dataDict = dataDict;
    
    self.dataArr = [dataDict valueForKey:kDataArr];
    self.posiArr = [dataDict valueForKey:kPositionArr];
    self.titlArr = [dataDict valueForKey:kTitleArr];
    self.coloArr = [dataDict valueForKey:kColorArr];

}

@end

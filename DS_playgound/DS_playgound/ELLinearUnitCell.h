//
//  ELLinearUnitCell1.h
//  SortReveal
//
//  Created by Eric on 2018/4/26.
//  Copyright © 2018 Eric. All rights reserved.
//

#import "ELCollectionCell.h"

//Linear BASE
@interface ELLinearUnitCell : ELCollectionViewCell

@property (nonatomic, copy) NSArray *dataArr;
@property (nonatomic, copy) NSArray<NSString *> *posiArr;
@property (nonatomic, copy) NSArray *titlArr;
@property (nonatomic, copy) NSArray *coloArr;

@end


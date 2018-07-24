//
//  Sorters.h
//  SortReveal
//
//  Created by Eric on 2018/4/18.
//  Copyright © 2018 Eric. All rights reserved.
//

#import "SortBaseClass.h"

//MARK: - 树状 - 堆排序

@interface HeapSorter: SortBaseClass

@end


//MARK: - 线性排序 - 4 个具体实现

@interface LinearSorter : SortBaseClass

@property (nonatomic, assign) int currentI;
@property (nonatomic, assign) int currentJ;

@end


@interface QuickSorter: LinearSorter

@end

@interface BubbleSorter: LinearSorter

@end

@interface SelectionSorter: LinearSorter

@end

@interface InsertionSorter: LinearSorter

@end






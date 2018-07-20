//
//  BinaryTree.h
//  DS_playgound
//
//  Created by Eric on 2018/7/19.
//  Copyright © 2018 SDU_iOS_LAB. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Common.h"

@interface TreeNode : NSObject {
@public
    TreeNode *leftChild;
    TreeNode *rightChild;
    id data;
};

@end

@interface BinaryTree : NSObject {
    TreeNode *root;
}

- (instancetype)initWithdataArray:(NSArray *)t;
- (int)nextStepWithTravesalType:(TravesalType)t finished:(bool *)f;
- (void)reset;


@end



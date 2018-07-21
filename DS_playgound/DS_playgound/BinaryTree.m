//
//  BinaryTree.m
//  DS_playgound
//
//  Created by Eric on 2018/7/19.
//  Copyright © 2018 SDU_iOS_LAB. All rights reserved.
//

#import "BinaryTree.h"

@interface TreeNode ()
@property (nonatomic, assign) int fakeIndex; ///< 每个元素在完全二叉树(假设)中的位置
@property (nonatomic, assign) int existedInStack; ///< 中后序遍历标记
@end

@implementation TreeNode

- (instancetype)init {
    self = [super init];
    leftChild = 0;
    rightChild = 0;
    data = 0; _fakeIndex = -1;
    return self;
}

- (instancetype)initWithData:(id)d {
    self = [[TreeNode alloc] init];
    data = d;
    return self;
}

@end

@interface BinaryTree () {
    
    NSMutableArray<TreeNode*> *_stack_and_queue;
}

@end

@implementation BinaryTree

- (int)nextStepWithTravesalType:(TravesalType)t finished:(bool *)f {
    if      (t == TravesalPre)
        return [self nextStepForPre:f];
    else if (t == TravesalIn)
        return [self nextStepForIn:f];
    else if (t == TravesalPost)
        return [self nextStepForPost:f];
    else if (t == TravesalLevel)
        return [self nextStepForLevel:f];
    else return 0;
}

//level
- (int)nextStepForLevel:(bool *)finished {
    if (_stack_and_queue.count == 0)
        [_stack_and_queue addObject:root];
    TreeNode *_curNode = _stack_and_queue.firstObject;
    [_stack_and_queue removeObjectAtIndex:0];
    if (_curNode->leftChild)
        [_stack_and_queue addObject:_curNode->leftChild];
    if (_curNode->rightChild)
        [_stack_and_queue addObject:_curNode->rightChild];
    if (_stack_and_queue.count == 0)
        *finished = 1;
    return _curNode.fakeIndex;
}

//pre
- (int)nextStepForPre:(bool *)finished {
    if (_stack_and_queue.count == 0)
        [_stack_and_queue addObject:root];
    TreeNode *_curNode = _stack_and_queue.lastObject;
    [_stack_and_queue removeLastObject];
    
    if (_curNode->rightChild)
        [_stack_and_queue addObject:_curNode->rightChild];
    if (_curNode->leftChild)
        [_stack_and_queue addObject:_curNode->leftChild];
    if (_stack_and_queue.count == 0)
        *finished = 1;
    return _curNode.fakeIndex;
}

//in
- (void)addToInOrderStack:(TreeNode *)n {
    [_stack_and_queue addObject:n];
    n.existedInStack++;
}

- (int)nextStepForIn:(bool *)finished {
    if (_stack_and_queue.count == 0) {
        [self addToInOrderStack:root];
        return [self nextStepForIn:finished];
    }
    TreeNode *_curNode = _stack_and_queue.lastObject;
    [_stack_and_queue removeLastObject];
    
    if (_curNode.existedInStack == 0) {
        if (_stack_and_queue.count == 0)
            *finished = 1;
        return _curNode.fakeIndex;
    }
    if (_curNode->rightChild)
        [self addToInOrderStack:_curNode->rightChild];
    [self addToInOrderStack:_curNode];
    if (_curNode->leftChild)
        [self addToInOrderStack:_curNode->leftChild];
    return [self nextStepForIn:finished];
}

//post
- (int)nextStepForPost:(bool *)finished {
    if (_stack_and_queue.count == 0) {
        [self addToInOrderStack:root];
        return [self nextStepForPost:finished];
    }
    TreeNode *_curNode = _stack_and_queue.lastObject;
    [_stack_and_queue removeLastObject];
    
    if (_curNode.existedInStack == 0) {
        if (_stack_and_queue.count == 0)
            *finished = 1;
        return _curNode.fakeIndex;
    }
    [self addToInOrderStack:_curNode];
    if (_curNode->rightChild)
        [self addToInOrderStack:_curNode->rightChild];
    if (_curNode->leftChild)
        [self addToInOrderStack:_curNode->leftChild];
    return [self nextStepForPost:finished];
}

//reset
- (void)resetTreePreOrder:(TreeNode *)n {
    if (!n)
        return;
    n.existedInStack = -2;
    [self resetTreePreOrder:n->leftChild];
    [self resetTreePreOrder:n->rightChild];
}

- (void)reset {
    _stack_and_queue = [NSMutableArray<TreeNode *> new];
    if (root.existedInStack != -2)
        [self resetTreePreOrder:root];
    
}

///init 参数是fake层次序列
- (instancetype)initWithdataArray:(NSArray *)t {
    self = [super init];
    int c = (int)t.count;
    if (c == 0) {
        root = 0; return self;
    }
    TreeNode *root1 = [[TreeNode alloc] initWithData:t.firstObject], *temp;
    root1.fakeIndex = 0;
    if (c == 1) {
        root = root1; return self;
    }
    NSMutableArray *queue = [[NSMutableArray alloc] initWithObjects:root1, nil];

    while (1) {
        temp = queue.firstObject;
        if (!temp)
            break;
        [queue removeObjectAtIndex:0];
        int nextL = temp.fakeIndex * 2 + 1;
        if (nextL < c && ![EmptyNode isEqualToString:t[nextL]]) {
            TreeNode *node1 = [[TreeNode alloc] initWithData:t[nextL]];
            temp->leftChild = node1;
            node1.fakeIndex = nextL;
            [queue addObject:node1];
        }
        if (nextL+1 < c && ![EmptyNode isEqualToString:t[nextL+1]]) {
            TreeNode *node2 = [[TreeNode alloc] initWithData:t[nextL+1]];
            temp->rightChild = node2;
            node2.fakeIndex = nextL+1;
            [queue addObject:node2];
        }
    }
   
    root = root1;
    [self resetTreePreOrder:root];
    [self reset];
    return self;
}

@end

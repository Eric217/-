//
//  AdjacencyWGraph.hpp
//  test1
//
//  Created by Eric on 2018/3/20.
//  Copyright © 2018 Eric. All rights reserved.
//

#ifndef AdjacencyWGraph_hpp
#define AdjacencyWGraph_hpp

#include "AdjacencyWDigraph.mm"
#include "UndirectedNetwork.mm"
#import <Foundation/Foundation.h>
#import "Common.h"

struct IntPair {
    int v1; int v2;
};

template <typename T>
class AdjacencyWGraph : public AdjacencyWDigraph<T>, public UndirectedNetwork {

    LinkedStack<int> * stack;
    
    bool * reachForDFS;
    
    
public:
    AdjacencyWGraph<T>(int ver = 10): AdjacencyWDigraph<T>(ver) {}
    ~AdjacencyWGraph<T>() {
        if (stack) delete stack;
        if (reachForDFS) delete [] reachForDFS;
    }
    
    AdjacencyWGraph<T> & addEdge(int i, int j, const T & w);
    AdjacencyWGraph<T> & deleteEdge(int i, int j);
    
    int degree(int i) const { return this->outDegree(i); }
    
    /// IntPair 第一个值为0是入栈，1是出栈
    IntPair startDFSFrom(int i);
    IntPair nextDFSStep(bool *finished);

    
    
};

template <typename T>
IntPair AdjacencyWGraph<T>::startDFSFrom(int i) {
    stack = new LinkedStack<int>();
    if (reachForDFS) delete [] reachForDFS;
    reachForDFS = new bool[this->n+1];
    for (int i = 1; i < this->n+1; i++)
        reachForDFS[i] = 0;
    reachForDFS[i] = 1;
    stack->push(i);
    return {0, i};
}

template <typename T>
IntPair AdjacencyWGraph<T>::nextDFSStep(bool *finished) {
    int top = stack->Top();
    for (int i = 1; i <= this->n; i++) {
        if (this->arr[top][i] != NoEdge && !reachForDFS[i]) {
            stack->push(i);
            return {0, i};
        }
    }
    stack->pop();
    *finished = stack->isEmpty();
    return {1, top};
}


template <typename T>
AdjacencyWGraph<T> & AdjacencyWGraph<T>::addEdge(int i, int j, const T & w) {
    this->AdjacencyWDigraph<T>::addEdge(i, j, w);
    this->arr[j][i] = w;
    return *this;
}

template <typename T>
AdjacencyWGraph<T> & AdjacencyWGraph<T>::deleteEdge(int i, int j) {
    this->AdjacencyWDigraph<T>::deleteEdge(i, j);
    this->arr[j][i] = NoEdge;
    return *this;
}



#endif /* AdjacencyWGraph_hpp */

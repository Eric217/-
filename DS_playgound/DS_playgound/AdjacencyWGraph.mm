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

struct DFSDataPack {
    int type; int order; int lastTop;
};

struct BFSDataPack {
    int * in_nodes;
    int in_count;
    int out_node;
};

template <typename T>
class AdjacencyWGraph : public AdjacencyWDigraph<T>, public UndirectedNetwork {

    LinkedStack<int> * stack;
    LinkedQueue<int> * queue;
    bool * reached;
    
    
public:
    AdjacencyWGraph(int ver = 10): AdjacencyWDigraph<T>(ver), reached(0), stack(0), queue(0) {}
    ~AdjacencyWGraph();
    
    AdjacencyWGraph<T> & addEdge(int i, int j, const T & w);
    AdjacencyWGraph<T> & deleteEdge(int i, int j);
    
    int degree(int i) const { return this->outDegree(i); }
    
    /// IntPair 第一个值为0是入栈，1是出栈
    DFSDataPack startDFSFrom(int i);
    DFSDataPack nextDFSStep(bool *finished);
    BFSDataPack startBFSFrom(int i);
    BFSDataPack nextBFSStep(bool *finished);

};

template <typename T>
DFSDataPack AdjacencyWGraph<T>::startDFSFrom(int i) {
    stack = new LinkedStack<int>();
    if (reached)
        delete [] reached;
    
    reached = new bool[this->n+1];
    for (int i = 1; i < this->n+1; i++)
        reached[i] = 0;
    reached[i] = 1;
    stack->push(i);
    return {0, i};
}

/// in 的蓝色，out的红色，
template <typename T>
BFSDataPack AdjacencyWGraph<T>::startBFSFrom(int i) {
    queue = new LinkedQueue<int>();
    if (reached)
        delete [] reached;
    
    reached = new bool[this->n+1];
    for (int i = 1; i < this->n+1; i++)
        reached[i] = 0;
    reached[i] = 1;
    queue->push(i);
    int * arr = new int[1];
    arr[0] = i;
    return {arr, 1, 0};
}

template <typename T>
DFSDataPack AdjacencyWGraph<T>::nextDFSStep(bool *finished) {
    int top = stack->Top();
    for (int i = 1; i <= this->n; i++) {
        if (this->arr[top][i] != NoEdge && !reached[i]) {
            stack->push(i);
            reached[i] = 1;
            return {0, i, top};
        }
    }
    stack->pop();
    *finished = stack->isEmpty();
    return {1, top};
}

/// out node turns red, all in-node add line to out-node
template <typename T>
BFSDataPack AdjacencyWGraph<T>::nextBFSStep(bool *finished) {
    int top;
    queue->pop(top);
    int temp[this->n], c = 0;
    for (int i = 1; i <= this->n; i++) {
        if (this->arr[top][i] != NoEdge && !reached[i]) {
            queue->push(i);
            reached[i] = 1;
            temp[c++] = i;
        }
    }
    
    BFSDataPack p;
    if (c > 0) {
        int * arr = new int[c];
        for (int i = 0; i < c; i ++)
            arr[i] = temp[i];
        p.in_nodes = arr;
    } else
        p.in_nodes = 0;
    p.in_count = c;
    p.out_node = top;
    *finished = queue->isEmpty();
    return p;
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

template <typename T>
AdjacencyWGraph<T>::~AdjacencyWGraph<T>() {
    if (stack) { delete stack; stack = 0;}
    if (queue) { delete queue; queue = 0; }
    if (reached){ delete [] reached; reached = 0;}
}

#endif /* AdjacencyWGraph_hpp */

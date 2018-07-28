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
#import "Common.h"

/// for FDS
struct DFSDataPack {
    int type; int order; int lastTop;
};

/// for BFS
struct BFSDataPack {
    int * in_nodes;
    int in_count;
    int out_node;
};

/// for KRU
template <typename T>
class EdgeForHeap {
public:
    EdgeForHeap() {};
    EdgeForHeap(int s, int e, T w): start(s), end(e), weight(w) {};
    operator T() const { return weight; }
    bool operator==(const EdgeForHeap &t) const { return (start==t.start&&end==t.end)||(start ==t.end&&end==t.start); }
    T weight;//边上的权值
    int start, end;//边的端点
};

/// for PRI
template <typename T>
struct PRIDataPack {
    EdgeForHeap<T> *new_edges; ///< 无论怎样都要 delete []
    int new_count;
    int * old_edge; ///< 2个元素，需要delete []
};

template <typename T>
class AdjacencyWGraph : public AdjacencyWDigraph<T>, public UndirectedNetwork {

    LinkedStack<int> * stack;
    LinkedQueue<int> * queue;
    MinHeap<EdgeForHeap<T>> *heap;
    bool * reached;
    
public:
    AdjacencyWGraph(int ver = 10): AdjacencyWDigraph<T>(ver), reached(0), stack(0), queue(0), heap(0) {}
    ~AdjacencyWGraph();
    
    AdjacencyWGraph<T> & addEdge(int i, int j, const T & w);
    AdjacencyWGraph<T> & deleteEdge(int i, int j);
    
    int degree(int i) const { return this->outDegree(i); }
    
    /// IntPair 第一个值为0是入栈，1是出栈
    DFSDataPack startDFSFrom(int i);
    DFSDataPack nextDFSStep(bool *finished);
    BFSDataPack startBFSFrom(int i);
    BFSDataPack nextBFSStep(bool *finished);
    EdgeForHeap<T> * startKruskal();
    EdgeForHeap<T> * nextKruskal();
    PRIDataPack<T> startPrimFrom(int i);
    PRIDataPack<T> nextPrim();

};


template <typename T>
PRIDataPack<T> AdjacencyWGraph<T>::startPrimFrom(int k) {
    if (heap) delete heap;
    int total = this->n, c = 0;
    total = int(total*total/2-total/2);
    heap = new MinHeap<EdgeForHeap<T>>(total);
    EdgeForHeap<T> *temp_connected = new EdgeForHeap<T>[this->n-1];
 
    for (int i = 1; i <= this->n; i++) {
        if (this->arr[i][k] != NoEdge) {
            EdgeForHeap<T> edge(i, k, this->arr[i][k]);
            temp_connected[c++] = edge;
            heap->push(edge);
        }
    }
    int * old = new int[2];
    old[0] = 0; old[1] = k;
    return {temp_connected, c, old};
}

/// pack contains the edge bridging two nodes (but don't know which new) and all new edge
template <typename T>
PRIDataPack<T> AdjacencyWGraph<T>::nextPrim() {
    
    EdgeForHeap<T> *e;
    heap->pop(e);
    
    int * old = new int[2];
    old[0] = e->start;
    old[1] = e->end;
    
    int c = 0;
    EdgeForHeap<T> *temp_connected = new EdgeForHeap<T>[this->n-1];
    
    for (int i = 1; i <= this->n; i++) {
        if (this->arr[i][e->start] != NoEdge) {
            EdgeForHeap<T> edge(i, e->start, this->arr[i][e->start]);
            if (!heap->contains(edge)) {
                temp_connected[c++] = edge;
                heap->push(edge);
            }
        }
    }
    return {temp_connected, c, old};
}

template <typename T>
EdgeForHeap<T> * AdjacencyWGraph<T>::startKruskal() {
    if (heap) delete heap;
    
    int total = this->n, c = 0;
    total = int(total*total/2-total/2);
    
    // edges 传递给heap，heap析构时会自动 delete [] elementes
    EdgeForHeap<int> *edges = new EdgeForHeap<int>[total];
    
    for (int i = 1; i <= this->n; i++) {
        for (int j = 1; j < i; j++) {
            if (this->arr[i][j] != NoEdge) {
                EdgeForHeap<int> *e = edges + c++;
                e->start = i; e->end = j; e->weight = this->arr[i][j];
            }
        }
    }
    
    heap = new MinHeap<EdgeForHeap<T>>(edges, c);
    EdgeForHeap<T> * e;
    heap->pop(e);
    return e;
}

template <typename T>
EdgeForHeap<T> * AdjacencyWGraph<T>::nextKruskal() {
    EdgeForHeap<T> * e; heap->pop(e);
    return e;
}

template <typename T>
DFSDataPack AdjacencyWGraph<T>::startDFSFrom(int i) {
    if (stack) delete stack;
    stack = new LinkedStack<int>();
    if (reached) delete [] reached;
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
    if (queue) delete queue;
    queue = new LinkedQueue<int>();
    if (reached) delete [] reached;
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
    if (heap) { delete heap; heap = 0; }
    if (reached){ delete [] reached; reached = 0;}
}

#endif /* AdjacencyWGraph_hpp */

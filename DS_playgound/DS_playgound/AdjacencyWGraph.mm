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
#include <set>
#import "Common.h"

/// customed operator for PRIM !!
struct IntPair {
    int v1, v2;
    bool operator==(const IntPair & t) const { return (v1==t.v1&v2==t.v2)||(v1==t.v2&&v2==t.v1); }
    bool operator<(const IntPair & t) const { return !(*this == t); }
};

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
    int edge_count;
    int new_node;
    int from_node;
};

template <typename T>
class AdjacencyWGraph : public AdjacencyWDigraph<T>, public UndirectedNetwork {

    LinkedStack<int> * stack;
    LinkedQueue<int> * queue;
    MinHeap<EdgeForHeap<T>> * heap;
    set<int> * _set;
    set<IntPair> *_edge_set;
    bool * reached;
    
public:
    AdjacencyWGraph(int ver = 10): AdjacencyWDigraph<T>(ver), reached(0), stack(0), queue(0), heap(0), _set(0) {}
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
    if (_set) _set->clear();
    else _set = new set<int>();
    if (_edge_set) _edge_set->clear();
    else _edge_set = new set<IntPair>();
    
    int total = this->n, c = 0;
    total = int(total*total/2-total/2);
    heap = new MinHeap<EdgeForHeap<T>>(total);
    EdgeForHeap<T> *temp_connected = new EdgeForHeap<T>[this->n-1];
 
    for (int i = 1; i <= this->n; i++) {
        if (this->arr[i][k] != NoEdge) {
            EdgeForHeap<T> edge(i, k, this->arr[i][k]);
            temp_connected[c++] = edge;
            _edge_set->insert({k, i});
            heap->push(edge);
        }
    }
    _set->insert(k);
    return {temp_connected, c, k, 0};
}

/// pack contains the edge bridging two nodes (but don't know which new) and all new edge
template <typename T>
PRIDataPack<T> AdjacencyWGraph<T>::nextPrim() {
    
    EdgeForHeap<T> heap_top;
    heap->pop(heap_top);
    
    int from = heap_top.start, to = heap_top.end;
    if (_set->find(heap_top.start) == _set->end()) {
        from = to; to = heap_top.start;
    }

    int c = 0;
    EdgeForHeap<T> *temp_connected = new EdgeForHeap<T>[this->n-1];
    
    for (int i = 1; i <= this->n; i++) {
        if (this->arr[i][to] != NoEdge) {
            bool f = 0;
            for (set<IntPair>::iterator it = _edge_set->begin(); it != _edge_set->end(); it++) {
                if ((it->v1 == i && it->v2 == to) || (it->v2 == i && it->v1 == to)) {
                    f = 1; break;
                }
            }
            if (!f) {
                EdgeForHeap<T> edge(i, to, this->arr[i][to]);
                temp_connected[c++] = edge;
                heap->push(edge);
                _edge_set->insert({i, to});
            } 
        }
    }
    _set->insert(to);
    return {temp_connected, c, to, from};
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
    if (stack) { delete stack; stack = 0; }
    if (queue) { delete queue; queue = 0; }
    if (heap) { delete heap; heap = 0; }
    if (_set) { delete _set; _set = 0; } //
    if (_edge_set) { delete _edge_set; _edge_set = 0; }
    if (reached){ delete [] reached; reached = 0; }
}

#endif /* AdjacencyWGraph_hpp */

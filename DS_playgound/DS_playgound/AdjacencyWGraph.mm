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

struct DFSDataPack {
    int type; int order; int lastTop;
};

struct BFSDataPack {
    int * in_nodes;
    int in_count;
    int out_node;
};

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

template <typename T>
struct PRIDataPack {
    EdgeForHeap<T> *new_edges; ///< 无论怎样都要 delete []
    int edge_count;
    int new_node;
    int from_node;
};

struct DIJDataPack {
    int new_node;           ///< 新访问
    int poped_node;         ///< 切换至
    int updated_node;       ///< 更新
    int no_update_node;     ///< 无需更新
    DIJDataPack(): new_node(0), poped_node(0), updated_node(0), no_update_node(0) {}
};

template <typename T>
class AdjacencyWGraph : public AdjacencyWDigraph<T>, public UndirectedNetwork {
    
    // 所有指针，对应哪个算法谁污染谁治理
  
    // for common usage
    bool *_reached;
    MinHeap<EdgeForHeap<T>> *_heap;

    LinkedStack<int> * _stack;      ///< for DFS
    LinkedQueue<int> * _queue;      ///< for BFS
    
    set<int> * _set;                ///< for PRIM
    set<IntPair> *_edge_set;        ///< for PRIM
    
    /// heap for DIJ @discussion 应该使用特殊修改过的堆。因为dist[i]的值会变，但堆内部还是存的原来的值，因此可以堆内部保存 dist指针，让 operator T 返回的是dist[i]的值！然后每次 update dist 需要 reactive。本项目内用了一个折中的办法，不改了
    MinHeap<Dist<T>> * _heap_dij;

    T * dist;                       ///< for DIJ; deleted by graph view
    int * pre;                      ///< for DIJ; deleted by graph view
    int _start;                     ///< for DIJ
    int _current_j;                 ///< for DIJ
    bool _just_poped;               ///< for DIJ
    Dist<T> _cur_dist;              ///< for DIJ
    
public:
    AdjacencyWGraph(int ver = 10):
    AdjacencyWDigraph<T>(ver), _reached(0), _stack(0), _queue(0), _heap(0),
    _set(0), _edge_set(0), _heap_dij(0) {}
    ~AdjacencyWGraph();
    
    AdjacencyWGraph<T> & addEdge(int i, int j, const T & w);
    AdjacencyWGraph<T> & deleteEdge(int i, int j);
    
    int degree(int i) const { return this->outDegree(i); }
    
    /// IntPair 第一个值为0是入栈，1是出栈
    DFSDataPack startDFSFrom(int);
    DFSDataPack nextDFSStep(bool *finished);
    
    BFSDataPack startBFSFrom(int);
    BFSDataPack nextBFSStep(bool *finished);
    
    EdgeForHeap<T> * startKruskal();
    EdgeForHeap<T> * nextKruskal();
    
    PRIDataPack<T> startPrimFrom(int);
    PRIDataPack<T> nextPrim();
    
    DIJDataPack startDijkstra(int from, T *dist, int * pre);
    DIJDataPack nextDijkstra(bool * finished);
    
};

template <typename T>
DIJDataPack AdjacencyWGraph<T>::startDijkstra(int s, T *d, int * p) {
    if (_heap_dij) delete _heap_dij;
    _heap_dij = new MinHeap<Dist<T>>(this->n-1);
    dist = d;
    pre = p;
    for (int i = 0; i < this->n+1; i++)
        pre[i] = 0;
    _just_poped = 0;
    _current_j = 1;
    _start = s;
    _heap_dij->push(Dist<T>(0, s));
    dist[s] = 0;
    return nextDijkstra(0);
}

template <typename T>
DIJDataPack AdjacencyWGraph<T>::nextDijkstra(bool * finished) {
    DIJDataPack p;
    
    if (_current_j == 1 && !_just_poped) {
        _heap_dij->pop(_cur_dist);
        p.poped_node = _cur_dist.idx;
        _just_poped = 1;
        return p;
    }
    
    int i = _cur_dist.idx; // 所有与 i 连的边 (非 start) 走一遍
    for (int j = _current_j; j <= this->n; j++) {
        T incomingDist = dist[i] + this->arr[i][j];
        
        if (j != _start && this->arr[i][j] != NoEdge) {
            if (p.no_update_node) {
                _current_j = j;
                return p;
            }
            if (pre[j] == 0 || dist[j] > incomingDist) {
                dist[j] = incomingDist; // 上面如果pre[j] != 0，则dist[j]一定有正常值
                if (!pre[j]) {
                    _heap_dij->push(Dist<T>(dist[j], j));
                    p.new_node = j;
                } else { // dist更新了，但是
                    p.updated_node = j;
                    Dist<T> *top = _heap_dij->top();
                    int c = 0;
                    while ((top+c)->idx != j) c++;
                    (top+c)->dist = incomingDist;
                    _heap_dij->initialize(top);
                }
                pre[j] = i;
                _current_j = ++j;
                return p;
            } else {
                _current_j = j;
                p.no_update_node = _current_j++;
                
            }
        }
    }
    
    // pop 最后一个节点后，最后一个节点 1-n 遍历时肯定全是 no-update，此时判结束
    if (p.no_update_node) {
        if (_heap_dij->empty())
            *finished = 1;
        _just_poped = 0;
        return p;
    }
    
    // 走完了一轮 for，(能走到这句上一次操作肯定不是 no-update) 也就是正常循环完一个节点且没做操作，因此需要 pop 下一轮开始
    _just_poped = 0;
    _current_j = 1;
    return this->nextDijkstra(finished);
}

template <typename T>
PRIDataPack<T> AdjacencyWGraph<T>::startPrimFrom(int k) {
    if (_heap) delete _heap;
    if (_set) _set->clear();
    else _set = new set<int>();
    if (_edge_set) _edge_set->clear();
    else _edge_set = new set<IntPair>();
    
    int total = this->n, c = 0;
    total = int(total*total/2-total/2);
    _heap = new MinHeap<EdgeForHeap<T>>(total);
    EdgeForHeap<T> *temp_connected = new EdgeForHeap<T>[this->n-1];
    
    for (int i = 1; i <= this->n; i++) {
        if (this->arr[i][k] != NoEdge) {
            EdgeForHeap<T> edge(i, k, this->arr[i][k]);
            temp_connected[c++] = edge;
            _edge_set->insert({k, i});
            _heap->push(edge);
        }
    }
    _set->insert(k);
    return {temp_connected, c, k, 0};
}

/// pack contains the edge bridging two nodes (but don't know which new) and all new edge
template <typename T>
PRIDataPack<T> AdjacencyWGraph<T>::nextPrim() {
    
    EdgeForHeap<T> heap_top;
    _heap->pop(heap_top);
    
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
                _heap->push(edge);
                _edge_set->insert({i, to});
            }
        }
    }
    _set->insert(to);
    return {temp_connected, c, to, from};
}

template <typename T>
EdgeForHeap<T> * AdjacencyWGraph<T>::startKruskal() {
    if (_heap) delete _heap;
    
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
    
    _heap = new MinHeap<EdgeForHeap<T>>(edges, c);
    EdgeForHeap<T> * e;
    _heap->pop(e);
    return e;
}

template <typename T>
EdgeForHeap<T> * AdjacencyWGraph<T>::nextKruskal() {
    EdgeForHeap<T> * e; _heap->pop(e);
    return e;
}

template <typename T>
DFSDataPack AdjacencyWGraph<T>::startDFSFrom(int i) {
    if (_stack) delete _stack;
    _stack = new LinkedStack<int>();
    if (_reached) delete [] _reached;
    _reached = new bool[this->n+1];
    
    for (int i = 1; i < this->n+1; i++)
        _reached[i] = 0;
    _reached[i] = 1;
    _stack->push(i);
    return {0, i};
}

/// in 的蓝色，out的红色，
template <typename T>
BFSDataPack AdjacencyWGraph<T>::startBFSFrom(int i) {
    if (_queue) delete _queue;
    _queue = new LinkedQueue<int>();
    if (_reached) delete [] _reached;
    _reached = new bool[this->n+1];
    for (int i = 1; i < this->n+1; i++)
        _reached[i] = 0;
    _reached[i] = 1;
    _queue->push(i);
    int * arr = new int[1];
    arr[0] = i;
    return {arr, 1, 0};
}

template <typename T>
DFSDataPack AdjacencyWGraph<T>::nextDFSStep(bool *finished) {
    int top = _stack->Top();
    for (int i = 1; i <= this->n; i++) {
        if (this->arr[top][i] != NoEdge && !_reached[i]) {
            _stack->push(i);
            _reached[i] = 1;
            return {0, i, top};
        }
    }
    _stack->pop();
    *finished = _stack->isEmpty();
    return {1, top};
}

/// out node turns red, all in-node add line to out-node
template <typename T>
BFSDataPack AdjacencyWGraph<T>::nextBFSStep(bool *finished) {
    int top;
    _queue->pop(top);
    int temp[this->n], c = 0;
    for (int i = 1; i <= this->n; i++) {
        if (this->arr[top][i] != NoEdge && !_reached[i]) {
            _queue->push(i);
            _reached[i] = 1;
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
    *finished = _queue->isEmpty();
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
    if (_stack)     { delete _stack;      _stack = 0;      }
    if (_queue)     { delete _queue;      _queue = 0;      }
    if (_heap)      { delete _heap;       _heap = 0;       }
    if (_heap_dij)     { delete _heap_dij;      _heap_dij = 0;      }
    if (_set)      { delete _set;       _set = 0;       }
    if (_edge_set) { delete _edge_set;  _edge_set = 0;  }
    if (_reached)   { delete [] _reached; _reached = 0;    }
}

#endif /* AdjacencyWGraph_hpp */

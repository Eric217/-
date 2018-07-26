//
//  AdjacencyWDigraph.hpp
//  10.1_图
//
//  Created by Eric on 19/03/2018.
//  Copyright © 2018 Eric. All rights reserved.
//

#ifndef AdjacencyWDigraph_hpp
#define AdjacencyWDigraph_hpp

#include "Network.mm"
#include "MinHeap.mm"

template <typename T>
void make2DArray(T * * & arr, int row, int col) {
    arr = new T * [row];
    for (int i = 0; i < row; i ++ )
        arr[i] = new T[col];
}

template <typename T>
void delete2DArray(T * * & arr, int row) {
    for (int i = 0; i < row; i ++)
        delete [] arr[i];
    delete [] arr;
    arr = 0;
}
template <typename T>
class Dist {
public:
    Dist() {}
    Dist(T d, int i): dist(d), idx(i) {}
    T dist;
    int idx;
    operator int() const { return dist; }
};

template <typename T>
class AdjacencyWDigraph : public virtual Network {

protected:
    ///当前位置的数组，pos[i]即i当前邻接点的位置
    int * pos;
    ///顶点数
    int n;
    ///边数
    int e;
    ///二维数组
    T ** arr;
    //NoEdge predefined
public:
    AdjacencyWDigraph(int Vertices = 10);
    ~AdjacencyWDigraph() { delete2DArray(arr, n+1); }
    
    bool exist(int i, int j) const;
    int edges() const { return e; }
    int vertices() const { return n; }
    int outDegree(int i) const;
    int inDegree(int i) const;
    
    AdjacencyWDigraph<T> & addEdge(int i, int j, const T & w);
    AdjacencyWDigraph<T> & deleteEdge(int i, int j);

    void shortestPaths(int s, T * d, int * p);
    

    
    ///孤立一个点，回头再删掉这个点
    void isolate(int point);
    
    void initializePos() { pos = new int[n+1]; }
    void deactivatePos() { delete[] pos; pos = 0;}
    ///返回第一个与顶点i邻接的顶点
    int beginIterator(int i);
    int nextIterator(int i);
};


/// Dijkstra. 这里的T就是按int做的了
/// 需要一个数组标记顶点i是否在路径中
/// dist标记路径外的点通过以生成的路径到起始点的最短距离
/// pre标记顶点i的前一个点。
/// 距离最小的顶点加入到路径中，然后更新路径外的顶点通过路径到起始点的最短距离和路径外的顶点通过路径的前一个顶点，直到所有顶点加入到路径中.
/// @param start [1, n]
template <typename T>
void AdjacencyWDigraph<T>::shortestPaths(int start, T * dist, int * pre) {

    MinHeap<Dist<T>> heap(n);
    for (int i = 1; i <= n; i++) {
        dist[i] = arr[start][i];
        if (dist[i] != NoEdge) {
            pre[i] = start;
            heap.push(Dist<T>(dist[i], i));
        } else
            pre[i] = 0;
    }
    
    while (!heap.empty()) {
        Dist<T> distan;
        heap.pop(distan);
        int i = distan.idx;
        for (int j = 1; j <= n; j++) {
           
            T incomingDist = dist[i] + arr[i][j];
            if (j != start && arr[i][j] != NoEdge && (!pre[j] || dist[j] > incomingDist)) {
                dist[j] = incomingDist;
                if (!pre[j])
                    heap.push(Dist<T>(dist[j], j));
                pre[j] = i;
            }
        }
    }
}


/// @param i [1, n]
template <typename T>
int AdjacencyWDigraph<T>::beginIterator(int i) {
    for (int j = 1; j <= n; j++) {
        if (arr[i][j] != NoEdge) {
            pos[i] = j;
            return j;
        }
    }
    pos[i] = n+1;
    return 0;
}

/// @param i [1, n]
template <typename T>
int AdjacencyWDigraph<T>::nextIterator(int i) {
    for (int j = pos[i] + 1; j <= n; j++) {
        if (arr[i][j] != NoEdge) {
            pos[i] = j;
            return j;
        }
    }
    pos[i] = n+1;
    return 0;
}



template <typename T>
AdjacencyWDigraph<T>::AdjacencyWDigraph(int v): n(v), e(0) {
    make2DArray(arr, n+1, n+1);
    for (int i = 1; i <= n; i++)
        for (int j = 1; j <= n; j++)
            arr[i][j] = NoEdge;
}

template <typename T>
bool AdjacencyWDigraph<T>::exist(int i, int j) const {
    if (i < 1 || j < 1 || i > n || j > n || arr[i][j] == NoEdge)
        return 0;
    return 1;
}

/// @param i [1, n]
template <typename T>
int AdjacencyWDigraph<T>::inDegree(int i) const {
    int sum = 0;
    for (int j = 1; j <= n; j++)
        if (arr[j][i] != NoEdge)
            sum++;
    return sum;
}

/// @param i [1, n]
template <typename T>
int AdjacencyWDigraph<T>::outDegree(int i) const {
    int sum = 0;
    for (int j = 1; j <= n; j++)
        if (arr[i][j] != NoEdge)
            sum ++;
    return sum;
}

/// assert: i != j
/// @param i [1, n] /// @param j [1, n]
template <typename T>
AdjacencyWDigraph<T>& AdjacencyWDigraph<T>::addEdge(int i, int j, const T & w) {
    
    if (arr[i][j] == NoEdge)
        e++;
    arr[i][j] = w;
    return *this;
}

/// assert: i != j, arr[i][j] != NoEdge
/// @param i [1, n] /// @param j [1, n]
template <typename T>
AdjacencyWDigraph<T>& AdjacencyWDigraph<T>::deleteEdge(int i, int j) {
  
    arr[i][j] = NoEdge;
    e--;
    return *this;
}



#endif /* AdjacencyWDigraph_hpp */

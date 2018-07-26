//
//  Network.h
//  test1
//
//  Created by Eric on 2018/3/20.
//  Copyright © 2018 Eric. All rights reserved.
//

#ifndef Network_h
#define Network_h

#include "LinkedQueue.mm"


class Network {
    void depthSearch(int, int *, int label);
    bool findPathDFS(int, int, int &, int *, int *);
    
public:
    virtual int beginIterator(int i) { return 0; };
    virtual int nextIterator(int i) { return 0; };
    virtual int vertices() const { return 0; };
    virtual void initializePos() {};
    virtual void deactivatePos() {};

    ///从点V开始，总点数n
    void breadthFSearch(int v, int * reach, int label);
    void depthFSearch(int v, int * reach, int label);
    ///寻找一条路径, 写入路径长度、路径path，返回是否找到
    bool findPath(int start, int end, int & length, int * path);
    
};

bool Network::findPathDFS(int v, int end, int & l, int * path, int *reach) {
    reach[v] = Reached;
    int u = beginIterator(v);
    while (u) {
        if (!reach[u]) {
            path[++l] = u;
            if (u == end)
                return 1;
            if (findPathDFS(u, end, l, path, reach))
                return 1;
            //到这，u->end没戏，退一步，l--
            l--;
        }
        u = nextIterator(v);
    }
    return 0;
}

bool Network::findPath(int start, int end, int & l, int * path) {
    if (start == end) {
        l = 0;
        return 1;
    }
    int n = vertices();
    initializePos();
    int * reach = new int[n+1];
    for (int i = 1; i <= n; i++)
        reach[i] = 0;
    bool x = findPathDFS(start, end, l, path, reach);
    deactivatePos();
    delete [] reach;
    return x;
}

void Network::breadthFSearch(int v, int * reach, int label) {
  
    LinkedQueue<int> queue;
    initializePos();
    reach[v] = Reached;
    queue.push(v);
    while (!queue.isEmpty()) {
        int w, u;
        queue.pop(w);
        u = beginIterator(w);
        while (u) {
            if (!reach[u]) {
                queue.push(u);
                reach[u] = Reached;
            }
            u = nextIterator(w);
        }
//        代替while, 不需要iterator
//        for (int i = 1; i <= n; i++)
//            if (a[w][i] != NoEdge&&reach[i] != label) {
//                reach[i] = label;
//                q.push(i);
//            }
//
 
    }
    deactivatePos();
    
}

/// @param v [1, vertices]
void Network::depthFSearch(int v, int * reach, int label) {
    
    initializePos();
    depthSearch(v, reach, label);
    deactivatePos();
}

void Network::depthSearch(int v, int * reach, int label) {
    reach[v] = Reached;
    int u = beginIterator(v);
    while (u) {
        if (!reach[u])
            depthSearch(u, reach, label);
        u = nextIterator(v);
    }
}


#endif /* Network_h */

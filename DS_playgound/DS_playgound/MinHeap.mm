//
//  MinHeap.hpp
//  9.3
//
//  Created by Eric on 06/01/2018.
//  Copyright © 2018 Eric. All rights reserved.
//

#ifndef MinHeap_hpp
#define MinHeap_hpp
#include <iostream>
using namespace std;
 
template <typename T>
class MinHeap {
    T * element;
    int maxSize;
    int currentSize;
    
public:
    MinHeap(int ms = 0);
    MinHeap(T * arr, int length, int maxSize = -1);
    ~MinHeap() { delete [] element; }
    
    void initialize(T * arr);
    int size() const { return currentSize; }
    T min() const { return element[0]; }
    bool empty() const { return !currentSize; }
    bool full() const { return currentSize == maxSize; }
    bool contains(const T & t) const;
    void deactive() { element = 0; }
    T * top() { return element; }
    
    MinHeap<T> & push(const T &);
    MinHeap<T> & pop(T *&);
    MinHeap<T> & pop(T &);
    MinHeap<T> & pop();
};

template <typename T>
MinHeap<T>::MinHeap(int max) {
    maxSize = max;
    currentSize = 0;
    element = new T[max];
}

template <typename T>
void MinHeap<T>::initialize(T * arr) {
    element = arr;
    for (int i = currentSize/2; i > 0; i--) {
        T t = arr[i-1];
        int c_idx = 2*i-1;
        while (c_idx+1 <= currentSize) {
            if (c_idx+1 < currentSize && arr[c_idx] > arr[c_idx+1])
                c_idx++;
            if (t < arr[c_idx])
                break;
            arr[(c_idx+1)/2-1] = arr[c_idx];
            c_idx = c_idx*2+1;
        }
        int a = (c_idx+1)/2-1;
        arr[a] = t;
    }
}

template <typename T>
MinHeap<T>::MinHeap(T * arr, int length, int mxs) {
    currentSize = length;
    maxSize = (mxs == -1 ? length : mxs);
    initialize(arr);
}


template <typename T>
bool MinHeap<T>::contains(const T & t) const {
    for (int i = 0; i < currentSize; i++)
        if (element[i] == t)
            return 1;
    return 0;
}

template <typename T>
MinHeap<T> & MinHeap<T>::push(const T & t) {
    assert(currentSize <= maxSize);
    int i = ++currentSize; //t从新的叶节点开始 沿着树上升
    while (i != 1 && element[i/2-1] > t) {
        element[i-1] = element[i/2-1];
        i /= 2;
    }
    element[i-1] = t;
    return *this;
}

template <typename T>
MinHeap<T> & MinHeap<T>::pop(T & receiver) {
    
    receiver = element[0];
    T data = element[--currentSize];
    element[currentSize] = receiver;
    if (!currentSize)
        return *this;
    int i = 1; //下标
    while (i < currentSize) {
        if (i+1 < currentSize && element[i] > element[i+1])
            i++;
        if (data < element[i])
            break;
        element[(i+1)/2-1] = element[i];
        i = i*2+1;
    }
    element[(1+i)/2-1] = data;
    return *this;
}

template <typename T>
MinHeap<T> & MinHeap<T>::pop(T *& receiver) {
    
    T data = element[--currentSize];
    element[currentSize] = element[0];
    receiver = element + currentSize;
    if (!currentSize)
        return *this;
    int i = 1; //下标
    while (i < currentSize) {
        if (i+1 < currentSize && element[i] > element[i+1])
            i++;
        if (data < element[i])
            break;
        element[(i+1)/2-1] = element[i];
        i = i*2+1;
    }
    element[(1+i)/2-1] = data;
    return *this;
}

template <typename T>
MinHeap<T> & MinHeap<T>::pop() {
  
    T data = element[--currentSize];
    element[currentSize] = element[0];
    if (!currentSize)
        return *this;
    int i = 1; //下标
    while (i < currentSize) {
        if (i+1 < currentSize && element[i] > element[i+1])
            i++;
        if (data < element[i])
            break;
        element[(i+1)/2-1] = element[i];
        i = i*2+1;
    }
    element[(1+i)/2-1] = data;
    return *this;
}

#endif /* MinHeap_hpp */

//
//  LinkedQueue.hpp
//  8.1
//
//  Created by Eric on 29/11/2017.
//  Copyright © 2017 Eric. All rights reserved.
//

#ifndef LinkedQueue_hpp
#define LinkedQueue_hpp

#include "CppNode.mm"
 

///front = 0 时队列为空
template <typename T>
class LinkedQueue {
    Node<T> * front;
    Node<T> * rear;
    
public:
    LinkedQueue(): front(0), rear(0) {}
    ~LinkedQueue();
    bool isEmpty() const { return !front; }
    int size() const;
    T first() const;
    T last() const;
    LinkedQueue<T> & push(const T &);
    LinkedQueue<T> & pop(T &);
    
};

template <typename T>
int LinkedQueue<T>::size() const {
    Node<T> * node = front;
    int s = 0;
    while (node) {
        s++;
        node = node->link;
    }
    return s;
}

template <typename T>
LinkedQueue<T>::~LinkedQueue() {
    while (front) {
        Node<T> * node = front->link;
        delete front;
        front = node;
    }
}

template <typename T>
T LinkedQueue<T>::first() const {
    return front->data;
}

template <typename T>
T LinkedQueue<T>::last() const {
    return rear->data;
}

template <typename T>
LinkedQueue<T> & LinkedQueue<T>::push(const T & t) {
    Node<T> * node = new Node<T>;
    node->data = t;
    node->link = 0;
    if (front)
        rear = rear->link = node;
    else
        front = rear = node;
    return *this;
    // set<int> s;
    
}

template <typename T>
LinkedQueue<T> & LinkedQueue<T>::pop(T & r) {

    Node<T> * node = front->link;
    r = front->data;
    delete front;
    if (node)
        front = node;
    else
        rear = front = 0;
    return *this;
}

template <typename T>
class LinkedStack {
    Node<T> * top;
public:
    LinkedStack(): top(0) {}
    ~LinkedStack();
    
    bool isEmpty() const { return !top; }
    
    int size() const;
    T Top() const;
    LinkedStack<T> & push(const T & t);
    LinkedStack<T> & pop(T & receiver);
    LinkedStack<T> & pop();
};

template <typename T>
int LinkedStack<T>::size() const {
    int c = 0;
    Node<T> * n = top;
    while (n) {
        c++;
        n = n->link;
    }
    return c;
}
template <typename T>
LinkedStack<T>::~LinkedStack<T>() {
    Node<T> * n;
    while (top) {
        n = top->link;
        delete top;
        top = n;
    }
}

template <typename T>
T LinkedStack<T>::Top() const {
    return top->data;
}

template <typename T>
LinkedStack<T> & LinkedStack<T>::push(const T & t) {
    Node<T> * n = new Node<T>;
    n->data = t;
    n->link = top;
    top = n;
    return *this;
}

template <typename T>
LinkedStack<T> & LinkedStack<T>::pop(T & r) {
    Node<T> * n = top->link;
    r = top->data;
    delete top;
    top = n;
    return *this;
}

template <typename T>
LinkedStack<T> & LinkedStack<T>::pop() {
    Node<T> * n = top->link;
    delete top;
    top = n;
    return *this;
}

#endif /* LinkedQueue_hpp */

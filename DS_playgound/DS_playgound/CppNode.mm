//
//  CppNode.hpp
//  DS_playgound
//
//  Created by Eric on 2018/7/28.
//  Copyright © 2018 SDU_iOS_LAB. All rights reserved.
//

#ifndef CppNode_hpp
#define CppNode_hpp

#include <iostream>
using namespace std;

template <typename T> class LinkedQueue;
template <typename T> class LinkedStack;

template <typename T>
class Node {
    friend class LinkedQueue<T>;
    friend class LinkedStack<T>;
    
    T data;
    Node<T> * link;
};


#endif /* CppNode_hpp */

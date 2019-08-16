# 玩转数据结构

## 需要修改:
UIViewController+funcs 需要在主线程中执行，包装一下。
## 
各种数据结构及算法演示

## 数据库表设计
GRAPH       | DESCRIPTION
-------- | ---
gid | integer, p_k 
gname    |  text, unique
nodecount   | integer

GRAPH_NODE  | DESCRIPTION
-------- | ---
nid | integer, p_k 
gid    |  integer, not null
nname   | text
centerx   | real
centery   |real
gorder   |integer

GRAPH_EDGE  | DESCRIPTION
-------- | ---
eid | integer, p_k 
gid    |  integer, not null
n_s_o   | integer  
n_e_o   | integer 
weight   |integer


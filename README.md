# 玩转数据结构

## 
各种数据结构及算法动态演示

## 有关图的部分的数据库字段 
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
 

#ifndef _LOSERTREE_H_
#define _LOSERTREE_H_

#include <stdio.h>
#include <stdlib.h>
#include "./utils.h"

#define BUFFER_SIZE 1024
/*
typedef struct LoserNode {
    dtype data;
    index_type loser;
} LoserNode;
*/

typedef struct DataBuff {
    dtype data[BUFFER_SIZE];
    index_type length;
}DataBuff;

typedef datatype LoserNode;

typedef struct LoserTree {
    LoserNode nodes[K+1];

    index_type losers[K+1];
} LoserTree;

extern LoserTree losertree;

// functions 
//void init_loser_tree(LoserNode nodes[]);
void adjust_loser_tree(index_type s);
// pop the winner and append a data to it's end
void build_loser_tree();
// and ajust the tree
datatype push_loser_tree(index_type i, datatype last);

#endif

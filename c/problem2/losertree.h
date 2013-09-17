#ifndef _LOSERTREE_H_
#define _LOSERTREE_H_

#include <stdio.h>
#include <stdlib.h>
#include "./utils.h"

#define BUFFER_SIZE 1024
#define LOSER_SIZE 1024

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

typedef struct LoserNode {
    index_type nodeindex;
    dtype data;
    // functions
}LoserNode;

typedef struct LoserTree {
    index_type winner;
    dtype nodes[];
    index_type length;

    index_type losers[LOSER_SIZE];
    index_type n_losers;
} LoserTree;

// functions 
//void init_loser_tree(LoserNode nodes[]);
void adjust_loser_tree(index_type s);
void build_loser_tree(LoserNode nodes[]);
// pop the winner and append a data to it's end
// and ajust the tree
dtype push_loser_tree(datatype last);
//void loser_tree_sort();
//extern DataBuff output_buffer;

#endif

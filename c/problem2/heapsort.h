#ifndef _HEAPSORT_h_
#define _HEAPSORT_h_

#include <stdio.h>
#include <stdlib.h>
#include "./utils.h"

//#define TREE_SIZE 1024

typedef struct HeapTree {
    // data is the indexes of buff
    index_type *data;
    index_type length;
    index_type space;
} HeapTree;

extern HeapTree heap_tree;

void init_tree( datatype *array, index_type size) ;
//static void del_tree(Tree *tree);

// ---------- heap sort ----------------

void heap_adjust_down(index_type i);
// add a data and ajust 
void heap_push(index_type data);
// pop the root data and ajust
index_type heap_pop();

void heapsort();
void free_memory();

#endif

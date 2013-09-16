#ifndef _HEAPSORT_h_
#define _HEAPSORT_h_

#include <stdio.h>
#include <stdlib.h>
#include "./utils.h"

#define TREE_SIZE 1024

typedef struct HeapTree {
    dtype *data;
    ulong length;
    ulong space;
} HeapTree;

void init_tree(dtype* array, index_type size);
//static void del_tree(Tree *tree);

// ---------- heap sort ----------------

void heap_adjust_down(index_type i);
// add a data and ajust 
void heap_push(dtype data);
// pop the root data and ajust
dtype heap_pop();

void heapsort();

#endif

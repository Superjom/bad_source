#include <stdio.h>
#include "./utils.h"
#include "heapsort.h"

void main()
{
    Tree heap_tree;
    dtype datas[] = {0, 3, 2, 1, 7, 12, 56, 2, 1};
    int length = sizeof(datas) / sizeof(dtype);
    show_array(datas, length);
    printf("length is %d\n", length);

    init_tree(datas, length);
    show_array(datas, length);
    heapsort();
    show_array(datas, length);
}


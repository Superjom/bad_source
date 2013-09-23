#include <stdio.h>
#include "../utils.h"
#include "../heapsort.h"

void main()
{
    HeapTree heap_tree;
    dtype datas[] = {
        "hello\tworld\n",
        "afdsfa\t",
        "dsfcdsaf\t"
    };
    int length = 3;
    show_array(datas, length);
    printf("length is %d\n", length);

    init_tree(datas, length);
    build_heap();
    //show_array(datas, length);
    heapsort();
    //show_array_by_indexes(datas, length);
}


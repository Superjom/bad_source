#include "./utils.h"

void swap(dtype *x, dtype *y)
{
    dtype temp;
    temp = *x;
    *x = *y;
    *y = temp;
}


void show_array(dtype *arr, int size) {
    printf("show array: length of %d\n", size);
    int i=0;
    for(; i<size; ++i) {
        printf("%d ", arr[i]);
    }
    printf("\n");
}


index_type get_father_index (index_type i) {
    return (i-1) / 2;
}

index_type get_lleaf_index(index_type i) {
    return 2 * i + 1;
}

index_type get_rleaf_index(index_type i) {
    return 2 * i + 2;
}


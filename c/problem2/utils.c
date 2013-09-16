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

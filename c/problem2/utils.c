#include "./utils.h"

void swap(dtype *x, dtype *y)
{
    dtype temp;
    strcpy(temp, *x);
    strcpy(*x, *y);
    strcpy(*y, temp);
}


void show_array(dtype *arr, int size) {
    printf("show array: length of %d\n", size);
    int i=0;
    for(; i<size; ++i) {
        printf("%s ", arr[i]);
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

// data assign : equal to a = b;
void assign(char *a, char *b) {
    strcpy(a, b);
}

// change it
int lowerthan(char* a, char* b) {
    // find first field
    int i=0;
    for(; i<LINE_LENGTH; ++i) {
        //printf("testing: %c %c\n", a[i], b[i]);
        if(a[i] == '\t') return 1;
        if(b[i] == '\t') return 0;
        if((int)tolower(a[i]) < (int)tolower(b[i])) return 1;
        if((int)tolower(a[i]) > (int)tolower(b[i])) return 0;
    }

    return 0;
}



#ifndef _UTILS_H_
#define _UTILS_H_

#include <stdio.h>

#define umaxof(t) (((0x1ULL << ((sizeof(t) * 8ULL) - 1ULL)) - 1ULL) | \
                            (0xFULL << ((sizeof(t) * 8ULL) - 4ULL)))

#define smaxof(t) (((0x1ULL << ((sizeof(t) * 8ULL) - 1ULL)) - 1ULL) | \
                            (0x7ULL << ((sizeof(t) * 8ULL) - 4ULL)))

#define MIN_DATA -1

typedef unsigned int uint;
typedef unsigned long int ulong;
typedef int index_type;

typedef int dtype;

void show_array(dtype *arr, int size);

void swap(dtype *a, dtype *b);

index_type get_father_index (index_type c);
index_type get_lleaf_index(index_type f);
index_type get_rleaf_index(index_type f);


#endif

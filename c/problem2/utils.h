#ifndef _UTILS_H_
#define _UTILS_H_

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define MIN_DATA -1
#define LINE_LENGTH 450

typedef unsigned int uint;
typedef unsigned long int ulong;
typedef int index_type;


typedef char dtype[LINE_LENGTH];

void show_array(dtype *arr, int size);

void swap(dtype *a, dtype *b);

index_type get_father_index (index_type c);
index_type get_lleaf_index(index_type f);
index_type get_rleaf_index(index_type f);


int line_get_field_lengh(index_type i);
// return 1 if a>b
// else 0 or -1
int line_cmp(dtype *a, dtype *b);

void assign(char *a, char *b);

int lowerthan(char* a, char* b);

#endif

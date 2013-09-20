#ifndef _BUFF_H_
#define _BUFF_H_

#define BUFF_SIZE 1024
#define K 10

#include <stdio.h>
#include <stdlib.h>
#include "./utils.h"

typedef struct Buff {
    index_type start;
    index_type length;
    index_type space;
    int empty;              // empty if file is empty
    dtype data[BUFF_SIZE];
    FILE *fp;
} Buff;

void init_buff(char *ofname, fn_type *ifnames, int isize);
int input(index_type i, index_type size);
void output();
void flush_output_buff();
void flush_output_buff();
datatype get_head(index_type i);

#endif

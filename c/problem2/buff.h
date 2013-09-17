#ifndef _BUFF_H_
#define _BUFF_H_

#define BUFF_SIZE 1024
#define K 10

#include <stdio.h>

typedef struct Buff {
    index_type start;
    index_type length;
    index_type space;
    dtype data[BUFFER_SIZE];
} Buff;

void init_buff();
void flush_output_buff();

int input(index_type i, index_type size);
int output(int i);
void flush_output_buff();









#endif



#include "./buff.h"

static Buff output_buff;
static Buff input_buffs[K];

static FILE *fp[K], *fx[K];
// read a record from ith file to a
// and return size of records
int input(index_type i, index_type size) {
    int s = 0;
    dtype *buff = input_buffs[i].data;
    for(; s<size; ++s) {
        int j = fscanf(fp[i], "%d", buff+s);
        if (j <= 0) {
            return s;
        } else {
            input_buffs[i].length ++;
        }
    }
    return size;
}

void init_buff() {
    output_buff.length = 0;
    output_buff.start = 0;
    output_buff.space = BUFF_SIZE;

    int i=0; 
    for(; i<K; ++i) {
        input_buffs[i].start = 0;
        input_buffs[i].length = 0;
        input_buffs[i].space = BUFF_SIZE;
    }
}


// flush output buff
void output() {
    if (output_buff.length == output_buff.space) {
        flush_output_buff();
    }
}

void flush_output_buff() {
     for(; output_buff.length>0; -- output_buff.length) {
        fprintf(fp[k], "%d", &output_buff[output_buff.length-1]);
     }
}

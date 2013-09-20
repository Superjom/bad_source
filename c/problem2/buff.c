#include "./buff.h"

static Buff output_buff;
static Buff input_buffs[K];

void init_buff(char *ofname, fn_type *ifnames, int isize) {
    output_buff.length = 0;
    output_buff.start = 0;
    output_buff.space = BUFF_SIZE;
    output_buff.fp = fopen(ofname, "a");
    if (output_buff.fp == NULL) perror ("Error opening file");

    int i=0; 
    for(; i<isize; ++i) {
        input_buffs[i].start = 0;
        input_buffs[i].length = 0;
        input_buffs[i].space = BUFF_SIZE;
        input_buffs[i].empty = 0;
        printf("ifnames %d, %s\n", i, ifnames[i]);
        input_buffs[i].fp = fopen(ifnames[i], "r");
        printf("after fopen, %s\n", ifnames[i]);
        if (input_buffs[i].fp == NULL) perror ("Error opening file");
    }
}

// read a record from ith file to a
// and return size of records
int input(index_type i, index_type size) {
    int s = 0;
    Buff *buff = &input_buffs[i];
    //dtype *buff = input_buffs[i].data;
    buff->start = 0;
    buff->length = 0;
    for(; s<size; ++s) {
        int j = fgets(buff->data + buff->length, LINE_LENGTH, buff->fp);
        if (j <= 0) {
            buff->empty = 1;
            return s;
        } else {
            buff->length ++;
        }
    }
    return size;
}

// should be called everytime
// flush output buff automatically if necessory
void output() {
    if (output_buff.length == output_buff.space) {
        flush_output_buff();
    }
}

void flush_output_buff() {
     for(; output_buff.length>0; -- output_buff.length) {
        fprintf(output_buff.fp, "%s", output_buff.data[output_buff.length-1]);
     }
}

// return is empty
// when the buff is empty, char*s in the array will be overloaded
// and gone
// should flush the output_buff first then load 
// more buff in inputbuffs
int pop_head(index_type i, datatype res) {

    // if input_buff is empty, then read file 
    // and add some record to it 
    if (input_buffs[i].start == input_buffs[i].length) {
        int size = input(i, BUFF_SIZE);
    }

    if (i>=K) {
        printf("Error: get head, i beyands K: %d, %d\nexit\n", i, K);
        exit(-1);
    }

    index_type start = input_buffs[i].start ++ ;
    res = input_buffs[i].data[start];

    return input_buffs[i].length == input_buffs[i].start;
}

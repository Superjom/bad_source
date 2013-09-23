#include <stdio.h>
#include "../utils.h"
#include "../buff.h"

void main()
{
    fn_type fnames[4] = {
        "data/1.txt",
        "data/2.txt",
        "data/3.txt",
        "data/4.txt"
    };

    init_buff("data/out.txt", fnames);
    input(0, 2);
    input(1, 4);
    datatype res = pop_head(0);
    append_output_buff(res);
    
    int i=0;
    for(; i<20; ++i) {
        printf("pop %dth \n", i);
        res = pop_head(0);
        append_output_buff(res);
    }
    flush_output_buff();
}


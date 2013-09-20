#include <stdio.h>
#include "../utils.h"
#include "../buff.h"

void main()
{
    fn_type fnames[3] = {
        "data/1.txt",
        "data/2.txt",
        "data/3.txt",
    };

    init_buff("data/out.txt", fnames, 3);
    input(0, 2);
    input(1, 4);
}


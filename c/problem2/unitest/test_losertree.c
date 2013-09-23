#include <stdio.h>
#include "../utils.h"
#include "../losertree.h"

void main()
{
    int i=0;
    char strs[4][30] = {
        "sfda",
        "acdsaf",
        "bsdf",
        "cdsaf"
    };
    for(; i<4; ++i) {
        losertree.nodes[i] = strs[i];
        printf("node %d: %s\n", i, losertree.nodes[i]);
    }
    build_loser_tree();
}


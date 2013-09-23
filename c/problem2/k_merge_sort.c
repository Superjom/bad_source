#include "./k_merge_sort.h"

void k_merge_sort(char *ofname, char **fnames) {
    init_buff(ofname, fnames);
    int i=0; 
    for(; i<K; ++i) {
        input(i, BUFF_SIZE);
        // first step
        losertree.nodes[i] = pop_head(i);
    }
    build_loser_tree();
    // sort
    datatype winner_data;
    index_type winner = losertree.losers[0];
    datatype nextdata;
    while(1) {
        winner = losertree.losers[0];
        winner_data = losertree.nodes[winner];
        if(strcmp(winner_data, MAX_DATA) == 0) break;
        // save it to out_buff
        append_output_buff(winner_data);
        // get next data
        nextdata = pop_head(winner);
        losertree.nodes[winner] = nextdata;
        adjust_loser_tree(winner);
    }
    flush_output_buff();
}

void main(int argc, char *argv[]) {
    if(argc != 2+K) {
        printf( "usage: \t%s [output filename] [input filenames]\n", argv[0]);
        printf("\tshould contain %d input-files. \n", K);
        printf("\tchange config in utils.h\n");
        exit(-1);
    }
    printf("K-merge sort following files: \n");
    int i=0;
    for(; i<K; ++i) {
        printf("\t%s\n", argv[i+2]);
    }
    printf("to output file: %s\n", argv[1]);

    /*
    fn_type fnames[4] = {
        "data/1.txt",
        "data/2.txt",
        "data/3.txt",
        "data/4.txt"
    };
    fn_type ofname = "data/out.txt";

    k_merge_sort(ofname, fnames);
    */
    char *ofname = argv[1];
    char **ifnames = argv + 2;
    k_merge_sort(ofname, ifnames);
}

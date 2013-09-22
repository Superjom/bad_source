#include "./heapsort_file.h"

static FILE *fp;

static dtype buff[N_FILE_LINES];
static index_type length;

void load_file(char *filename) {
    printf("load file: %s\n", filename);

    length = 0;
    fp = fopen (filename, "r");
    if (fp == NULL) perror ("Error opening file");

    while(1) {
        int j = fgets(buff[length], LINE_LENGTH, fp);
        if(j<=0) {
            return;
        }

        if(length % 100000 == 0) {
            printf("loadding %d file\n", length);
            //printf(" load data: %s\n", buff[length-1]);
        }

        if (length > N_FILE_LINES) {
            printf("num of lines larger than max!\nexit\n");
            return;
        }
        ++length;
    }
}

void output_file(dtype *buff, char *filename) {
    // try to remove a file
    printf("try to remove %s\n", filename);
    remove(filename);
    fp = fopen (filename, "a");
    index_type i = 0;
    for(; length>0; --length) {
        fprintf(fp, "%s", buff[length-1]);
    }
}


void main(int argc, char *argv[]) {
    if(argc != 2) {
        printf("usage: cmd filename\n");
        exit(-1);
    }
    char *filename = argv[1];
    load_file(filename);
    printf("init heap tree\n");
    init_tree(buff, length);
    printf("build heap\n");
    build_heap();
    printf("heap sort\n");
    heapsort();
    char ofilename[50];
    strcpy(ofilename, filename);
    strcat(ofilename, ".sorted");
    output_file(buff, ofilename);

    free_memory();
}

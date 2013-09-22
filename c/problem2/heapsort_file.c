#include "./heapsort_file.h"

static FILE *fp;

static datatype *buff;
static index_type length;
static index_type space;

static void init_buff() {
    buff = (datatype *) malloc (sizeof(datatype) * BUFF_INIT_SIZE);
    length = 0;
    if(NULL == buff) {
        printf("Error malloc memory\n");
        exit(-1);
    }
    space = BUFF_INIT_SIZE;
}

static void free_buff() {
    printf("free buff\n");
    index_type i = 0;
    for(; i<length; ++i) {
        free(buff[i]);
    }
    free(buff);
}

void load_file(char *filename) {
    printf("load file: %s\n", filename);

    dtype line;

    length = 0;
    fp = fopen (filename, "r");
    if (fp == NULL) perror ("Error opening file");

    while(1) {
        if(NULL == fgets(line, LINE_LENGTH, fp)) return;

        int len_line = strlen(line) + 1;
        //int j = fgets(buff[length], LINE_LENGTH, fp);
        //printf("to malloc a char[]\n");
        buff[length] = (char *) malloc (len_line * sizeof(char));
        strcpy(buff[length], line);


        ++length;

        //printf("loadding %d %s\n", length, line);
        if(length % 10000 == 0) {
            printf("load %d lines\n", length);
        }


        if (length == space) {
            //printf("to realloc buff memory\n");
            datatype *new_buff = (datatype *) realloc (buff, (length + BUFF_ADD_SIZE)*sizeof(datatype));
            if(NULL == new_buff) {
                printf("Error: realloc memory failed.\n");
                exit(-1);
            }
            buff = new_buff;
            space += BUFF_ADD_SIZE;
        }
    }
    printf("load %d file\n", length);
}

void output_file(datatype *buff, char *filename) {
    // try to remove a file
    printf("try to remove %s\n", filename);
    remove(filename);
    fp = fopen (filename, "a");
    index_type i = 0;
    for(; length>0; --length) {
        fprintf(fp, "%s", buff[heap_tree.data[length-1] ]);
    }
}


void main(int argc, char *argv[]) {
    if(argc != 2) {
        printf("%s: cmd filename\n" , argv[0]);
        exit(-1);
    }
    char *filename = argv[1];

    init_buff();

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
    free_buff();
}

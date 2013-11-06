#include <stdio.h>
#include <string.h>

#define MAX_FIELDS 10
#define BUF_SIZE 1000
#define LEN_FIELD 100

char fields[MAX_FIELDS][LEN_FIELD];
int n_fields = -1;

void split(char *buff, int len, char deli) {
    printf("input: %d-%s", len, buff);

    int i=0;
    int start=0;
    int size = 0;

    // init  again
    n_fields = -1;

    for(; i<len; ++i) {
        //printf("scan:'%c'\n", buff[i]);
        //printf("'%c' == '%c': %d\n", buff[i], '\t', buff[i]=='\t');

        if(buff[i] == '\t') {
            strncpy (fields[++n_fields], buff+start,  size);
            //printf("strncpy, %d, %d\n", start, size);
            start = i+1;
            size = 0;
        }
        size ++;
    }
    strncpy (fields[++n_fields], buff+start,  size);
}

void clear() {
    int i=0;
    for(; i<MAX_FIELDS*LEN_FIELD; ++i) {
        memset(&fields[0], '\0', LEN_FIELD);
    }
}


void main()
{

    char buffer[BUF_SIZE];
    while(fgets(buffer, BUF_SIZE - 1, stdin)){
        int len = strlen(buffer);

        split(buffer, len, '\r');

        /*        
        int i=0;
        printf("%d fields\n\n", n_fields);
        for (; i<=n_fields; ++i) {
            printf("%s\n", fields[i]);
        }
        */

        char *from_url = fields[0];
        char *to_url = fields[1];
        char *funk = fields[2];
        char *from_pattern = fields[3];
        char *to_pattern = fields[4];

        char *endp = NULL;
        
        // change to binary
        unsigned long i_funk = strtoul(funk, &endp, 2);

        printf("binary: %lu\n", i_funk);

        if((1 & i_funk == 0) 
            && (1<<20 & i_funk == 0)
            && (1<<23 & i_funk == 0)) {

            printf("%s\t%s\t%s\n", from_pattern, to_pattern, from_url, to_url);
        }

        clear();
        
    }// end while

}


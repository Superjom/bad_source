#include <stdio.h>
#include "../utils.h"
#include "../heapsort.h"

void main() {
    char a[30] = "hello.1323j";
    printf("a: %s", a);
    char b[30] = "world";
    char tem[30];
    assign(tem, b);
    printf("temp: %s\n", tem);

    int res = lowerthan(a, b);
    printf("%s %s %d\n", a, b, res);

    dtype datas[10] = {
        "axzlkfna",
        "sdfa",
        "dfc",
        "df3e",
        "1da2df",
        "4fdsds",
        "df2df",
        "dsf22",
        "df2df",
    };

    show_array(datas, 9);
    init_tree(datas, 9);
    build_heap();
    heapsort();
    show_array(datas, 9);
    int i=0;
    for(; i<8; ++i) {
        res = lowerthan(datas[i], datas[i+1]);
        printf("%s, %s, %d\n", datas[i], datas[i+1], res);
    }
}

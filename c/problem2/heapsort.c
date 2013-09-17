#include "./heapsort.h"

//static dtype tree_datas[TREE_SIZE];
static HeapTree heap_tree;

static HeapTree * tree = &heap_tree;

void init_tree( dtype array[], index_type size) {
    tree->data = array;
    tree->length = size;
    tree->space = TREE_SIZE;
    //printf("init_tree and get: \n");
    //show_array(tree->data, tree->length);
    //printf("end init_tree\n");
}


void heap_adjust_down(index_type i) { 

    //index_type i = tree->length - 1;
    dtype temp;
    index_type j = get_lleaf_index(i);
    assign(temp, tree->data[i]);

    while( j < tree->length) {
        // get min of left and right leafs
        if(j+1<tree->length && lowerthan(tree->data[j+1], tree->data[j])) {
            j++;
        }
        if (!lowerthan(tree->data[j], temp)) break;
        assign(tree->data[i], tree->data[j]);
        i = j;
        j = get_lleaf_index(i);
    }
    assign(tree->data[i] ,temp);
}

void heap_push( dtype data) {

    assign(tree->data[tree->length] , data);
    tree->length++;

    if (tree->length >= tree->space) {
        printf("ERROR: tree length > space\n");
        exit(-1);
    }

    heap_adjust_down(tree->length-1);
}

char* heap_pop() {

    dtype res, temp; 
    assign(res, tree->data[0]);
    // swap the latest data to root
    swap(&(tree->data[0]), &(tree->data[tree->length-1]));
    tree->length --;

    assign(temp, tree->data[0]);

    if (tree->length < 0)
    {
        printf("ERROR: tree length < 0\n");
        exit(-1);
    }

    index_type i = 0;
    index_type j = get_lleaf_index(i);
    while(j < tree->length) {
        if ( j+1 < tree->length && lowerthan(tree->data[j+1] ,tree->data[j])) j++;
        if (!lowerthan(tree->data[j], temp)) break;

        assign(tree->data[i], tree->data[j]);
        i = j;
        j = get_lleaf_index(i);
    }
    assign(tree->data[i], temp);
    //show_array(tree->data, tree->length);
    return res;
}

void build_heap() {
    index_type i = tree->length/2 - 1;
    for (; i>=0; i--) {
        if (i<0) break;
        //printf("%ldth heap_adjust\n", i);
        heap_adjust_down(i);
    }
}

void heapsort() {
    build_heap();
    //show_array(tree->data, tree->length);
    while(tree->length > 0) {
        heap_pop(tree);
    }
    // the final tree is a inversly-sorted sequence
}

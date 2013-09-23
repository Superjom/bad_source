#include "./losertree.h"

LoserTree losertree;
// nodes[K] stores the min data
//static LoserNode nodes[K+1];

// use pointer to speed up
datatype get_loser_data(index_type s) {
    index_type index = losertree.losers[s];
    return losertree.nodes[index];
}

// adjust sth node up to root
// and update the winner index
void adjust_loser_tree(index_type s) {

    int t = (s+K) / 2;

    while(t > 0) {
        //printf("parent %d\n", t);
        index_type temp;

        //printf("compare: %s: %s\n", losertree.nodes[s], get_loser_data(t));
        if ( lowerthan(get_loser_data(t), losertree.nodes[s])) {
            temp = s;
            s = losertree.losers[t];
            losertree.losers[t] = temp;
        } 
        // jump up to father node
        t /= 2;
    }
    losertree.losers[0] = s;
}

void build_loser_tree() {
    // init losertree
    // build loser tree 
    // set MIN_DATA to loser nodes
    losertree.nodes[K] = MIN_DATA;
    index_type i = 0;
    for(; i<K+1; ++i) {
        losertree.losers[i] = K;
    }
    // ajust up to root
    i = K;
    for(; i>=0; --i) {
        adjust_loser_tree(i);
    }
}

// push a new data to a queue
datatype push_loser_tree(index_type i, datatype last) {
    datatype res = losertree.nodes[losertree.losers[0] ];
    losertree.nodes[i] = last;
    adjust_loser_tree(i);
    return res;
}

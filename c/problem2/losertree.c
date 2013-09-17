#include "./losertree.cpp"

static LoserTree losertree;

// use pointer to speed up
dtype *get_loser_data(index_type s) {
    index = losertree.losers[s];
    return &(losertree.nodes[index]);
}

// adjust sth node up to root
// and update the winner index
void adjust_loser_tree(index_type s) {
    index_type temp, parent;

    parent = get_father_index(s);

    while(parent >= 0) {

        if ( * get_loser_data(parent) < * get_loser_data(s)) {
            temp = s;
            // s record the current winner
            s = parent;
            losertree.losers[parent] = temp;
        } 
        // jump up to father node
        parent = get_father_index(parent);
    }
    // update winner
    losertree.winner = s;
}

void build_loser_tree(LoserNode nodes[]) {
    // init losertree
    losertree.datas = nodes;
    losertree.length = sizeof(nodes) / sizeof(LoserNode);
    losertree.n_losers = losertree.length - 1;
    // build loser tree 
    // set MIN_DATA to loser nodes
    index_type i = 0;
    for(; i<losertree.n_losers; ++i) {
        losertree.losers[i] = MIN_DATA;
    }
    // ajust up to root
    i = 0;
    for(; i<losertree.length; ++i) {
        adjust_loser_tree(i);
    }
}

// push a new data to a queue
dtype push_loser_tree(index_type i, datatype last) {
    dtype res = losertree.datas[losertree.winner];
    losertree.datas[i] = last;
    adjust_loser_tree(i);
    return res;
}

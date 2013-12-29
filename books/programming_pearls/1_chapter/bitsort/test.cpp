#include <iostream>
#include <vector>
#include <ctime>
#include <cstdlib>
#include <set>
#include "bitspace.h"
using namespace std;
using namespace bitsort;

set<numtype> rans;
const size_t length = 10000;
const unsigned int max_value = 9999999;
bitspace bits;


numtype gen_random() {
    return rand() % max_value + 1;
}

void genRans() {
    while (rans.size() != length) {
        numtype ra = gen_random();
        cout << "get random: "<< ra << " size: " << rans.size() << endl;
        rans.insert( ra);
    }
}


int main() 
{
    srand(time(NULL));
    genRans();
    // scan the set 
    set<numtype>::iterator it;
    for(it=rans.begin(); it!=rans.end(); ++it) {
        cout<< "adding "<< *it << endl;
        bits.add(*it);
    }
    bits.map();

    return 0;
}

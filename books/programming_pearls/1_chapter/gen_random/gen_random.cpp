#include <iostream>
#include <fstream>
#include <ctime>
#include <cstdlib>
#include <set>
using namespace std;

typedef unsigned numtype;
const numtype max_value = 999999;

// generate a random
inline numtype gen_random(const numtype& max_value) {
    return rand() % max_value + 1;
}

// generate randoms
void genRans(set<numtype> &rans, const size_t length) {
    srand(time(NULL));

    while (rans.size() != length) {
        numtype ra = gen_random(max_value);
        cout << "get random: " << ra << " size: " << rans.size() << endl;
        rans.insert( ra);
    }
}

int main() 
{
    set<numtype> rans;
    genRans(rans, 1000000);

    ofstream fout("hel.txt");

    // output to a file
    for(set<numtype>::iterator it=rans.begin();
            it != rans.end(); ++it) {
        //cout << "ran: " << *it << endl;
        fout << *it << endl;
    }

    return 0;
}

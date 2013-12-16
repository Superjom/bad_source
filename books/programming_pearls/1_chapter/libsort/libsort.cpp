#include <iostream>
#include <ctime>
#include <cstdlib>
#include <set>
#include <vector>
#include <algorithm>
using namespace std;

typedef unsigned numtype;
const int max_value = 9999999;
const size_t length = 10000;

// generate a random
numtype gen_random() {
    return rand() % max_value + 1;
}

// generate randoms
void genRans(set<numtype> &rans) {
    srand(time(NULL));

    while (rans.size() != length) {
        numtype ra = gen_random();
        cout << "get random: "<< ra << " size: " << rans.size() << endl;
        rans.insert( ra);
    }
}

class libsort {
public:
    libsort();
    void my_sort();
    void display();

private:
    set<numtype> rans;
    vector<numtype> nums;
};

libsort::libsort() {
    cout<< "libsort constract ... " << endl;
    cout<< "generate randoms ... " << endl;
    genRans(rans);
    for(set<numtype>::iterator i=rans.begin(); 
            i!=rans.end(); ++i) {
        nums.push_back(*i);
    }
}

void libsort::my_sort() {
    cout << "sorting " << endl;
    sort(nums.begin(), nums.end());
}

void libsort::display() {
    cout << "display the result ... " << endl;

    for(vector<numtype>::iterator i=nums.begin();
            i!=nums.end(); ++i) {
        cout << *i << endl;
    }
}


int main() 
{
    libsort sorter;
    sorter.my_sort();
    sorter.display();

    return 0;
}

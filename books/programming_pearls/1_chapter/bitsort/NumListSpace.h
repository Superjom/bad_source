/*
 * NumListSpace.h
 *
 *  Created on: Dec 15, 2013
 *      Author: chunwei
 *
 *  Objective:
 *      create a container which can sort a set of integeters
 *      in O(n) complexity
 */

#ifndef NUMLISTSPACE_H_
#define NUMLISTSPACE_H_
#include <iostream>
#include <math.h>
using namespace std;

#define n_bits  10000000
const size_t len_num = 7;

typedef int numtype;

namespace bitsort {

class NumListSpace {
public:
	virtual void add(const numtype&) = 0;
    void map();

protected:
    virtual bool has_next() = 0;
    virtual void mapper() = 0;
};

} /* namespace bitsort */
#endif /* NUMLISTSPACE_H_ */

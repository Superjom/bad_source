/*
 * bitspace.h
 *
 *  Created on: Dec 15, 2013
 *      Author: chunwei
 *
 *  Description:
 *      use a bit container of which each bit can stand for an
 *      positive integeter no-repeatedly.
 */

#ifndef BITSPACE_H_
#define BITSPACE_H_

#include <iostream>
#include <bitset>
#include "NumListSpace.h"
using namespace std;

namespace bitsort {

class bitspace: public bitsort::NumListSpace {
public:
	bitspace();
    void add(const numtype&);
    void reset_pos(size_t i_pos=-1);

protected:
	bool has_next();
	void mapper();

private:
    bitset<n_bits> bits;
    size_t pos;
};

} /* namespace bitsort */
#endif /* BITSPACE_H_ */

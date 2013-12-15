/*
 * bitspace.cpp
 *
 *  Created on: Dec 15, 2013
 *      Author: chunwei
 */

#include "bitspace.h"

namespace bitsort {

bitspace::bitspace() {
	pos = -1;
}

void bitspace::add(const numtype& num) {
	bits.set(num);
}

void bitspace::mapper() {
	if(bits[pos]==1) {
		cout<<pos<<endl;
	}
}

void bitspace::reset_pos(size_t i_pos) {
    pos = i_pos;
}

bool bitspace::has_next() {
	return (++pos != n_bits);
}

} /* namespace bitsort */

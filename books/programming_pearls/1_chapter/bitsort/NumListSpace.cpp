/*
 * NumListSpace.cpp
 *
 *  Created on: Dec 15, 2013
 *      Author: chunwei
 */

#include "NumListSpace.h"

namespace bitsort {

void NumListSpace::map() {
    while(has_next()) {
        mapper();
    }
}


} /* namespace bitsort */

#!/bin/bash

echo "B fromurl" 

cat ../sample |sort | uniq | awk -F"\t" 'BEGIN{
        last_key = "";

        last_b_fromurl = 0;
        last_c = 0;

        num = 0;
    }{
    url = $1;
    tag = $2;

    if (last_key != url) {
        if(last_b_fromurl && last_c) {
            num ++;
        }
        last_b_fromurl = 0;
        last_c = 0;

        last_key = url;
    }

    if(tag == "Bfrom") {
        last_b_fromurl = 1;
    }

    if(tag == "C") {
        last_c = 1;
    }

} END {
    print num;
}' 


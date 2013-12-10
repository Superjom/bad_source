#!/bin/bash

echo "B tourl" 

cat ../sample |sort | uniq | awk -F"\t" 'BEGIN{
        last_key = "";

        last_b_tourl = 0;
        last_c = 0;

        num = 0;
    }{
    url = $1;
    tag = $2;

    if (last_key != url) {
        if(last_b_tourl && last_c) {
            num ++;
        }
        last_b_tourl = 0;
        last_c = 0;

        last_key = url;
    }

    if(tag == "Bto") {
        last_b_tourl = 1;
    }

    if(tag == "C") {
        last_c = 1;
    }

} END {
    print num;
}' 


#!/bin/bash

echo "B tourl"

cat ../sample | awk -F"\t" '{
    url = $1;
    tag = $2;

    if(tag == "Bto") {
        print $0;
    }
}' | uniq | wc -l

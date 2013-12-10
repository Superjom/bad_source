#!/bin/bash

echo "B fromurl" 

cat ../sample | awk -F"\t" '{
    url = $1;
    tag = $2;

    if(tag == "Bfrom") {
        print $0;
    }
}' | uniq | wc -l

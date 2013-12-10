#!/bin/bash

echo "B fromurl and tourl"

cat ../b.sample | awk -F"\t" '{

    print $1;
    print $2;

}' | sort | uniq | wc -l


cat ../sample | uniq | awk -F"\t" '{
    url = $1;
    tag = $2;

    if (tag == "Bto" || tag == "Bfrom") {
        print url;
    }

}' | sort | uniq  | wc -l



echo reducer

cat ../sample | sort | awk -F"\t" 'BEGIN{
    n_B_fromurl = 0;
    n_B_tourl = 0;
    n_B_fromurl_and_tourl = 0;
    n_C_and_B_tourl = 0;
    n_C_and_B_fromurl = 0;

    last_url = "";
    last_tag = "";

    # status
    last_has_B_fromurl = 0;
    last_has_B_tourl = 0;
    last_has_C = 0;
}

{
    # calculate
    url = $1;
    tag = $2;

    if(url != last_url) {
        # yield last res
        if(last_has_B_tourl) {
            n_B_tourl ++;
        }

        if(last_has_B_fromurl) {
            n_B_fromurl ++;
        }

        if(last_has_B_fromurl || last_has_B_tourl) {
            n_B_fromurl_and_tourl ++;
            #print last_url;
        }

        if(last_has_C) {
            if(last_has_B_fromurl) {
                n_C_and_B_fromurl ++;
            }

            if(last_has_B_tourl) {
                n_C_and_B_tourl ++;
            }
        }

        # init status
        last_url = url;

        last_has_B_fromurl = 0;
        last_has_B_tourl = 0;
        last_has_C = 0;

    } 


    # hit
    if ("Bto" == tag) {
        last_has_B_tourl = 1;
    }

    if ("Bfrom" == tag) {
        last_has_B_fromurl = 1;
    }

    if ("C" == tag) {
        last_has_C = 1;
    }


} END {

    # yield last record
    if(last_has_B_tourl) {
        n_B_tourl ++;
    }

    if(last_has_B_fromurl) {
        n_B_fromurl ++;
    }

    if(last_has_B_fromurl || last_has_B_tourl) {
        n_B_fromurl_and_tourl ++;
    }

    if(last_has_C) {
        if(last_has_B_fromurl) {
            n_C_and_B_fromurl ++;
        }

        if(last_has_B_tourl) {
            n_C_and_B_tourl ++;
        }
    }

    print "n_B_fromurl_and_tourl" n_B_fromurl_and_tourl

}' 



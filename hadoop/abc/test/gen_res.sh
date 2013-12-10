cat part-0000* | awk -F"\t" 'BEGIN{
    b_from = 0;
    b_to = 0;
    b_to_from = 0;
    bc_to = 0;
    bc_from = 0;
}{
    if(NF == 3) {
        if($1 == "B" && $3 == "fromurl") {
            b_from += $2;
        }

        if($1 == "B" && $3 == "tourl") {
            b_to += $2;
        }

        if($1 == "B" && $3 == "tourl_and_fromurl") {
            b_to_from += $2;
        }

        if($1 == "BC" && $3 == "tourl") {
            bc_to += $2;
        }

        if($1 == "BC" && $3 == "fromurl") {
            bc_from += $2;
        }
    }
}END{
    print "b_from" "\t" b_from;
    print "b_to" "\t" b_to;
    print "b_to_from" "\t" b_to_from;
    print "bc_to" "\t" bc_to;
    print "bc_from" "\t" bc_from;
}'

# concat
site_ph=./all.site
domain_ph=./all.domain
in_ph=./in.url
inv_url_ph=./inv.url
new_file=./new.file
sorted_new_file=${new_file}.sorted
output_path=./output.final

init_sort() {
    cat $site_ph $domain_ph > $in_ph

    rm ${output_path}

    awk '{
        for (i=length($1); i!=0; i--)
        {
            x = x substr($1, i, 1);
        }
        print x;
    }' $in_ph > $inv_url_ph

    paste -d " " $inv_url_ph $in_ph > $new_file

    sort -k1 $new_file > $sorted_new_file
}

split_part() {
    fpath=$1
    tpath=$2
    awk -v tpath=$tpath '{
        #print substr($1,1,1) head
        len_us = split($1, us, ".");
        head = substr(us[len_us-1],1,1) ;
        ttpath= tpath "." head;
        print $0 >> ttpath
    }' $fpath > $tpath
}

process_by_head() {
    heads=$1
    for head in $heads; do
	    echo "$head"
	    in_ph="data/in.$head"

        awk 'BEGIN {
                n_site_queue = 0;
                sum_domain = 0;
                n_sites = 0;
                domain  = "";
            } 
        {
            # domain
            if(NF == 2) {
                # process last domain
                ave_num = sum_domain / n_sites;
                for( i=0; i<n_site_queue; i++) {
                    split( site_queue[i], arr, " ");
                    if(arr[2] > ave_num) {
                        print arr[1] "\t" domain "\t" arr[2] "\t" ave_num
                    }
                }
                # init status
                n_site_queue = 0;
                sum_domain = 0;
                n_sites = 0;
                domain = $2;
            }
            else if(NF == 3) {
                site_queue[ n_site_queue ] = $0
                sum_domain += $3;
                n_sites++;
            }
        }

        END {
            ave_num = sum_domain / n_sites;
            for( i=0; i<n_site_queue; i++) {
                split( site_queue[i], arr, " ");
                if(arr[2] > ave_num) {
                    print arr[1] "\t" domain "\t" arr[2] "\t" ave_num
                }
            }
        } ' $path >> $output_path
    done;
}

main_muliti() {
    init_sort

    rm data/*
    split_part $in_ph data/in

    process_by_head "a b d e"&
    process_by_head "h i j k l"&
    process_by_head "o p q r s"&
    process_by_head "v w x y z t"&
    process_by_head "g n u _ f -" &
    process_by_head "c"&
    process_by_head "m"&

    # remove temporary files
    for f in all.domain all.site domain_ave in url_domain; do
        cmd="rm data/${f}.*"
	echo $cmd; $cmd;
    done

    cmd="rm data/output.[a-z]"
    echo $cmd; $cmd;
    rm data/output.-
    rm data/output._
}

main_multi

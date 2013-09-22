site_ph=all.site
domain_ph=all.domain

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

output_domain_url() {
    part_domain_ph=$1
    part_site_ph=$2
    in_ph=$3

    cat $part_domain_ph $part_site_ph | awk '
    function get_domain(DOMAIN_DIC, url) {
        len_us = split(url, us, ".");
        for(i=1; i<=len_us; i++)
        {
            url = "";
            for(j=i; j<=len_us; j++)
            {
                if(url == "")
                {
                    url = us[j];
                }
                else{
                    url = url  "."  us[j];
                }

            }
            if (url in DOMAIN_DIC) {
                return url;
            }
        }
    }

    BEGIN{
        flag=0;
    }
    {
        # build dic
        if(NF == 1) {
            DOMAIN_DIC[$1]=0;
            N_SITE[$1]=0;
        }
        else if(NF == 2) {
            url = $1;
            num = $2;
            domain = get_domain(DOMAIN_DIC, url);
            DOMAIN_DIC[domain] += num;
            N_SITE[domain] ++;
            # output to file
            printf("%s %s %d\n", url, domain, num);
        }
    }

    END{    
        # output domain s average num of urls
        for(key in DOMAIN_DIC) {
            printf("%s %f\n", key, DOMAIN_DIC[key]/N_SITE[key]);
        }
    }' > $in_ph

}

domain_ave() {
    domain_ave_ph=$1
    url_domain_ph=$2
    # extract "domain ave"
    awk '{
        if (NF == 2) {
            print $0;
        }
    }' $in_ph > $domain_ave_ph

    # extract "url domain"
    awk '{
        if (NF == 3) {
            print $0;
        }
    }' $in_ph > $url_domain_ph
}

buff() {
    domain_ave_ph=$1
    url_domain_ph=$2
    output_ph=$3
    cat $domain_ave_ph $url_domain_ph | awk '{
        # build dic
        if (NF == 2) {
            domain = $1;
            ave = $2;
            DOMAIN_DIC[domain] = ave;

        } else if(NF == 3) {
            url = $1;
            domain = $2;
            num = $3;
            if (num > DOMAIN_DIC[domain])
            {
		    print url "\t" domain "\t" num "\t" DOMAIN_DIC[domain];
                #printf("%s\n",url, num, DOMAIN_DIC[domain]);
            }
        }
    }' > $output_ph
}

process_by_head() {

    heads=$1
    for head in $heads; do
	    echo "$head"
	    in_ph="data/in.$head"

	    head_domain_ph="data/${domain_ph}.$head"
	    head_site_ph="data/${site_ph}.$head"
	    domain_ave_ph="data/domain_ave.$head"
	    url_domain_ph="data/url_domain.$head"
	    output_ph="data/output.$head"


	    echo "output_domain_url $head" 
	    output_domain_url $head_domain_ph $head_site_ph $in_ph
	    echo "domain_ave $head"
	    domain_ave $domain_ave_ph $url_domain_ph
	    echo "buff $head"
	    buff $domain_ave_ph $url_domain_ph $output_ph
     done
}

main() {

    base_domain_ph="data/${domain_ph}"
    base_site_ph="data/${site_ph}"

    rm data/*
    split_part $domain_ph $base_domain_ph
    split_part $site_ph $base_site_ph

    for head in 0 1 2 3 4 5 6 7 8 9 a b c d e f g h i g k l m n o p q r s t u v w x y z - _; do
	    echo "$head"
	    in_ph="data/in.$head"

	    head_domain_ph="data/${domain_ph}.$head"
	    head_site_ph="data/${site_ph}.$head"
	    domain_ave_ph="data/domain_ave.$head"
	    url_domain_ph="data/url_domain.$head"
	    output_ph="data/output.$head"


	    echo "output_domain_url $head" 
	    output_domain_url $head_domain_ph $head_site_ph $in_ph
	    echo "domain_ave $head"
	    domain_ave $domain_ave_ph $url_domain_ph
	    echo "buff $head"
	    buff $domain_ave_ph $url_domain_ph $output_ph
    done
    
    echo "final output"
    cat data/output.* > data/output.final
}

main_multi() {
    base_domain_ph="data/${domain_ph}"
    base_site_ph="data/${site_ph}"

    rm data/*
    split_part $domain_ph $base_domain_ph
    split_part $site_ph $base_site_ph

    process_by_head "a b d e"&
    process_by_head "h i j k l"&
    process_by_head "o p q r s"&
    process_by_head "v w x y z t"&
    process_by_head "g n u _ f -" &
    process_by_head "c"&
    process_by_head "m"&
	
    wait

    echo "final output"
    cat data/output.* > data/output.final

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


#main
main_multi
#split_part $domain_ph a out

# concat
site_ph=./all.site
domain_ph=./all.domain
in_ph=./in.url
url_domain_ph=./url_domain
domain_ave_ph=./domain_ave
output_ph=./output

cat $domain_ph $site_ph | awk '
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
        printf("%s %s url\n", url, domain);
    }
}

END{    
    # output domain s average num of urls
    for(key in DOMAIN_DIC) {
        printf("%s %f\n", key, DOMAIN_DIC[key]/N_SITE[key]);
    }
}' > $in_ph

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

cat $domain_ave_ph $url_domain_ph | awk '{
    # build dic
    if (NF == 2) {
        domain = $1;
        num = $2;
        DOMAIN_DIC[domain] = num;

    } else if(NF == 3) {
        url = $1;
        domain = $2;
        printf("%s %f\n",url, DOMAIN_DIC[domain]);
    }
}' > $output_ph

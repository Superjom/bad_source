# concat
site_ph=./all.site
domain_ph=./all.domain
in_ph=./in.url
inv_url_ph=./inv.url
new_file=./new.file
sorted_new_file=${new_file}.sorted

cat $site_ph $domain_ph > $in_ph
awk '{
    for (i=length($1); i!=0; i--)
    {
        x = x substr($1, i, 1);
    }
    print x;
}' $in_ph > $inv_url_ph

paste -d " " $inv_url_ph $in_ph > $new_file

sort -k1 $new_file > $sorted_new_file

awk '{
    if(NF == 2) {
    }
    else if(NF == 3) {
    }
}'

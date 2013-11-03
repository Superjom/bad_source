#query
:<<D
cat ids hadoop.ids | python gen_query_ids.py | sh query.sh


cd querys

ls -1 | sort -k1n | while read fn; do
    cat $fn | python ../get_job_url.py
done > job.urls

cd ..

cat ids job.urls | python gen_query_ids.py | \
while read id url; do
    cd content/    
    echo $id"\t"$url
    curl $url -o $id
    cd ..
done
D

statis_path=output/statis.fn
statis_fnlist=output/fn.list
res_ph=output/statis.res
rm $statis_path
rm $statis_fnlist

ls -1 content/scan | sort -k1n | while read fn; do
    path=content/scan/$fn
    echo $fn >> $statis_fnlist
    cat $path | python html2text.py | python text2data.py >> $statis_path
done

paste -d"\t" $statis_fnlist $statis_path > $res_ph

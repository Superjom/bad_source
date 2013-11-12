:<<D
#query
cat nohup.origin.out | python  get_ids.py > ids
cat nohup.origin.out | python get_hadoop_id.py > hadoop.ids

rm querys/*
cat ids hadoop.ids | python gen_query_ids.py | sh query.sh



echo ".. get job url"
cd querys

ls -1 | sort -k1n | while read fn; do
    #echo "file: " $fn
    cat $fn | python ../get_job_url.py
done > ../job.urls

cd ..


cat ids job.urls | python gen_query_ids.py | \
while read id url; do
    cd content/    
    echo $id"\t"$url
    curl $url -o $id
    cd ..
done

exit 0

rm content/scan/*
rm content/distcp/*
mv content/*.0 content/distcp
mv content/*.1 content/scan

D

statis_path=output/statis.fn
statis_fnlist=output/fn.list
res_ph=output/statis.res
rm $statis_path
rm $statis_fnlist

ls -1 content/scan | sort -k1n | while read fn; do
    echo $fn
    path=content/scan/$fn
    echo $fn >> $statis_fnlist
    cat $path | python html2text.py | python text2data.py >> $statis_path
done

# get output bytes
HADOOP="/home/spider/hadoop-client/hadoop/bin/hadoop"

cat ids | sort -k1n |  while read id; do
    $HADOOP fs -dus  /user/rd/yanchunwei/research/$id
done


#paste -d"\t" $statis_fnlist $statis_path > $res_ph

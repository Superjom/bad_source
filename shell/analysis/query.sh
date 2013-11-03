cd querys
while read id hid; do
    url="http://szjjh-hlb-job.dmop.baidu.com:8031/jobhistory.jsp?jobID=$hid&jobName=&userName=&groupName=&startTime=&finishTime=&jobStatus=&queue="
    curl $url -o $id
done
cd ..

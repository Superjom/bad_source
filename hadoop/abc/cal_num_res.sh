#!/bin/bash

source env.sh

B_DATA_PH=/user/wdbd/working/global_la_wise_test/hlb_download_inner_link_filterbyxpath_1129_pp
C_DATA_PH=/user/wdbd/working/dingrui01/inner_pp/30_big_domain_filter_pp_merge

B_C_MERGE_DATA_PH=/user/wdbd/working/yanchunwei/inner_pp/b_c_merge

B_C_NUM_DATA_PH=${B_C_MERGE_DATA_PH}_num


TEST_DATA_PH=/user/wdbd/working/yanchunwei/inner_pp/testdata
TEST_DATA_OUTPUT_PH=/user/wdbd/working/yanchunwei/inner_pp/testdata_output

mapper() {
    awk -F"\t" '{
        if(NF == 3) {
            print $0;
        }
    }'
}

reducer() {
    awk -F"\t" 'BEGIN{
        b_from = 0;
        b_to = 0;
        b_to_from = 0;
        bc_to = 0;
        bc_from = 0;
    }{
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
    }END{
        print "b_from" "\t" b_from;
        print "b_to" "\t" b_to;
        print "b_to_from" "\t" b_to_from;
        print "bc_to" "\t" bc_to;
        print "bc_from" "\t" bc_from;
    }'
}

run() {

$RP_HADOOP streaming \
     -D mapred.job.name="dingrui_task, B C union res by yanchunwei@baidu.com" \
     -D mapred.job.priority=NORMAL \
     -D mapred.map.tasks=30000 \
     -D mapred.reduce.tasks=1 \
     -D mapred.job.map.capacity=2000 \
     -D mapred.job.reduce.capacity=1 \
     -D mapred.reduce.over.capacity.allowed=true \
     -input $B_C_MERGE_DATA_PH \
     -output $B_C_NUM_DATA_PH \
     -file cal_num_res.sh \
     -file env.sh \
     -mapper "sh cal_num_res.sh mapper" \
     -reducer "sh cal_num_res.sh reducer" 
}

if [ $1 == "mapper" ];then

    mapper

elif [ $1 == "reducer" ];then

    reducer

elif [ $1 == "test" ];then
    echo test

    testing

else 

    echo running
    run

fi

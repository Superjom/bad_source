#!/bin/bash

source env.sh

B_DATA_PH=/user/wdbd/working/global_la_wise_test/hlb_download_inner_link_filterbyxpath_1129_pp
C_DATA_PH=/user/wdbd/working/dingrui01/inner_pp/30_big_domain_filter_pp_merge

B_C_MERGE_DATA_PH=/user/wdbd/working/yanchunwei/inner_pp/b_c_merge


TEST_DATA_PH=/user/wdbd/working/yanchunwei/inner_pp/testdata
TEST_DATA_OUTPUT_PH=/user/wdbd/working/yanchunwei/inner_pp/testdata_output



mapper() {
    # change data format
    # the input data include B and C
    # B: tourl \t fromurl
    # C: url \t pp

    awk -F"\t" '{
        if (NF == 11) {
            print $1 "\t" "Bto";
            print $2 "\t" "Bfrom";

        } else {
            print $1 "\t" "C";
        }
    }'
}

reducer() {
    # uniq and Statistics
    awk -F"\t" 'BEGIN {
        key = "";
    }{
        # init key and uniq
        if(key != $0) {
            key = $0;
            print key;
        }
    }' > uniq_urls

    awk -F"\t" 'BEGIN{
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
        

        print "B" "\t" n_B_fromurl "\t" "fromurl";
        print "B" "\t" n_B_tourl "\t" "tourl";
        print "B" "\t" n_B_fromurl_and_tourl "\t" "tourl_and_fromurl";
        print "BC" "\t" n_C_and_B_tourl "\t" "tourl";
        print "BC" "\t" n_C_and_B_fromurl "\t" "fromurl";

    }' uniq_urls > cal_res

    # output res
    cat cal_res uniq_urls
}

run() {

$RP_HADOOP streaming \
     -D mapred.job.name="dingrui_task, B C merge by yanchunwei@baidu.com" \
     -D mapred.job.priority=NORMAL \
     -D mapred.map.tasks=30000 \
     -D mapred.reduce.tasks=30000 \
     -D mapred.job.map.capacity=2000 \
     -D mapred.job.reduce.capacity=2000 \
     -D mapred.reduce.over.capacity.allowed=true \
     -D stream.num.map.output.key.fields=2 \
     -D num.key.fields.for.partition=1 \
     -partitioner org.apache.hadoop.mapred.lib.KeyFieldBasedPartitioner \
     -input $B_DATA_PH \
     -input $C_DATA_PH \
     -output $B_C_MERGE_DATA_PH \
     -file union.sh \
     -file env.sh \
     -mapper "sh union.sh mapper" \
     -reducer "sh union.sh reducer" 
}

testing() {

$RP_HADOOP fs -rmr $TEST_DATA_OUTPUT_PH

$RP_HADOOP streaming \
     -D mapred.job.name="dingrui_task, B C merge by yanchunwei@baidu.com" \
     -D mapred.job.priority=NORMAL \
     -D mapred.map.tasks=30 \
     -D mapred.reduce.tasks=10 \
     -D mapred.job.map.capacity=2000 \
     -D mapred.job.reduce.capacity=2000 \
     -D mapred.reduce.over.capacity.allowed=true \
     -D stream.num.map.output.key.fields=2 \
     -D num.key.fields.for.partition=1 \
     -partitioner org.apache.hadoop.mapred.lib.KeyFieldBasedPartitioner \
     -input $TEST_DATA_PH \
     -output $TEST_DATA_OUTPUT_PH \
     -file union.sh \
     -file env.sh \
     -mapper "sh union.sh mapper" \
     -reducer "sh union.sh reducer" 
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

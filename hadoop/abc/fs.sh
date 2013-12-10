source env.sh

B_DATA_PH=/user/wdbd/working/global_la_wise_test/hlb_download_inner_link_filterbyxpath_1129_pp
C_DATA_PH=/user/wdbd/working/dingrui01/inner_pp/30_big_domain_filter_pp_merge

TEST_DATA_PH=/user/wdbd/working/yanchunwei/inner_pp/testdata
TEST_DATA_OUTPUT_PH=/user/wdbd/working/yanchunwei/inner_pp/testdata_output

#$RP_HADOOP fs -cat $B_DATA_PH/part-00000 |head -n100000 > ./b.sample
#$RP_HADOOP fs -cat $C_DATA_PH/part-00000 |head -n100000 > ./c.sample

#$RP_HADOOP fs -mkdir $TEST_DATA_PH
#$RP_HADOOP fs -put b.sample $TEST_DATA_PH/
#$RP_HADOOP fs -put c.sample $TEST_DATA_PH/
:<<D
$RP_HADOOP fs -get /user/wdbd/working/yanchunwei/inner_pp/testdata_output/part-00000 ./test/
$RP_HADOOP fs -get /user/wdbd/working/yanchunwei/inner_pp/testdata_output/part-00001 ./test/
$RP_HADOOP fs -get /user/wdbd/working/yanchunwei/inner_pp/testdata_output/part-00002 ./test/
$RP_HADOOP fs -get /user/wdbd/working/yanchunwei/inner_pp/testdata_output/part-00003 ./test/
$RP_HADOOP fs -get /user/wdbd/working/yanchunwei/inner_pp/testdata_output/part-00004 ./test/
$RP_HADOOP fs -get /user/wdbd/working/yanchunwei/inner_pp/testdata_output/part-00005 ./test/
$RP_HADOOP fs -get /user/wdbd/working/yanchunwei/inner_pp/testdata_output/part-00006 ./test/
$RP_HADOOP fs -get /user/wdbd/working/yanchunwei/inner_pp/testdata_output/part-00007 ./test/
$RP_HADOOP fs -get /user/wdbd/working/yanchunwei/inner_pp/testdata_output/part-00008 ./test/
$RP_HADOOP fs -get /user/wdbd/working/yanchunwei/inner_pp/testdata_output/part-00009 ./test/
D


$RP_HADOOP fs -ls $B_DATA_PH | wc -l
$RP_HADOOP fs -ls $C_DATA_PH | wc -l

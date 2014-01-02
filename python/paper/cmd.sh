#!/bin/bash
set -x
set -e

source ./env.conf

WAIM_HTML_PH=$PROJECT_ROOT/waim/html

#sites="pcmag"
sites="amazon cnet jr pcconnection pcmag"
goods="mobile camera printer tv notebook"
gen_origin()
{
    for site in $sites; do
        mkdir -p $DATA_ROOT/origin/$site
        cd waim/html
        for good in $goods; do
            mkdir -p $DATA_ROOT/origin/$site/$good
            output_root=$DATA_ROOT/origin/$site/$good
            # get html and clean html tags
            ./getHtmlList.sh -s $site -c $good | awk  '{
                len = split($1,arr,"/");
                print $1, arr[len];
            }'  | while read path fname; do
                html_ph=$WAIM_HTML_PH/$path
                output_ph=$output_root/$fname
                cat $html_ph | $PROJECT_ROOT/analysis/html_2_plain_text.py > $output_ph
            done # while
        done
        cd ../..
    done
}

gen_shingles()
{
    for site in $sites; do
        mkdir -p $DATA_ROOT/shingle/$site
        for good in $goods; do
            mkdir -p $DATA_ROOT/shingle/$site/$good
            inroot=$DATA_ROOT/origin/$site/$good
            toroot=$DATA_ROOT/shingle/$site/$good
            files=`ls -1 $inroot`
            for file in $files; do
                inpath=$inroot/$file
                topath=$toroot/$file
                cat $inpath | $PROJECT_ROOT/analysis/shingle.py > $topath
            done
        done
    done
}

# get all paths in a dir
_get_all_paths()
{
    for file in `ls $1`; do
        #if [ x"$file" != x"." -a x"$file" != x".." ]; then
        if [ -d "$1/$file" ]; then
            _get_all_paths $1"/"$file
        else
            echo $1"/"$file
        fi
    done
}

# site-wise
count_shingle()
{
    mkdir -p $DATA_ROOT/shingle_count

    for site in $sites; do
        inroot=$DATA_ROOT/shingle/$site
        topath=$DATA_ROOT/shingle_count/$site.c
        paths=`_get_all_paths $inroot`
        cat $paths | awk -F"\t" 'BEGIN{
        }{
            for(i=1;i<=NF;i++)
            {
                dic[$i] ++;
            }
        } END {
            for (d in dic) {
                print d "\t" dic[d];
            }
        }' > $topath
    done
}

get_frequent_shingle_paragraphs()
{
    THRESHOLD=5
    toroot=$DATA_ROOT/shingle_frequent_paragraph
    mkdir -p $toroot

    for site in $sites; do
        inpath=$DATA_ROOT/shingle_count/$site.c
        inroot=$DATA_ROOT/shingle/$site
        topath=$toroot/$site.p
        paths=`_get_all_paths $inroot`
        cat $paths | awk -v thre=$THRESHOLD -F"\t" '
            FNR==NR {
                dic[$1]=$2;
            }
            FNR<NR {
                s = 0;
                para = "";
                for(i=1; i<NF; i++) {
                    s += dic[$i];
                    # generate a para
                    if(para) {
                        para = para "\t" $i
                    } else {
                        para = $i;
                    }
                }
                if(s > thre) {
                    print para;
                }
            }' $inpath - > $topath
        done
}

# generate hashs for each site
node_hash()
{
    mkdir -p $DATA_ROOT/nodehash
    for site in $sites; do
        mkdir -p $DATA_ROOT/nodehash/$site
        cd $WAIM_HTML_PH
        for good in $goods; do
            output_root=$DATA_ROOT/nodehash/$site/$good
            mkdir -p $output_root
            ./getHtmlList.sh -s $site -c $good | awk  '{
                len = split($1,arr,"/");
                print $1, arr[len];
            }'  | while read path fname; do
                html_ph=$WAIM_HTML_PH/$path
                output_ph=$output_root/$fname
                cat $html_ph | $PROJECT_ROOT/analysis/html_2_node_hash.py > $output_ph
            done
        done
    done
}

get_frequent_node_hashs()
{
    toroot=$DATA_ROOT/nodehash_count
    mkdir -p  $toroot
    for site in $sites; do
        inroot=$DATA_ROOT/nodehash/$site 
        topath=$toroot/$site.c
        paths=`_get_all_paths $inroot`
        cat $paths | awk 'BEGIN{
        } {
            dic[$1]++;
        } END {
            for (d in dic) {
                print d "\t" dic[d];
            }
        }' > $topath
    done
}

get_uniq_node_txt() 
{
    toroot=$DATA_ROOT/nodehash_txt
    mkdir -p  $toroot
    cd $WAIM_HTML_PH
    for site in $sites; do
        for good in $goods; do
        mkdir -p $toroot/$site
        topath=$toroot/$site/$good.txt
        ./getHtmlList.sh -s $site -c $good | awk -v root=$WAIM_HTML_PH '{
            len = split($1,arr,"/");
            print root "/" $1;
        }' | $PROJECT_ROOT/analysis/get_uniq_node_hash_text.py -f $DATA_ROOT/nodehash_count/$site.c > $topath
        done
    done
}


#gen_origin
#gen_shingles
#count_shingle
#get_frequent_shingle_paragraphs
#node_hash
#get_frequent_node_hashs
get_uniq_node_txt

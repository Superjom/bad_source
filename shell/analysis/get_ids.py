# -*- coding: utf-8 -*-
from __future__ import division
'''
Created on Jul 30, 2013

@author: Chunwei Yan @ pkusz
@mail:  yanchunwei@outlook.com
'''
import re
import sys

def get_id(line):
    r = re.compile("/home/spider/df-hyperlinkbase/hlb-scan/bin/hlb_scan.sh -i /home/spider/yanchunwei/research/sites/(?P<id>\d+)")
    res = r.search(line)
    if res:
        return res.group('id')



if __name__ == "__main__":
    while True:
        line = sys.stdin.readline()
        if not line: break
        id = get_id(line)
        if id:
            sys.stdout.write("%s\n" % id)

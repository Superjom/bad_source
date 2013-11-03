# -*- coding: utf-8 -*-
from __future__ import division
'''
Created on Jul 30, 2013

@author: Chunwei Yan @ pkusz
@mail:  yanchunwei@outlook.com
'''
import sys

def gen_line(id, hid, tail):
    id = id.strip()
    hid = hid.strip()
    sys.stdout.write("%s.%d %s\n" % (id, tail, hid))



if __name__ == "__main__":
    jobids = []
    ids = []

    while True:
        line = sys.stdin.readline()
        if not line: break

        try:
            a = line.index("job")
            jobids.append(line)
        except:
            ids.append(line)


    for i,id in enumerate(ids):
        if 2*i+1 < len(jobids):
            gen_line(id, jobids[2*i], 0)
            gen_line(id, jobids[2*i+1], 1)

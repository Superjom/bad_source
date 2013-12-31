#!/usr/bin/python
# -*- coding: utf-8 -*-
from __future__ import division
'''
Created on Jul 9, 2013

@author: Chunwei Yan @ pkusz
@mail:  yanchunwei@outlook.com
'''
import re
import sys
reload(sys)
sys.setdefaultencoding('utf-8')

SHINGLE_WINDOW = 2
PARAG_TOKEN = re.compile(r"[,.:!?()<>]")


class Shingle(object):

    def __init__(self, cont):
        self.cont = cont

    def __call__(self):
        paras = self.split_paragraph()
        #print 'paras', paras
        shingles = []
        for para in paras:
            shingles.append([s for s in self.gen_shingle(para)])
        return shingles

    def split_paragraph(self):
        return PARAG_TOKEN.split(self.cont)

    def gen_shingle(self, para):
        _ws = []
        ws = para.split()
        for w in ws:
            w = w.strip()
            if w: _ws.append(w)
        ws = _ws
        for i in range(len(ws)-1):
            yield "%s %s" % (ws[i], ws[i+1])
    
if __name__ == '__main__':

    cont = sys.stdin.read()
    #print 'cont:', cont
    shingle = Shingle(cont)
    shingles = shingle()
    shi_cont = "\n".join(
            ["\t".join(s) for s in shingles])
    sys.stdout.write(shi_cont)

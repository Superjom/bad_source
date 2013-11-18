# -*- coding: utf-8 -*-
from __future__ import division
'''
Created on Jul 9, 2013

@author: Chunwei Yan @ pkusz
@mail:  yanchunwei@outlook.com
'''
import sys
reload(sys)
sys.setdefaultencoding('utf-8')

from pyquery import PyQuery as pq

html = sys.stdin.read().decode('utf8')

_pq = pq(html)

_pq('script').remove()
_pq('style').remove()

hashs = []

def hash_from_children(ppq):
    children = ppq.children()
    for i in range( len(children)):
        child = children.eq(i)
        hashs.append( hash(child.html()))
        hash_from_children(child)


dic = {}
hash_from_children(_pq('html'))
for key in hashs:
    dic[key] = dic.get(key, 0) + 1

for key, value in dic.items():
    sys.stdout.write("%d\t%d\n".encode('utf8', 'ignore') % (key, value))

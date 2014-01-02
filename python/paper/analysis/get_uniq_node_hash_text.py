#!/usr/bin/env python
# -*- coding: utf-8 -*-
'''
Created on Aug 9, 2013

@author: Chunwei Yan @ pkusz
@mail:  yanchunwei@outlook.com
'''
from __future__ import division
import re
import sys
reload(sys)
sys.setdefaultencoding('utf-8')

from pyquery import PyQuery as pq
from html_2_node_hash import hash_node

THRE = 5

class FrequentHasher(object):
    def __init__(self, hash_count_ph):
        self.hash_count = {}
        self._init_hash_count(hash_count_ph)
        self.texts = set()

    def parse_html(self, _pq):
        '''
        drop all larger hash
        '''
        #print 'parsing', repr(_pq)
        # clear texts
        hashkey = hash(_pq.text())
        #print 'hashkey', hashkey
        if hashkey != 0:
            #print 'count', self.hash_count[hashkey]
            if self.hash_count[hashkey] > THRE:
                return
            children = _pq.children()
            children = [children.eq(i) for i in range(len(children))]
            #print 'children', children
            for child in children:
                self.parse_html(child)
            # get node's text
            crepr = ' '.join([repr(c) for c in children])
            formats = re.compile(r'\[\<([-a-zA-Z._#]+)\>\]')
            reprs = formats.findall(crepr)
            # drop all child nodes
            for r in reprs:
                try:
                    _pq(r).remove()
                except:
                    pass
                    #print "can't remove: ", r
            txt = _pq.text().strip()
            if txt:
                #print '[@text@]:', txt
                txt.replace('\n', ' ')
                self.texts.add(txt)

            
    def _init_hash_count(self, hash_count_ph):
        with open(hash_count_ph) as f:
            for l in f.readlines():
                ls = l.split('\t')
                if not ls[0]:
                    continue
                key, value = int(ls[0]), int(ls[1])
                self.hash_count[key] = value


if __name__ == "__main__":
    import argparse
    parser = argparse.ArgumentParser(
        description="remove frequent father node and get all text of nodes")
    parser.add_argument('-f', action='store', dest='fpath',
            help='path of hash count')
    if len(sys.argv) == 1:
        parser.print_help()
        exit(-1)
    args = parser.parse_args()

    frequent_hasher = FrequentHasher(args.fpath) 
    paths = sys.stdin.read().split()
    for path in paths:
        with open(path) as f:
            c = f.read().decode('utf8', 'ignore')
            if not c.strip():
                continue
            _pq = pq(c)
            _pq('script').remove()
            _pq('style').remove()

            body = _pq('body')
            title = _pq('title')
            frequent_hasher.parse_html(body)
            frequent_hasher.parse_html(title)
        
        sys.stdout.write('\n'.join(frequent_hasher.texts))
        sys.stdout.write('\n')

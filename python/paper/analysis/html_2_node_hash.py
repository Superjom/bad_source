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

from pyquery import PyQuery as pq

def hash_node_include_childnodes(body, hashs):
    hashkey = hash(body.text())
    if hashkey != 0:
        hashs.append(str(hashkey))

    children = body.children()
    children = [children.eq(i) for i in range(len(children))]
    for child in children:
        hash_node_include_childnodes(child, hashs)


def hash_node(body, hashs):
    children = body.children()
    children = [children.eq(i) for i in range(len(children))]
    crepr = ' '.join([repr(c) for c in children])
    formats = re.compile(r'\[\<([-a-zA-Z._#]+)\>\]')
    reprs = formats.findall(crepr)
    for r in reprs:
        try:
            body(r).remove()
        except:
            pass
            #print "can't remove: ", r
    #print 'node', body.text()
    hashkey = hash(body.text().strip())
    if hashkey != 0:
        hashs.append(str(hashkey))
    #print 'crepr', crepr
    #print 'reprs', reprs
    for child in children:
        if child:
            hash_node(child, hashs)


if __name__ == '__main__':

    html = sys.stdin.read().decode('utf8', 'ignore')

    hashs = []
    _pq = pq(html)

    _pq('script').remove()
    _pq('style').remove()


    body = _pq('body')
    title = _pq('title')

    hash_node_include_childnodes(body, hashs)
    hash_node_include_childnodes(title, hashs)

    sys.stdout.write('\n'.join(hashs))
    sys.stdout.write('\n')

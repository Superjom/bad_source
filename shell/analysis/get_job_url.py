# -*- coding: utf-8 -*-
from __future__ import division
'''
Created on Jul 30, 2013

@author: Chunwei Yan @ pkusz
@mail:  yanchunwei@outlook.com
'''
import re
import sys
from urlparse import urljoin


base = "http://szjjh-hlb-job.dmop.baidu.com:8031/jobhistory.jsp"

def get_url(content):
    r = re.compile('</td><td><a href="(?P<url>.+)"')
    res = r.search(content)
    url =  res.group('url')
    return urljoin(base, url)

if __name__ == "__main__":
    cont = sys.stdin.read()
    url = get_url(cont)
    sys.stdout.write("%s\n" % url)

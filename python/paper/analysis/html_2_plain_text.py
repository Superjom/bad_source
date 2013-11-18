# -*- coding: utf-8 -*-
'''
Created on Jul 9, 2013

@author: Chunwei Yan @ pkusz
@mail:  yanchunwei@outlook.com
'''
from __future__ import division

import sys
reload(sys)
sys.setdefaultencoding('utf-8')

from pyquery import PyQuery as pq


html = sys.stdin.read()

_pq = pq(html.decode('utf8'))

_pq('script').remove()
_pq('style').remove()

text = _pq.text()

sys.stdout.write(text + "\n")

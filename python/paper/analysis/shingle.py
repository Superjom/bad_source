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

SHINGLE_WINDOW = 4

content = sys.stdin.read()

cs = content.split()

for i in range( len(cs)-SHINGLE_WINDOW + 1):
    sys.stdout.write("%s\n" % ' '.join(cs[i:i+SHINGLE_WINDOW]))

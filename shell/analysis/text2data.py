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
import time
import datetime


# parse string to int
def s2d(s):
    s = s.strip()
    s = s.replace(",", "")
    return int(s)

def line_search(line, s):
    try:
        pos = line.index(s)
        return pos
    except:
        return -1

def s2time(s):

    s = s.replace("(", "")
    s = s.replace(")", "")
    s = s.strip()

    if "hour" in s:
        form = "%Hhour, %Mmins,%Ssec" 
    elif "min" in s:
        form = "%Mmins, %Ssec"
    elif "sec" in s:
        form = "%Ssec"
    else:
        raise
    x = time.strptime(s, form)
    return datetime.timedelta(hours=x.tm_hour,minutes=x.tm_min,seconds=x.tm_sec).total_seconds()


class Text2Data(object):
    def __init__(self, text):
        self.match = []
        self.times = []

        #print text
        time_r = re.compile("\([0-9,minsechour ]+\)")
        times = re.findall(time_r, text)
        #print 'times : ', times
        for t in times:
            self.times.append(
                s2time(t))
        text = time_r.sub(" ", text)

        ws = text.split()
        self.ws = ws
        r = re.compile("^[0-9,]+$")
        for w in ws:
            if r.match(w):
                self.match.append(s2d(w))


        #print "time:",self.times

        if len(self.match) == 27+16:
            pass
        elif len(self.match) == 27+16+3:
            del self.match[3:6]
        else:
            self.match = [-1 for i in range(100)]

    @property
    def MapInputRecords(self):
        return self.match[18]

    @property
    def MapInputBytes(self):
        return self.match[21]

    @property
    def MapOutputRecords(self):
        return self.match[24]

    #@property
    #def MapOutputBytes(self):
    #    return self.match[53]

    @property
    def MapTotalTasks(self):
        return self.match[31]

    @property
    def MapSuccessfulTasks(self):
        return self.match[32]

    @property
    def Time(self):
        return self.times[0]

    def show(self):
        '''
        for i,v in enumerate(self.match):
            print i, v
        '''

        propertys = [
            'MapInputRecords',
            'MapInputBytes',
            'MapOutputRecords',
            'MapTotalTasks',
            'MapSuccessfulTasks',
            'Time',
        ]

        for p in propertys:
            sys.stdout.write("%d\t" %  getattr(self, p))
        sys.stdout.write("\n")

if __name__ == "__main__":
    content = sys.stdin.read()
    if not content: sys.exit(-1)

    t = Text2Data(content)
    t.show()

# -*- coding: utf-8 -*-
from __future__ import division
import sys
sys.path.append('../../')
import re
import time
import random
import urlparse as up
from scrapy.contrib.spiders import CrawlSpider, Rule
from scrapy.contrib.linkextractors.sgml import SgmlLinkExtractor
from scrapy.exceptions import CloseSpider
from scrapy.http.request import Request
from scrapy.spider import BaseSpider
from scrapy.selector import HtmlXPathSelector
from spider.items import SpiderItem
'''
Created on Jul 30, 2013

@author: Chunwei Yan @ pkusz
@mail:  yanchunwei@outlook.com
'''

root = "/home/chunwei/bad_source/python/paper/spider/spider/spiders"

init_start_urls = [
        "http://www.pcmag.com/products/26635/1", ]


list_url_format = '//div[contains(@class,"paging")]/a[contains(@href,"products")]/@href'

allowed_url = r"http://www.pcmag.com/products/26635/[0-9]+"

init_allowed_domains = [
        "www.pcmag.com"
]

content_url_format = '//div[contains(@class,"product-item")]/div[contains(@class,"text")]/div[contains(@class,"title")]/label/a/@href'

MAX_SLEEP_TIME = 20

class SpiderSpider(CrawlSpider):
    count = 0
    name = "pcmag_tv"

    dic = set()

    allowed_domains = init_allowed_domains

    start_urls = init_start_urls

    rules = (
        #only extract links here
        Rule(SgmlLinkExtractor(allow=allowed_url), callback="parse"),
    )

    @property
    def sleep_time(self):
        return random.random() * MAX_SLEEP_TIME

    def parse(self, response):
        '''
        extract
        title
        content
        url
        '''
        print '>'*50
        print 'response url: ', response.url
        hxs = HtmlXPathSelector(response)
        print '>>>> repsonse.url: ', response.url
        #get urls
        content_urls = hxs.select(content_url_format).extract()

        list_urls = hxs.select(list_url_format).extract()
        list_urls = [ up.urljoin(response.url, url) for url in list_urls]
        content_urls = [ up.urljoin(response.url, url) for url in content_urls]
        
        print "@" * 60 
        time.sleep(self.sleep_time)
        self.start_urls.extend(list_urls)

        for url in list_urls:
            yield Request(url, self.parse)

        content_re = re.compile(r'http://www[.]pcmag[.]com/article.*')
        for url in content_urls:
            if content_re.match(url):
                if len(self.dic) > 160:
                    self.start_urls = []
                    raise CloseSpider('reach pages limit, end the spider.')

                self.count += 1
                self.dic.add( hash(url))
                #extract data
                item = SpiderItem()
                item['url'] = url
                item['kind'] = self.name
                yield item
            else:
                print "!!!!!!! not match content url:"
                print url

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

allowed_url = r'http://www.amazon.com/s/.*keywords=camera.*'

content_url_format = '//h3[contains(@class,"newaps")]/a[contains(@href,"amazon.com")]/@href'

init_start_urls = [
        "http://www.amazon.com/s/ref=nb_sb_noss_2?url=search-alias%3Delectronics&field-keywords=camera+&rh=n%3A172282%2Ck%3Acamera+",
]

init_allowed_domains = [
    "amazon.com",
]

MAX_SLEEP_TIME = 20

class SpiderSpider(CrawlSpider):
    count = 0
    name = "amazon_camera"

    allowed_domains = init_allowed_domains

    start_urls = init_start_urls

    rules = (
        #only extract links here
        #Rule(SgmlLinkExtractor(allow=allowed_url)),
        #extract content here and parse urls
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
        list_urls = hxs.select('//span[contains(@class,"pagnLink")]/a[contains(@href,"keywords=camera")]/@href').extract()
        list_urls = [ up.urljoin(response.url, url) for url in list_urls]
        print "@" * 60 
        print "urls: ", len(content_urls)
        time.sleep(self.sleep_time)
        self.start_urls.extend(content_urls)
        self.start_urls.extend(list_urls)

        for url in content_urls + list_urls:
            yield Request(url, self.parse)


        content_re = re.compile(r'http://www.amazon.com/[^s]+.*&keywords=camera')
        if content_re.match(response.url):
            if self.count > 240:
                self.start_urls = []
                raise CloseSpider('reach pages limit, end the spider.')

            self.count += 1
            #extract data
            body = hxs.select('//body').extract()
            if body:
                item = SpiderItem()
                item['body'] = body[0]
                item['kind'] = self.name
                yield item

if __name__ == "__main__":
    pass


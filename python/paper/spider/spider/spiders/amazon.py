# -*- coding: utf-8 -*-
from __future__ import division
import sys
sys.path.append('../../')
from scrapy.contrib.spiders import CrawlSpider, Rule
from scrapy.contrib.linkextractors.sgml import SgmlLinkExtractor
from scrapy.http.request import Request
from scrapy.spider import BaseSpider
from scrapy.selector import HtmlXPathSelector
from spider.items import SpiderItem
'''
Created on Jul 30, 2013

@author: Chunwei Yan @ pkusz
@mail:  yanchunwei@outlook.com
'''

base_url = r'http://www.amazon.com/*'
content_base_url = r'http://www.amazon.com/.*keywords=TV'
url_rule = '//div[contains(@class,"seeMoreVariations")]/a[contains(@href,"amazon.com")]/@href'

init_start_urls = [
        "http://www.amazon.com/s/ref=nb_sb_noss/178-6954069-3270748?url=search-alias%3Daps&field-keywords=TV", 
]

init_allowed_domains = [
    "amazon.com",
]

class ASpider(CrawlSpider):
    count = 0
    name = "amazon"

    allowed_domains = init_allowed_domains

    start_urls = init_start_urls

    rules = (
        #only extract links here
        Rule(SgmlLinkExtractor(allow=base_url)),
        #extract content here
        Rule(SgmlLinkExtractor(allow=content_base_url), callback="parse"),
    )

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
        urls = hxs.select(url_rule).extract()
        urls = [url for url in urls if "keywords=TV" in url]
        print "@" * 60 
        print "urls: ", urls
        self.start_urls.extend(urls)
        
        for url in urls:
            yield Request(url, self.parse)
        #extract data
        item = SpiderItem()
        body = hxs.select('//body').extract()
        if body: 
            item['body'] = body[0]
            item['kind'] = 'amazon'

        yield item






if __name__ == "__main__":
    pass


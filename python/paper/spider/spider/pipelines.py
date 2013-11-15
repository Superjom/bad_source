# Define your item pipelines here
#
# Don't forget to add your pipeline to the ITEM_PIPELINES setting
# See: http://doc.scrapy.org/en/latest/topics/item-pipeline.html
import os
from scrapy.exceptions import DropItem

class SpiderPipeline(object):

    base_dir = "/home/chunwei/download_html/"
    counts = {}

    def process_item(self, item, spider):
        if item.has_key('url'):
            print 'get url:', item['url'] 
            kind = item['kind']
            path = os.path.join(self.base_dir, kind)

            with open(path, 'a') as f:
                f.write(item['url'].encode('utf8')+"\n")

            return item
        else:
            raise DropItem("Error, no content")

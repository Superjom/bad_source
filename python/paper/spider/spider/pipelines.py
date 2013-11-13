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
        if item.has_key('body'):
            print 'crawl body:', len(item['body'])
            kind = item['kind']
            self.counts[kind] = self.counts.get(kind, 0) + 1
            path = os.path.join(self.base_dir, kind, str(self.counts[kind]))

            with open(path, 'w') as f:
                print '... write to file %d' % self.counts[kind]
                f.write(item['body'].encode('utf8'))

            return item
        else:
            raise DropItem("Error, no content")

# Define here the models for your scraped items
#
# See documentation in:
# http://doc.scrapy.org/en/latest/topics/items.html

from scrapy.item import Item, Field

class SpiderItem(Item):
    # define the fields for your item here like:
    # name = Field()
    url = Field()
    kind = Field()

    def __str__(self):
        return "get url" 

if __name__ == "__main__":
    pass

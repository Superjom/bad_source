from HTMLParser import HTMLParser
import re
from re import sub
from sys import stderr
from traceback import print_exc
"""
parse html  to  text
and get last line
"""

class _DeHTMLParser(HTMLParser):
    def __init__(self):
        HTMLParser.__init__(self)
        self.__text = []

    def handle_data(self, data):
        text = data.strip()
        if len(text) > 0:
            text = sub('[ \t\r\n]+', ' ', text)
            self.__text.append(text + ' ')

    def handle_starttag(self, tag, attrs):
        if tag == 'p':
            self.__text.append('\n\n')
        elif tag == 'br':
            self.__text.append('\n')

    def handle_startendtag(self, tag, attrs):
        if tag == 'br':
            self.__text.append('\n\n')

    def text(self):
        return ''.join(self.__text).strip()


def html2text(text):
    try:
        parser = _DeHTMLParser()
        parser.feed(text)
        parser.close()
        return parser.text()
    except:
        print_exc(file=stderr)
        return text


if __name__ == '__main__':
    import sys
    content = sys.stdin.read()
    if not content: sys.exit(-1)
    text = html2text(content)

    ls = text.split("\n")
    text = ls[-1]
    sys.stdout.write("%s\n" % text)
